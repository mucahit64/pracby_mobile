# Pracby — Mobile App Geliştirme Dökümantasyonu

> Bu doküman, Pracby platformunun backend API'lerini, veri modellerini, iş akışlarını ve mobile app geliştirirken ihtiyaç duyulacak teknik bilgileri kapsar.
> Son güncelleme: 14 Ekim 2026 — `src/` altındaki backend kodu ve web istemcisi (`client/`) baz alınmıştır.

---

## 1. Genel Mimari

```
Mobile App
    │
    ▼
REST API (Express.js — Node.js)
Base URL: /api
    │
    ├── /auth          → Kimlik Doğrulama
    ├── /exam-groups   → Sınav Grupları
    ├── /modules       → Modüller (Oturumlar)
    ├── /courses       → Dersler
    ├── /quiz          → Quiz Sistemi
    ├── /users         → Kullanıcı Profili
    ├── /leaderboard   → Liderlik Tablosu
    ├── /store         → Mağaza
    ├── /friends       → Arkadaşlık
    ├── /notifications → Bildirimler
    └── /admin         → Yönetim (mobil için gerekli değil)
    │
    ▼
PostgreSQL (Knex.js)
```

### Auth Yöntemi
- **JWT Token** (Bearer token, 7 gün geçerli, payload: `{ userId, username }`)
- Header: `Authorization: Bearer <token>`
- Refresh token mekanizması yok — `401` alındığında kullanıcı yeniden giriş yapmalı.
- Rate limit: `/api/auth/*` endpointlerine IP başına dakikada maksimum 10 istek.

### Erişim Seviyeleri
| Seviye | Açıklama | Endpointler |
|--------|----------|-------------|
| Public | Token gerekmez | `/auth/*` (merge hariç), `/exam-groups`, `/quiz/guest-start`, `/health` |
| Optional | Token varsa kullanıcıya özel veri eklenir | `/modules`, `/courses`, `/store/items` |
| Auth | Token zorunlu | Diğer tüm endpointler |

---

## 2. Sağlık Kontrolü

```
GET /api/health
```

**Response (200):**
```json
{ "status": "ok", "timestamp": "2026-10-14T10:00:00.000Z" }
```

**Response (503 — DB bağlantısı yok):**
```json
{ "status": "unhealthy", "timestamp": "2026-10-14T10:00:00.000Z" }
```

---

## 3. Kimlik Doğrulama — `/api/auth`

### 3.1 Kayıt

```
POST /api/auth/register
```

**Request Body:**
```typescript
{
  email: string;                  // Geçerli e-posta
  username: string;               // 3-20 karakter; küçük harf, rakam, "." ve "_"
                                  // Harf/rakam ile başlayıp bitmeli, ".." / "__" / "._" olamaz
  password: string;               // Min 6 karakter
  exam_type_id?: string;          // UUID — verilmezse "lisans" (KPSS Lisans) atanır
  acorn_balance?: number;         // Başlangıç acorn — default: 500
  energy?: number;                // 0-25 — default: 25
  guest_data?: {                  // Misafir ilerlemesini hesaba aktar
    quiz_results?: Array<{
      topicId: string;
      stepId?: string;
      testId?: string;
      correctCount: number;
      totalQuestions: number;
    }>;
    claimed_reward_step_ids?: string[];
  };
}
```

> Misafir modunda biriken acorn/enerji, kayıtta `acorn_balance` ve `energy` alanlarıyla gönderilir (web istemcisi böyle yapıyor).

**Response (201):**
```typescript
{
  user: {
    id: string;             // UUID
    email: string;
    username: string;
    active_exam_type_id: string | null;
    created_at: string;     // ISO 8601
  };
  token: string;            // JWT
}
```

**İş Kuralları:**
- Kayıt tek bir transaction içinde yapılır; `user_stats` satırı ve seçilen sınava `enrollment` otomatik oluşturulur.
- `guest_data` içindeki **tüm** `stepId`'ler veritabanında mevcut olmalıdır. Biri bile geçersizse misafir verisinin tamamı yok sayılır (kayıt yine başarılı olur, ilerleme aktarılmaz).
- Aktarılan her quiz sonucu için `correctCount` kadar XP eklenir.

**Hata Kodları:**
- `400` — Validasyon hatası
- `409` — `Email already in use` / `Username already taken`
- `500` — Varsayılan rol bulunamadı (RBAC seed çalıştırılmamış)

---

### 3.2 Giriş

```
POST /api/auth/login
```

**Request Body:**
```typescript
{
  identifier: string;   // Email veya kullanıcı adı ("@" içeriyorsa email kabul edilir)
  password: string;
}
```

**Response (200):**
```typescript
{
  user: {
    id: string;
    email: string;
    username: string;
    role: string | null;        // "student" | "teacher" | "admin"
    permissions: string[];
  };
  token: string;
}
```

> **Not:** Login yanıtında `active_exam_type_id`, enerji ve acorn bilgisi **yoktur**. Girişten hemen sonra `GET /api/users/me` çağrılmalıdır.

**Hata Kodları:**
- `401` — `Invalid credentials`

---

### 3.3 Email / Kullanıcı Adı Kontrolü

```
GET /api/auth/check-email?email=test@mail.com
GET /api/auth/check-username?username=john123
```

**Response:**
```json
{ "available": true }
```

**Hata Kodları:**
- `400` — Parametre eksik (`email required` / `username required`)

---

### 3.4 Şifre Sıfırlama

```
POST /api/auth/forgot-password
Body: { "email": "user@mail.com" }
```

**Response (200):** Kullanıcı var olsun ya da olmasın aynı yanıt döner (enumeration koruması).
```json
{ "message": "Eğer bu e-posta kayıtlıysa, şifre sıfırlama bağlantısı gönderildi." }
```

- E-posta Resend üzerinden gönderilir. Link formatı: `{APP_URL}/auth/reset-password?token=<64 karakter hex>`
- Token **1 saat** geçerlidir ve tek kullanımlıktır. Yeni talep, önceki kullanılmamış tokenları iptal eder.
- Link web uygulamasına gider. Mobilde açmak için bu URL için **universal link / app link** tanımlanmalı (`/auth/reset-password` yolu yakalanıp `token` query parametresi okunmalı).

```
POST /api/auth/reset-password
Body: { "token": "<64 char hex token>", "password": "newpassword" }
```

**Response (200):**
```json
{ "message": "Şifren başarıyla güncellendi." }
```

**Hata Kodları:**
- `400` — `Geçersiz veya süresi dolmuş bağlantı` ya da validasyon hatası

---

### 3.5 Misafir İlerlemesi Birleştirme (Auth Gerekli)

Zaten hesabı olan bir kullanıcı misafir olarak çözdüğü testlerden sonra **giriş yaptığında** kullanılır (kayıtta ise `guest_data` kullanılır).

```
POST /api/auth/merge-guest-progress
Authorization: Bearer <token>
```

**Request Body:**
```typescript
{
  quiz_results?: Array<{        // default: []
    topicId: string;
    stepId?: string;
    testId?: string;
    correctCount: number;
    totalQuestions: number;
  }>;
  claimed_rewards?: string[];   // Açılan ödül adımlarının step ID listesi — default: []
  earned_acorns?: number;       // Misafirken kazanılan acorn — default: 0
}
```

**Response (200):**
```typescript
{ merged: false }   // Aktarılacak bir şey yoksa
// veya
{ merged: true; xp_awarded: number; acorns_awarded: number }
```

**İş Kuralları:**
- Bir `stepId` bile geçersizse adım ilerlemesi ve ödüller aktarılmaz; `earned_acorns` yine de eklenir.
- Mevcut ilerlemeden daha ileride olmayan adımlar için XP verilmez (çift sayım önlenir).

---

## 4. Sınav Grupları — `/api/exam-groups`

```
GET /api/exam-groups
```

**Response:**
```typescript
Array<{
  id: string;
  name: string;       // "KPSS", "YKS"
  slug: string;       // "kpss", "yks"
  description: string;
  sort_order: number;
  is_active: boolean;
  exam_types: Array<{
    id: string;
    exam_group_id: string;
    name: string;     // "KPSS Lisans", "KPSS Önlisans", "KPSS Ortaöğretim"
    slug: string;     // "lisans", "onlisans", "ortaogretim"
    description: string;
    sort_order: number;
    is_active: boolean;
  }>;
}>
```

**Notlar:**
- Aktif/pasif **tüm** gruplar döner; pasif gruplar UI'da "Çok Yakında" olarak gösterilmelidir.
- Pasif grupların `exam_types` dizisi her zaman **boştur** (kayıt olunamaz).
- Güncel durum: **KPSS aktif** (Lisans, Önlisans, Ortaöğretim). **YKS pasif** (TYT, AYT, YDT).

---

## 5. Modüller (Oturumlar) — `/api/modules`

```
GET /api/modules?exam_type_id=<uuid>
GET /api/modules/:id
```

- `exam_type_id` zorunludur (yoksa `400`). Sadece `is_active: true` modüller döner.
- KPSS türlerinin her biri için iki modül vardır: **Genel Yetenek** (🧠) ve **Genel Kültür** (📚).

**Response (Liste):**
```typescript
Array<{
  id: string;
  exam_type_id: string;
  name: string;           // "Genel Yetenek", "Genel Kültür"
  description: string;
  icon_url: string;       // Emoji (ör. "🧠")
  sort_order: number;
  is_active: boolean;
  created_at: string;
}>
```

**Response (Detay):** Modül alanları + `courses: Course[]`

---

## 6. Dersler — `/api/courses`

Misafir kullanıcılar da bu endpointlere erişebilir (opsiyonel auth).

### 6.1 Ders Listesi

```
GET /api/courses?module_id=<uuid>
GET /api/courses?exam_type_id=<uuid>
```

- `module_id` verilirse `exam_type_id` yok sayılır. İkisi de verilmezse tüm dersler döner.

**Response:**
```typescript
Array<{
  id: string;
  name: string;         // "Türkçe", "Matematik", "Tarih", "Coğrafya", "Vatandaşlık" ...
  description: string;
  icon_url: string;     // Emoji (ör. "📝")
  color: string;        // Hex renk kodu (ör. "#3b82f6")
  sort_order: number;
  exam_type_id: string | null;
  module_id: string | null;
}>
```

### 6.2 Ders Detayı

```
GET /api/courses/:id
```

**Hata Kodları:** `404` — `Course not found`

### 6.3 Dersin Konuları

```
GET /api/courses/:id/topics
```

**Response:** `Array<Topic>` — sadece `status: "approved"` konular, `sort_order` sıralı.

### 6.4 Tam Ders Detayı (İlerleme Dahil) — Ana Ekran İçin

```
GET /api/courses/:id/full
Authorization: Bearer <token>  (opsiyonel — varsa ilerleme eklenir)
```

**Response:**
```typescript
{
  // ...Course alanları
  topics: Array<{
    id: string;
    course_id: string;
    name: string;
    description: string;
    icon_url: string;
    sort_order: number;
    total_lessons: number;
    max_crown_level: number;
    unlock_after: string | null;
    status: "approved";
    created_by: string | null;
    steps: Array<{
      id: string;
      topic_id: string;
      name: string;                 // Seed içerikte boş string
      description: string;
      sort_order: number;
      tests_required: number;       // lesson: 1, reward: 0
      step_type: "lesson" | "reward";
      reward_type: "acorn" | "store_item" | null;
      reward_amount: number | null; // Seed içerikte reward adımları 10 acorn
      reward_item_id: string | null;
      created_at: string;
      updated_at: string;
      progress: UserStepProgress | null;  // null = kullanıcı başlamamış / misafir
    }>;
    progress: UserTopicProgress | null;   // Şu an her zaman null (bkz. Bölüm 17)
  }>;
}
```

**Kilit (unlock) Mantığı:** Backend adım/konu kilidini **zorlamaz**. Web istemcisi bir adımı, önceki adım `progress.is_step_completed === true` ise açık gösterir. Mobil istemci de aynı mantığı client-side uygulamalıdır. Misafir kullanıcılar için ilerleme cihazda tutulan `quiz_results` / `claimed_reward_step_ids` verisiyle overlay edilir.

---

## 7. Quiz Sistemi — `/api/quiz`

### 7.1 Misafir Quiz Başlatma (Auth Gerekmez)

```
GET /api/quiz/guest-start?topicId=<uuid>&stepId=<uuid>&testId=<uuid>
```

- `topicId` zorunlu (yoksa `400`). `sessionType` parametresi kabul edilir ama misafir modunda final testleri yoktur.
- Soru seçimi: `testId` → o testin soruları (sıralı); `stepId` → adımın ilk testinin soruları; yalnızca `topicId` → konudan rastgele 10 soru.
- Sunucuda oturum oluşturulmaz. Sonuç, enerji ve acorn tamamen **cihazda** tutulur (bkz. 15.2).

**Response:**
```typescript
{ questions: Array<QuestionWithAnswers> }
```

### 7.2 Quiz Oturumu Başlatma (Auth Gerekli)

```
POST /api/quiz/start
Authorization: Bearer <token>
```

**Request Body:**
```typescript
{
  topicId: string;       // UUID
  stepId?: string;       // UUID
  testId?: string;       // UUID
  sessionType?: "lesson" | "review" | "practice" | "step_final" | "topic_final";  // default: "lesson"
}
```

**Soru Seçim Mantığı (öncelik sırasıyla):**
| Koşul | Sorular |
|-------|---------|
| `sessionType = topic_final` | Konunun tüm sorularından zorluk dağılımı: 2×K1 + 7×K2 + 6×K3 (rastgele, max 15) |
| `sessionType = step_final` + `stepId` + `testId` | Belirtilen testin soruları (sıralı) |
| `sessionType = step_final` + `stepId` | Adımın sorularından zorluk dağılımı: 2×K1 + 7×K2 + 6×K3 |
| `testId` | Testin tüm soruları, `sort_order` sıralı |
| `stepId` | Adımın ilk testinin tüm soruları (test yoksa adımdan rastgele 10) |
| Yalnızca `topicId` | Konudan rastgele 10 soru (`review` / `practice` bu yolu kullanır) |

> Web istemcisi normal derslerde `topicId + stepId + testId` ile `lesson` oturumu başlatır. Şu anki içerikte her lesson adımında tek bir test vardır.

**Response (201):**
```typescript
{
  session: QuizSession;               // session.id sonraki isteklerde kullanılır
  questions: Array<QuestionWithAnswers>;
}
```

**Hata Kodları:**
- `403` — Enerji bitti (`unlimited_energy` efekti yoksa ve enerji 0 ise). Web istemcisi bu durumda enerji satın alma diyaloğu açar.
- `404` — `Topic not found` / `No questions available`

---

### 7.3 Soru Formatı (Client'a Gelen)

```typescript
interface QuestionWithAnswers extends Question {
  answers: Array<{
    id: string;
    question_id: string;
    answer_text: string;      // HTML içerebilir
    is_correct: boolean;      // ⚠️ Doğru cevap client'a gönderilir
  }>;                         // Sadece multiple_choice / true_false / swipe için dolu, diğerlerinde []
}
```

**Önemli Render Notları:**
- `question_text` ve `answer_text` **HTML içerebilir**. Web istemcisi şu etiketlere izin verir: `p, ul, ol, li, b, strong, i, em, u, br, sup, sub, span`. Mobilde bir HTML renderer (ör. `react-native-render-html`, Flutter `flutter_html`) kullanılmalı ve aynı whitelist ile sanitize edilmelidir.
- `image_url` **göreli bir yoldur** (ör. `QuestionsImage/kpss/matematik/xxx.png`) ve API'den değil **web sunucusundan** servis edilir: `https://<web-domain>/<image_url>`.
- `exam_source` doluysa sorunun çıkmış soru kaynağıdır (ör. `"2024 KPSS-LİSANS"`) — rozet olarak gösterilir.
- `explanation` cevaptan sonra, `hint` isteğe bağlı ipucu olarak gösterilir.
- `is_correct` client'a geldiği için anlık geri bildirim (doğru/yanlış, enerji düşüşü) sunucuya gitmeden gösterilebilir. Web istemcisi böyle çalışır ve sonuçları sonda toplu gönderir.
- Şu anki içerikteki tüm sorular `multiple_choice`'tur; diğer soru tipleri backend tarafından desteklenir ama henüz içerik yoktur.

---

### 7.4 Tekil Cevap Gönderme

```
POST /api/quiz/:sessionId/answer
Authorization: Bearer <token>
```

**Request Body (`AnswerInput`):**
```typescript
{
  questionId: string;           // UUID
  answerId?: string;            // UUID — multiple_choice, true_false, swipe için
  isSkipped?: boolean;          // default: false
  timeSpent?: number;           // Milisaniye (int, >= 0)
  answeredAt?: string;          // ISO 8601 datetime (client-side)
  textAnswer?: string;          // fill_blank — max 500 karakter, büyük/küçük harf duyarsız
  matchingAnswer?: Array<{      // matching — her leftIndex, aynı indexteki rightIndex ile eşleşmeli
    leftIndex: number;
    rightIndex: number;
  }>;
  orderedIndices?: number[];    // ordering — kullanıcının sırası
  isCorrect?: boolean;          // flashcard — client-side değerlendirme
}
```

**Response:**
```typescript
{
  isCorrect: boolean;
  energy_remaining: number;     // 0-25
}
```

**Hata Kodları:** `404` (oturum/soru yok), `400` (`Session already finished`)

> Yanlış cevapta (atlanmadıysa) enerji 1 azalır, `unlimited_energy` aktifse azalmaz.
> **Önerilen akış** tekil gönderim değil, 7.6'daki toplu bitirmedir (web istemcisi tekil endpoint'i kullanmıyor).

---

### 7.5 Oturum Bitirme (Tekil Cevaplardan Sonra)

```
POST /api/quiz/:sessionId/finish
Authorization: Bearer <token>
Body (opsiyonel): { "skip_rewards": boolean }
```

**Response:** 7.6 ile aynı format. Tekrar çağrılırsa `400 Session already finished`.

---

### 7.6 Toplu Cevap Gönderip Bitirme (Önerilen)

```
POST /api/quiz/:sessionId/finish-bulk
Authorization: Bearer <token>
```

**Request Body:**
```typescript
{
  answers: Array<AnswerInput>;   // 7.4'teki format
  skip_rewards?: boolean;        // default: false
}
```

**Response (200):**
```typescript
{
  // QuizSession alanlarının tamamı (güncellenmiş hali):
  id: string;
  user_id: string;
  topic_id: string;
  step_id: string | null;
  test_id: string | null;
  session_type: string;
  is_final_test: boolean;
  started_at: string;
  finished_at: string;
  score: number;
  xp_earned: number;
  duration: number;              // Saniye (started_at → şimdi)
  total_questions: number;       // Gönderilen cevap sayısına eşitlenir
  correct_answers: number;
  energy_lost: number;
  // Ek alanlar:
  acorn_earned: number;
  step_completed: boolean;       // Bu oturumla adım İLK KEZ tamamlandıysa true
  topic_completed: boolean;      // Konudaki tüm lesson adımları tamamlandıysa true
}
```

**İş Kuralları:**
- Doğruluk sunucuda yeniden hesaplanır; client'ın `isCorrect` alanı yalnızca `flashcard` için dikkate alınır.
- Her yanlış (atlanmamış) cevap için enerji düşülür (`unlimited_energy` yoksa), en az 0'a kadar.
- **İdempotent:** Oturum zaten bitmişse mevcut oturum `acorn_earned: 0, step_completed: false, topic_completed: false` ile döner. Ağ hatasında güvenle tekrar denenebilir.
- `skip_rewards: false` iken:
  - XP = doğru soruların `point_value` toplamı (şu an her soru 1 XP)
  - Acorn = doğru cevap sayısı
  - `quizzes_completed`, streak ve `streak_history` güncellenir
  - `step_id` varsa adım **tamamlandı** işaretlenir (geçme barajı yoktur; bitirmek yeterli) ve `best_score` (yüzde) güncellenir
- `skip_rewards: true` iken XP/acorn/streak/adım ilerlemesi işlenmez (enerji düşümü yine uygulanır).
- Başarımlar her bitirmede kontrol edilir; kazanılan her başarım için **+5 acorn** verilir. Yanıtta yeni başarım listesi **dönmez** — gerekirse `GET /api/users/me/achievements` ile karşılaştırılmalı.

**Web İstemcisinin Kullanımı:**
- Enerji quiz sırasında 0'a düşerse quiz kapatılır ve `skip_rewards: true` gönderilir.
- Kullanıcı quizden çıkarsa: `{ answers: [], skip_rewards: true }` ile oturum kapatılır.
- İstek ağ hatasıyla başarısız olursa cevaplar yerelde saklanır (`pb_pending_quiz`) ve uygulama açıldığında/online olunca tekrar gönderilir. Mobilde de aynı offline kuyruk önerilir.

---

### 7.7 Ödül Talep Etme

```
POST /api/quiz/reward/:stepId/claim
Authorization: Bearer <token>
```

**Response (200):**
```typescript
{ type: "acorn"; amount: number }
| { type: "store_item"; itemName: string }
| { type: "none" }
```

> Yanıtta güncel bakiye **dönmez**; client bakiyeyi `amount` kadar artırmalı veya `GET /api/users/me` çağırmalıdır.

**Hata Kodları:**
- `404` — `Reward step not found` (adım yok veya `reward` tipinde değil)
- `400` — `Reward already claimed`
- `403` — `Previous step not completed` (bir önceki lesson adımı tamamlanmamış)

---

### 7.8 Soru Şikayeti

```
POST /api/quiz/report-question
Authorization: Bearer <token>
```

**Request Body:**
```typescript
{
  questionId: string;
  reason: "wrong_answer" | "unclear_question" | "wrong_explanation" | "typo" | "missing_image" | "other";
  description?: string;   // Max 500 karakter
}
```

**Response (201):** Oluşturulan `QuestionReport` kaydı.

**Hata Kodları:** `404` (soru yok), `409` (`You have already reported this question` — kullanıcı başına soru başına 1 şikayet)

---

## 8. Kullanıcı Profili — `/api/users`

Tüm endpointler auth gerektirir.

### 8.1 Profil

```
GET /api/users/me
```

Çağrıldığında enerji yenilenmesi sunucuda hesaplanıp kaydedilir.

**Response:**
```typescript
{
  id: string;
  email: string;
  username: string;
  avatar_url: string | null;
  daily_goal_xp: number;           // 10 | 20 | 50 | 100 — default 50
  energy: number;                  // 0-25
  energy_refreshed_at: string;     // ISO 8601
  next_energy_at: string | null;   // Sonraki +1 enerji zamanı (null = dolu)
  acorn_balance: number;
  active_exam_type_id: string | null;
  created_at: string;
  role: string;                    // "student" | "teacher" | "admin"
  permissions: string[];
}
```

---

### 8.2 İstatistikler

```
GET /api/users/me/stats
```

**Response:**
```typescript
{
  user_id: string;
  xp: number;
  level: number;              // Şu an güncellenmiyor, hep 1
  streak: number;             // current_streak ile aynı
  total_xp: number;
  max_streak: number;
  daily_xp: number;           // Şu an güncellenmiyor
  weekly_xp: number;          // Şu an güncellenmiyor
  current_streak: number;
  quizzes_completed: number;
  updated_at: string;
  last_active_date: string | null;   // YYYY-MM-DD
}
```

---

### 8.3 Başarımlar

```
GET /api/users/me/achievements
```

**Response:** Kullanıcının kazandığı başarımlar (`earned_at` azalan sıralı).
```typescript
Array<{
  id: string;
  name: string;
  description: string;
  icon_url: string;           // Emoji
  category: "quiz" | "streak";
  requirement_type: string;
  requirement_value: number;
  earned_at: string;
}>
```

> Tüm başarımların listesini dönen bir endpoint yoktur. Kilitli başarımları göstermek için listeyi client'ta sabit tutun (bkz. 15.8).

---

### 8.4 Seri Geçmişi (Bu Hafta)

```
GET /api/users/me/streak-history
```

**Response:** Her zaman 7 elemanlı (Pazartesi → Pazar)
```typescript
Array<{
  label: "Pzt" | "Sal" | "Çrş" | "Per" | "Cum" | "Cts" | "Paz";
  date: string;        // YYYY-MM-DD
  done: boolean;       // O gün en az 1 quiz tamamlandı mı
  isToday: boolean;
}>
```

> Günler sunucu saatine göre **UTC** hesaplanır.

---

### 8.5 Profil Güncelleme

```
PATCH /api/users/me
```

**Request Body:** (alan adları **camelCase**)
```typescript
{
  username?: string;            // 3-30 karakter, [a-z0-9._]
  email?: string;               // currentPassword zorunlu
  currentPassword?: string;
  newPassword?: string;         // Min 6 karakter, currentPassword zorunlu
  avatarUrl?: string;           // Geçerli URL
  dailyGoalXp?: "10" | "20" | "50" | "100";   // String olarak gönderilir
}
```

**Response:**
```typescript
{ id: string; email: string; username: string; avatar_url: string | null; daily_goal_xp: number }
```

**Hata Kodları:**
- `400` — Validasyon hatası (ör. şifre/e-posta değişiminde `currentPassword` eksik)
- `401` — `Mevcut şifre hatalı`
- `409` — Kullanıcı adı veya e-posta kullanımda

---

### 8.6 Sınav Kayıtları (Enrollments)

```
GET    /api/users/me/enrollments
POST   /api/users/me/enrollments            Body: { "exam_type_id": "<uuid>" }
DELETE /api/users/me/enrollments/:examTypeId
PATCH  /api/users/me/active-exam            Body: { "exam_type_id": "<uuid>" }
```

**GET Response:**
```typescript
Array<{
  id: string;
  exam_type_id: string;
  enrolled_at: string;
  exam_type_name: string;     // "KPSS Lisans"
  exam_type_slug: string;     // "lisans"
  exam_group_name: string;    // "KPSS"
  exam_group_slug: string;    // "kpss"
}>
```

| İşlem | Başarılı Yanıt | Hatalar |
|-------|----------------|---------|
| `POST` | `201` — enrollment kaydı (aktif olmayan sınava eklemez) | `404` sınav türü yok/pasif, `409` zaten kayıtlı |
| `DELETE` | `{ newActiveExamTypeId: string \| null }` — silinen aktif sınavsa en eski kayda geçilir | `400` son kayıt silinemez, `404` kayıt yok |
| `PATCH active-exam` | `{ id, username, email, active_exam_type_id }` | `404` bu sınava kayıtlı değil |

> `POST` aktif sınavı değiştirmez; gerekirse ardından `PATCH active-exam` çağrılmalıdır.

---

## 9. Mağaza — `/api/store`

### 9.1 Mağaza Ürünleri (Misafir Erişebilir)

```
GET /api/store/items
```

**Response:** Aktif ürünler, fiyata göre artan sıralı.
```typescript
Array<StoreItem>
```

**Güncel Ürünler (seed):**
| Ürün | `item_type` | Fiyat | Süre | Not |
|------|-------------|-------|------|-----|
| Seri Dondurma 🧊 | `streak_freeze` | 20 | 24 saat | ⚠️ Etkisi henüz uygulanmıyor |
| Sınırsız Enerji 🔋 | `unlimited_energy` | 40 | 8 saat | Aktif çalışıyor |
| XP Boost ⚡ | `xp_boost` | 30 | 1 saat | ⚠️ Etkisi henüz uygulanmıyor |
| 5 Enerji | `energy_refill` | 15 | — | `metadata.energy_count = 5` |
| 15 Enerji | `energy_refill` | 35 | — | `metadata.energy_count = 15` |
| 25 Enerji (Tam Doldur) | `energy_refill` | 50 | — | `metadata.energy_count = 25` |

---

### 9.2 Envanter (Auth Gerekli)

```
GET /api/store/inventory
```

**Response:**
```typescript
Array<{
  id: string;
  item_id: string;
  quantity: number;          // 0 olabilir (kullanılmış ürünler listede kalır)
  purchased_at: string;
  name: string;
  description: string;
  icon_url: string;
  item_type: string;
  duration_hours: number | null;
}>
```

---

### 9.3 Aktif Efektler (Auth Gerekli)

```
GET /api/store/effects
```

**Response:** Süresi dolmamış efektler.
```typescript
Array<{
  item_type: "streak_freeze" | "unlimited_energy" | "xp_boost";
  expires_at: string;    // ISO 8601
}>
```

---

### 9.4 Satın Alma (Auth Gerekli)

```
POST /api/store/purchase
```

**Request Body:**
```typescript
{
  itemId: string;     // UUID
  quantity?: number;  // 1-10, default: 1
}
```

**Response (201):**
```typescript
{
  balance: number;    // Güncel acorn bakiyesi
  spent: number;      // Harcanan acorn
  item: string;       // Ürün adı
  energy?: number;    // Sadece energy_refill için — yeni enerji değeri
}
```

**İş Kuralları:**
- `energy_refill` anında uygulanır (envantere girmez), enerji 25 ile sınırlanır.
- Süreli ürünler envantere eklenir; kullanmak için 9.5 ile aktifleştirilmelidir.

**Hata Kodları:** `404` (`Item not found`), `400` (`Insufficient acorn balance`)

---

### 9.5 Eşya Aktifleştirme (Auth Gerekli)

```
POST /api/store/activate/:itemId      // itemId = store_items.id (inventory'deki item_id)
```

**Response:**
```typescript
{
  itemType: string;
  expiresAt: string;   // ISO 8601 — şimdi + duration_hours
}
```

- Envanterden 1 adet düşer.
- Aynı tipte aktif efekt varsa süre **uzatılmaz**, yeni bitiş zamanıyla **değiştirilir**.

**Hata Kodları:** `404` (envanterde yok / adet 0), `400` (`This item cannot be activated` — süresiz ürün)

---

### 9.6 Acorn Paketleri (Auth Gerekli)

```
GET /api/store/acorn-packages
```

**Response:**
```typescript
Array<{
  id: "pkg_50" | "pkg_150" | "pkg_500";
  amount: number;
  label: string;   // "50 Acorn"
}>
```

> Sadece statik liste döner — gerçek para ile satın alma (IAP) endpoint'i **yoktur**. Mobilde App Store / Google Play IAP eklenecekse backend tarafında makbuz doğrulama endpoint'i yazılmalıdır.

---

## 10. Liderlik Tablosu — `/api/leaderboard`

```
GET /api/leaderboard?league=bronze
Authorization: Bearer <token>
```

**Parametreler:**
- `league`: `"bronze"` | `"silver"` | `"gold"` | `"diamond"` — default: `bronze` (geçersiz değer → `400`)

**Response:**
```typescript
Array<{
  username: string;
  avatar_url: string | null;
  xp_earned: number;
  rank: number | null;
}>
// Bu haftanın (Pazartesi başlangıçlı) kayıtları, xp_earned'e göre azalan, max 30
```

> ⚠️ `leaderboard` tablosunu dolduran bir iş henüz yok; endpoint şu an **boş dizi** döner. UI boş durumu desteklemelidir.

---

## 11. Arkadaşlık — `/api/friends`

Tüm endpointler auth gerektirir.

```
GET    /api/friends              → Arkadaş listesi
GET    /api/friends/requests     → Bana gelen bekleyen istekler
POST   /api/friends/request      Body: { "username": "string" }
PATCH  /api/friends/:id          Body: { "action": "accept" | "reject" }   (:id = friendship_id)
DELETE /api/friends/:id          → Arkadaşlıktan çıkar (:id = friendship_id)
```

**GET /api/friends Response:**
```typescript
Array<{
  friendship_id: string;
  user_id: string;
  username: string;
  avatar_url: string | null;
  xp: number | null;
  level: number | null;
  current_streak: number | null;
  friends_since: string;
}>
```

**GET /api/friends/requests Response:**
```typescript
Array<{
  friendship_id: string;
  user_id: string;          // İsteği gönderen
  username: string;
  avatar_url: string | null;
  requested_at: string;
}>
```

**Diğer Yanıtlar:**
- `POST request` → `201` + friendship kaydı. Alıcıya `friend_request` bildirimi oluşturulur.
- `PATCH` accept → `{ message: "Friend request accepted" }`, gönderene `friend_accepted` bildirimi.
- `PATCH` reject → `{ message: "Friend request rejected" }` — kayıt **silinir**.
- `DELETE` → `{ message: "Friend removed" }`

**Hata Kodları:**
- `404` — Kullanıcı / bekleyen istek / arkadaşlık bulunamadı
- `400` — Kendine istek, zaten arkadaş, zaten bekleyen istek var

**Friendship Status:** `0` = Beklemede, `1` = Kabul edildi (reddedilen istekler silindiği için başka değer yoktur)

---

## 12. Bildirimler — `/api/notifications`

Tüm endpointler auth gerektirir.

```
GET   /api/notifications?page=1&limit=20   → Sayfalı bildirim listesi
GET   /api/notifications/unread-count      → { "count": number }
PATCH /api/notifications/:id/read          → { "message": "Marked as read" }
POST  /api/notifications/read-all          → { "marked": number }
```

**GET Response:**
```typescript
{
  notifications: Array<Notification>;   // Önce okunmamışlar, sonra yeniden eskiye
  total: number;
  page: number;
  limit: number;
}
```

**Mevcut Bildirim Tipleri:** `friend_request`, `friend_accepted`

> Push notification altyapısı (FCM/APNs, cihaz token kaydı) **yoktur**; bildirimler sadece uygulama içi listelenir. Mobilde `unread-count` periyodik/odaklanmada sorgulanabilir.

---

## 13. Veri Tipleri (TypeScript)

### User (Kullanıcı)
```typescript
interface User {
  id: string;                      // UUID
  email: string;
  username: string;
  password_hash: string;           // Backend — client'a gönderilmez
  avatar_url: string | null;
  daily_goal_xp: number;           // Default: 50
  energy: number;                  // 0-25
  energy_refreshed_at: string;     // ISO 8601
  active_exam_type_id: string | null;
  acorn_balance: number;           // >= 0
  role_id: string;                 // UUID → roles.id
  created_at: string;
}
```

### ExamGroup / ExamType
```typescript
interface ExamGroup {
  id: string;
  name: string;       // "KPSS"
  slug: string;       // "kpss"
  description: string;
  sort_order: number;
  is_active: boolean;
}

interface ExamType {
  id: string;
  exam_group_id: string;
  name: string;       // "KPSS Lisans"
  slug: string;       // "lisans"
  description: string;
  sort_order: number;
  is_active: boolean;
}
```

### Module (Modül / Oturum)
```typescript
interface Module {
  id: string;
  exam_type_id: string;
  name: string;         // "Genel Yetenek" | "Genel Kültür"
  description: string;
  icon_url: string;     // Emoji
  sort_order: number;
  is_active: boolean;
  created_at: string;
}
```

### Course (Ders)
```typescript
interface Course {
  id: string;
  name: string;           // "Türkçe"
  description: string;
  icon_url: string;       // Emoji
  color: string;          // "#3b82f6"
  sort_order: number;
  exam_type_id: string | null;
  module_id: string | null;
}
```

### Topic (Konu)
```typescript
interface Topic {
  id: string;
  course_id: string;
  name: string;
  description: string;
  icon_url: string;
  sort_order: number;
  total_lessons: number;        // Default: 5
  max_crown_level: number;      // Default: 5
  unlock_after: string | null;  // Şu an kullanılmıyor
  status: "pending" | "approved";   // Public API sadece approved döner (reddedilen konu silinir)
  created_by: string | null;
}
```

### Step (Adım)
```typescript
interface Step {
  id: string;
  topic_id: string;
  name: string;
  description: string;
  sort_order: number;
  tests_required: number;
  step_type: "lesson" | "reward";
  reward_type: "acorn" | "store_item" | null;
  reward_amount: number | null;
  reward_item_id: string | null;
  created_at: string;
  updated_at: string;
}
```

### Test
```typescript
interface Test {
  id: string;
  step_id: string;
  sort_order: number;
  name: string | null;
  created_at: string;
}
```

### Question (Soru)
```typescript
type QuestionType =
  | "multiple_choice"   // Çoktan seçmeli (şu anki tüm içerik)
  | "true_false"        // Doğru/Yanlış
  | "fill_blank"        // Boşluk doldurma
  | "matching"          // Eşleştirme
  | "ordering"          // Sıralama
  | "flashcard"         // Kart çevirme
  | "swipe";            // Kaydırma

type QuestionStatus = "draft" | "pending" | "approved" | "archived";   // Reddedilen/silinen soru "archived" olur

interface Question {
  id: string;
  topic_id: string;
  question_text: string;           // HTML içerebilir
  image_url: string | null;        // Web sunucusuna göreli yol
  question_type: QuestionType;
  difficulty: 1 | 2 | 3;           // 1=Kolay, 2=Orta, 3=Zor
  status: QuestionStatus;          // Quiz'e sadece approved gelir
  hint: string | null;
  tags: string[] | null;
  difficulty_weight: number;       // Default: 1.0
  created_by: string | null;
  explanation: string | null;      // HTML içerebilir
  point_value: number;             // XP değeri — default: 1
  step_id: string | null;
  type_data: QuestionTypeData | null;
  test_id: string | null;
  sort_order: number;
  exam_source: string | null;      // Çıkmış soru kaynağı, ör. "2024 KPSS-LİSANS"
  created_at: string;
}
```

### QuestionTypeData
```typescript
// fill_blank
interface FillBlankData {
  acceptable_answers: string[];   // trim + lowercase karşılaştırılır
}

// matching — doğru eşleşme: left[i] ↔ right[i]. Client sağ tarafı karıştırıp göstermeli,
// gönderirken orijinal indexleri kullanmalı.
interface MatchingData {
  pairs: Array<{ left: string; right: string }>;
}

// ordering
interface OrderingData {
  items: Array<{ text: string; position: number }>;
}

// flashcard: genellikle { front: string, back: string }
// swipe / true_false: genellikle null (answers kullanılır)
```

### Answer (Cevap Seçeneği)
```typescript
interface Answer {
  id: string;
  question_id: string;
  answer_text: string;     // HTML içerebilir
  is_correct: boolean;
}
```

### QuizSession
```typescript
interface QuizSession {
  id: string;
  user_id: string;
  topic_id: string;
  session_type: "lesson" | "review" | "practice" | "step_final" | "topic_final";
  step_id: string | null;
  is_final_test: boolean;
  test_id: string | null;
  started_at: string;
  finished_at: string | null;
  score: number;                  // Şu an kullanılmıyor (0)
  xp_earned: number;
  duration: number | null;        // Saniye
  total_questions: number;
  correct_answers: number;
  energy_lost: number;
}
```

### UserAnswer
```typescript
interface UserAnswer {
  id: string;
  session_id: string;
  question_id: string;
  answer_id: string | null;
  is_correct: boolean;
  answered_at: string;
  time_spent: number | null;     // Milisaniye
  is_skipped: boolean;
}
```

### UserStats
Bkz. 8.2.

### UserTopicProgress
```typescript
interface UserTopicProgress {
  id: string;
  user_id: string;
  topic_id: string;
  crown_level: number;
  lessons_completed: number;
  is_unlocked: boolean;
  last_practiced_at: string | null;
  strength: number;
  next_review_at: string | null;
}
// ⚠️ Backend bu tabloya henüz yazmıyor — /courses/:id/full içinde progress hep null gelir.
```

### UserStepProgress
```typescript
interface UserStepProgress {
  id: string;
  user_id: string;
  step_id: string;
  tests_completed: number;
  is_step_completed: boolean;
  step_final_passed: boolean;
  stars: number;                    // Şu an kullanılmıyor (0)
  best_score: number;               // 0-100, en iyi doğruluk yüzdesi
  completed_at: string | null;
}
```

### Achievement / UserAchievement
```typescript
type AchievementRequirement =
  | "quiz_accuracy"       // Bir testte >= %X doğruluk
  | "quiz_perfect"        // Tüm sorular doğru (min X soru)
  | "quizzes_completed"   // Toplam X test
  | "streak_days"         // X gün seri
  | "total_xp"            // Toplam X XP
  | "friends_count";      // X arkadaş

interface Achievement {
  id: string;
  name: string;
  description: string;
  icon_url: string;           // Emoji
  category: string;
  requirement_type: AchievementRequirement;
  requirement_value: number;
}

interface UserAchievement {
  id: string;
  user_id: string;
  achievement_id: string;
  earned_at: string;
}
```

### StoreItem / UserItem / UserActiveEffect
```typescript
type ItemType = "streak_freeze" | "unlimited_energy" | "xp_boost" | "energy_refill";

interface StoreItem {
  id: string;
  name: string;
  description: string;
  icon_url: string;                 // Emoji
  price_acorn: number;
  item_type: ItemType;
  duration_hours: number | null;    // null = anlık / tek kullanımlık
  is_active: boolean;
  metadata: { energy_count?: number } & Record<string, unknown>;
  created_at: string;
}

interface UserItem {
  id: string;
  user_id: string;
  item_id: string;
  quantity: number;
  purchased_at: string;
}

interface UserActiveEffect {
  id: string;
  user_id: string;
  item_type: "streak_freeze" | "unlimited_energy" | "xp_boost";
  expires_at: string;
  created_at: string;
}
```

### LeaderboardEntry
```typescript
type League = "bronze" | "silver" | "gold" | "diamond";

interface LeaderboardEntry {
  id: string;
  user_id: string;
  week_start: string;       // YYYY-MM-DD (Pazartesi)
  xp_earned: number;
  rank: number | null;
  league: League;
}
```

### Friendship
```typescript
interface Friendship {
  id: string;
  user_id: string;          // İsteği gönderen
  friend_id: string;        // İsteği alan
  created_at: string;
  status: 0 | 1;            // 0=Beklemede, 1=Kabul
}
```

### Notification
```typescript
interface Notification {
  id: string;
  user_id: string;
  type: "friend_request" | "friend_accepted" | string;
  title: string;
  body: string | null;
  is_read: boolean;
  created_at: string;
}
```

### AcornTransaction
```typescript
type TransactionType =
  | "earned_quiz"          // Quiz doğruları ve ödül adımları
  | "earned_achievement"   // Başarım (+5)
  | "spent_store"          // Mağaza harcaması (negatif)
  | "guest_sync";          // Misafir acorn aktarımı

interface AcornTransaction {
  id: string;
  user_id: string;
  amount: number;           // Pozitif = kazanıldı, negatif = harcandı
  type: TransactionType;
  reference_id: string | null;   // Session / step / achievement / item ID
  created_at: string;
}
```

### QuestionReport
```typescript
interface QuestionReport {
  id: string;
  question_id: string;
  user_id: string | null;
  reason: "wrong_answer" | "unclear_question" | "wrong_explanation" | "typo" | "missing_image" | "other";
  description: string | null;
  status: "pending" | "reviewed" | "fixed" | "dismissed";
  admin_note: string | null;
  resolved_by: string | null;
  resolved_at: string | null;
  created_at: string;
}
```

### Role & Permission (RBAC)
```typescript
interface Role {
  id: string;
  name: "admin" | "teacher" | "student";
  description: string;
  created_at: string;
  updated_at: string;
}

interface Permission {
  id: string;
  name: "view_admin_panel" | "manage_users" | "manage_exams";
  description: string;
}
```

---

## 14. İçerik Hiyerarşisi

```
ExamGroup (Sınav Grubu)
  └── ExamType (Sınav Türü)
        └── Module (Modül / Oturum)
              └── Course (Ders)
                    └── Topic (Konu)
                          └── Step (Adım)   [lesson | reward]
                                └── Test           (lesson adımında 1 adet)
                                      └── Question (Soru)
                                            └── Answer (Cevap)
```

**Güncel İçerik (KPSS Lisans):**
- **Genel Yetenek:** Türkçe, Matematik
- **Genel Kültür:** Tarih, Coğrafya, Vatandaşlık

**Örnek:**
```
KPSS (ExamGroup)
  └── KPSS Lisans (ExamType)
        └── Genel Kültür (Module)
              └── Tarih (Course)
                    └── Osmanlı Devleti Kuruluş (Topic)
                          ├── Adım 1 (lesson, tests_required: 1) → Test 1 → ~10 soru
                          ├── Adım 2 (lesson) → Test 1 → sorular
                          ├── Adım 3 (reward, 10 acorn)
                          └── ...
```

---

## 15. Temel Uygulama Akışları

### 15.1 Yeni Kullanıcı Onboarding Akışı
```
1. Uygulama açılır → GET /api/exam-groups → Sınav grupları (pasifler "Çok Yakında")
2. Kullanıcı sınav türü seçer (exam_type_id cihazda saklanır)
3. Kullanıcı misafir olarak devam edebilir (15.2) veya kayıt olur
4. Kayıt → POST /api/auth/register (exam_type_id + varsa guest_data, acorn_balance, energy)
5. JWT token güvenli depolanır (Keychain / Keystore)
6. GET /api/users/me → profil, enerji, acorn, aktif sınav
7. Ana sayfa: GET /api/modules?exam_type_id → GET /api/courses?module_id → GET /api/courses/:id/full
```

### 15.2 Misafir Modu
```
Cihazda tutulan misafir durumu (web istemcisindeki karşılığı):
{
  examTypeId, examGroupId,
  quizResults: [{ topicId, stepId, testId, correctCount, totalQuestions }],
  claimedRewardStepIds: string[],
  acornBalance: 500 (başlangıç),
  energyCount: 25 (başlangıç),
  energyRefreshedAt: number | null    // epoch ms
}

1. Misafir quiz: GET /api/quiz/guest-start
2. Doğru/yanlış, enerji düşüşü ve acorn kazancı client-side hesaplanır
   (her doğru +1 acorn, her yanlış -1 enerji, 10 dakikada +1 enerji)
3. Ödül adımları client-side açılır (claimedRewardStepIds + acorn eklenir)
4. Kayıt olurken: guest_data + acorn_balance + energy gönderilir → misafir verisi silinir
   Mevcut hesaba giriş yaparken: POST /api/auth/merge-guest-progress
```

### 15.3 Quiz Akışı (Kayıtlı Kullanıcı)
```
1. GET /api/courses/:id/full → Konu ve adımlar
2. Açık bir lesson adımı seç (önceki adım tamamlanmış olmalı — client-side kontrol)
3. POST /api/quiz/start { topicId, stepId, testId, sessionType: "lesson" }
   → 403 ise enerji bitti diyaloğu (mağazadan energy_refill önerilir)
4. Sorular gösterilir; answers[].is_correct ile anlık geri bildirim verilir,
   cevaplar yerelde biriktirilir, yanlışta enerji UI'da 1 düşürülür
5. Enerji 0'a düşerse → finish-bulk { answers, skip_rewards: true }
6. Normal bitiş → POST /api/quiz/:sessionId/finish-bulk { answers, skip_rewards: false }
   → xp_earned, acorn_earned, correct_answers, step_completed, topic_completed
7. Ağ hatasında cevapları kuyruğa al, online olunca aynı isteği tekrar gönder (idempotent)
8. Sonraki adım reward ise → POST /api/quiz/reward/:stepId/claim
9. Kullanıcı yarıda çıkarsa → finish-bulk { answers: [], skip_rewards: true }
```

### 15.4 Enerji Sistemi
```
- Maksimum: 25
- Yenilenme: Her 10 dakikada +1 (sunucuda GET /users/me ve quiz start sırasında hesaplanır)
- Azalma: Her yanlış (atlanmamış) cevapta -1
- next_energy_at: sonraki +1 zamanı (null = dolu) → geri sayım için kullanılır
- Enerji 0 → Quiz başlatılamaz (403)
- unlimited_energy aktifse enerji azalmaz ve 0 iken de quiz başlatılabilir
- energy_refill satın alınca anında eklenir (max 25)
```

### 15.5 Acorn (Para Birimi) Sistemi
```
Kazanma:
  - Her doğru cevap → +1 (skip_rewards false ise)
  - Reward adımı → +reward_amount (içerikte 10)
  - Her başarım → +5
  - Yeni hesap → 500 başlangıç (veya misafir bakiyesi)

Harcama:
  - Mağaza (spent_store)

Efektler:
  - unlimited_energy: Süre boyunca enerji düşmez ✅
  - streak_freeze: ⚠️ Sunucuda henüz etkisi yok
  - xp_boost: ⚠️ Sunucuda henüz etkisi yok
  - energy_refill: Anında enerji
```

### 15.6 Seri (Streak) Sistemi
```
- Ödüllü (skip_rewards: false) bir quiz bitince güncellenir
- Son aktif gün dün ise streak +1, bugünse değişmez, daha eskiyse 1'e döner
- Gün hesabı UTC tarihine göre yapılır
- Sıfırlama sadece bir sonraki quizde olur — current_streak, gün kaçırılsa da
  kullanıcı yeni quiz yapana kadar eski değerini gösterir. UI'da last_active_date
  dünden eskiyse seriyi 0 göstermek önerilir.
- max_streak: Tüm zamanların rekoru
```

### 15.7 Liderlik Tablosu
```
- Haftalık (Pazartesi başlar), lig bazlı: bronze → silver → gold → diamond
- Her ligde en fazla 30 kullanıcı
- ⚠️ Şu an veri üreten bir iş olmadığı için liste boş döner
```

### 15.8 Başarımlar (Seed)
| İkon | Ad | Koşul |
|------|----|-------|
| 🎯 | Nişancı | Bir testte %85+ doğruluk |
| 🌟 | Mükemmeliyetçi | Bir testte tüm sorular doğru |
| 🌱 | İlk Adım | 1 test tamamla |
| 📚 | Hızlı Öğrenci | 10 test tamamla |
| 🏆 | Çalışkan | 50 test tamamla |
| 🔥 | Azimli | 7 gün seri |
| ⚡ | Tutkulu | 30 gün seri |

---

## 16. Hata Formatı ve Kodları

| HTTP Kodu | Anlam |
|-----------|-------|
| 400 | Geçersiz istek / validasyon / iş kuralı ihlali |
| 401 | Token yok, geçersiz veya süresi dolmuş; hatalı kimlik bilgisi |
| 403 | Yetki yok, enerji bitti, önceki adım tamamlanmamış |
| 404 | Kaynak bulunamadı |
| 409 | Çakışma (email/username kullanımda, zaten kayıtlı, tekrar şikayet) |
| 429 | Rate limit aşıldı |
| 500 | Sunucu hatası (`Internal server error`) |
| 503 | Health check — DB bağlantısı yok |

**İş kuralı hataları:**
```json
{ "error": "Hata mesajı" }
```

**Validasyon (Zod) hataları — farklı format:**
```json
{
  "errors": {
    "errors": [],
    "properties": {
      "password": { "errors": ["Password must be at least 6 characters"] }
    }
  }
}
```

**Rate limit:**
```json
{ "error": "Too many requests, please try again later" }
```

> Hata mesajları Türkçe ve İngilizce karışıktır. Kullanıcıya gösterilecek metinler için HTTP koduna göre client-side mesaj eşlemesi önerilir.

---

## 17. Bilinen Kısıtlar / Henüz Uygulanmamış Özellikler

Mobil geliştirmede UI'ın bunlara göre tasarlanması veya backend'e iş açılması gerekir:

| Konu | Durum |
|------|-------|
| `xp_boost` ve `streak_freeze` efektleri | Satın alınıp aktifleştirilebilir ama XP/streak hesabında kullanılmıyor |
| Liderlik tablosu | Tabloyu dolduran iş yok → hep boş |
| `user_topic_progress` (taç, strength, review) | Hiç yazılmıyor → `progress` hep `null` |
| `level`, `daily_xp`, `weekly_xp` | Güncellenmiyor |
| `stars`, `session.score` | Kullanılmıyor (0) |
| Adım geçme barajı | Yok — testi bitirmek adımı tamamlar |
| Kilit sistemi | Sunucu tarafında zorlanmıyor (client-side) |
| `friends_count` başarımı | Sorgu metin statü ile karşılaştırıyor, pratikte hiç kazanılmıyor |
| Tüm başarım listesi endpoint'i | Yok |
| Push notification / cihaz token | Yok |
| Acorn IAP satın alma | Yok (sadece paket listesi) |
| Refresh token / logout endpoint | Yok |
| Avatar yükleme | Yok — sadece `avatarUrl` (URL) kaydedilebilir |
| Hesap silme | Kullanıcı tarafı endpoint yok (App Store gereksinimi — eklenmeli) |

---

## 18. Güvenlik & Teknik Notlar

- **HTTPS** zorunludur (prodüksiyonda nginx + Let's Encrypt).
- **JWT** 7 gün geçerli, refresh yok.
- **CORS:** Prodüksiyonda `ALLOWED_ORIGINS` ile kısıtlı. Native mobil istemciler `Origin` header'ı göndermediği için etkilenmez; WebView tabanlı istemcilerde origin whitelist'e eklenmelidir.
- **Rate Limiting:** `/api/auth/*` → dakikada 10 istek / IP.
- **Body limiti:** JSON max 1MB.
- **Şifre hashing:** bcrypt, 12 round.
- **ID'ler:** UUID (PostgreSQL `gen_random_uuid()`).
- **Zaman damgaları:** ISO 8601 (UTC). Tarih alanları (`last_active_date`, `week_start`) `YYYY-MM-DD`.
- **RBAC:** `permissions` dizisi `/users/me` ve login yanıtında gelir.
- **Doğru cevaplar client'a gönderilir** (`answers[].is_correct`) — ödüller sunucuda yeniden doğrulanır ama cevap anahtarı istemcide görünürdür.

---

## 19. Admin Panel API'leri (Referans)

Tüm `/api/admin/*` endpointleri `view_admin_panel` yetkisi gerektirir; yazma işlemleri ek olarak belirtilen yetkiyi ister. Mobil uygulama için gerekli değildir.

| Endpoint | Ek Yetki |
|----------|----------|
| `GET /admin/questions`, `GET /admin/questions/:id` | — |
| `POST /admin/questions`, `POST /admin/questions/bulk` (max 100), `PATCH/DELETE /admin/questions/:id` | — |
| `GET /admin/exam-groups`, `GET /admin/exam-types` | — |
| `POST/PATCH/DELETE /admin/exam-groups`, `/admin/exam-types` | `manage_exams` |
| `GET /admin/courses`, `/admin/modules`, `/admin/topics`, `/admin/steps`, `/admin/tests` | — |
| `POST/PATCH/DELETE` courses, modules, topics; `POST/DELETE` steps, tests | `manage_exams` |
| `GET /admin/stats` | — |
| `GET /admin/pending`, `POST /admin/questions/:id/approve\|reject`, `POST /admin/topics/:id/approve\|reject` | `manage_exams` |
| `GET /admin/reports`, `GET /admin/reports/stats`, `PATCH /admin/reports/:id` | — |
| `GET /admin/users` | — |
| `POST /admin/users`, `GET/PATCH/DELETE /admin/users/:id`, `PATCH /admin/users/:id/role` | `manage_users` |
| `GET /admin/roles` | — |

---

## 20. Önerilen Mobile App Geliştirme Sırası

1. **Altyapı** — API client, token saklama, hata formatı eşleme, offline quiz kuyruğu
2. **Onboarding** — Sınav grubu/türü seçimi, misafir modu
3. **Auth Ekranları** — Giriş, Kayıt (guest_data aktarımı), Şifre Sıfırlama (deep link)
4. **Ana Sayfa** — Profil, enerji geri sayımı, modül/ders seçimi
5. **Ders Haritası** — Adım yolu, kilit mantığı, ödül sandıkları (`GET /courses/:id/full`)
6. **Quiz Akışı** — HTML soru render, görsel, açıklama, enerji, toplu bitirme, sonuç ekranı
7. **Profil & İstatistikler** — XP, seri haftası, başarımlar, profil düzenleme, sınav kayıtları
8. **Mağaza** — Ürünler, satın alma, envanter, efekt aktifleştirme
9. **Arkadaşlık & Bildirimler**
10. **Liderlik Tablosu** — Backend verisi hazır olduğunda
