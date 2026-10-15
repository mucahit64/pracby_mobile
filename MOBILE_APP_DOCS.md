# Pracby — Mobil Uygulama Geliştirme Dökümantasyonu

> Bu doküman Pracby mobil uygulamasının (Flutter) nasıl çalışması gerektiğini anlatır. Backend API'leri, veri modelleri, misafir modu, oyun mekanikleri ve ekran akışları buradadır.
> Son güncelleme: **16 Ekim 2026**. Backend (`pracby/src/`) ve web istemcisi (`pracby/client/`) `main` dalındaki `dcc9fb8` commit'i baz alınarak koddan doğrulanmıştır.
> Web istemcisi ürünün referans uygulamasıdır. Mobil uygulama, aksi belirtilmedikçe web ile aynı davranmalıdır.

### İçindekiler
1. Genel Mimari
2. Mobil Uygulama Mimarisi (Flutter)
3. Kimlik Doğrulama — `/api/auth`
4. Sınav Grupları — `/api/exam-groups`
5. Modüller — `/api/modules`
6. Dersler ve Ders Haritası — `/api/courses`
7. Quiz Sistemi — `/api/quiz`
8. Soru Gösterimi (Render Kuralları)
9. Soru Bildirimi (Hatalı Soru)
10. **Misafir Modu**
11. Kullanıcı Profili — `/api/users`
12. Mağaza — `/api/store`
13. Liderlik Tablosu — `/api/leaderboard`
14. Arkadaşlık — `/api/friends`
15. Bildirimler — `/api/notifications`
16. Oyun Mekanikleri (Enerji, Palamut, XP, Seri, Başarımlar)
17. Veri Tipleri
18. Hata Formatı ve Kodları
19. Bilinen Kısıtlar ve Backend Hataları
20. Güvenlik ve Teknik Notlar
21. Admin API'leri (Referans)
22. Geliştirme Sırası ve Mevcut Durum

---

## 1. Genel Mimari

```
Mobil Uygulama (Flutter)
    │
    ▼
REST API (Express 5 — Node.js)            Statik dosyalar (Nuxt web sunucusu)
Base URL: https://<domain>/api            https://<domain>/QuestionsImage/...
    │
    ├── /auth          → Kimlik doğrulama
    ├── /exam-groups   → Sınav grupları
    ├── /modules       → Modüller (Genel Yetenek / Genel Kültür)
    ├── /courses       → Dersler, konular, adımlar
    ├── /quiz          → Quiz, ödül, soru bildirimi
    ├── /users         → Profil, istatistik, sınav kayıtları
    ├── /leaderboard   → Liderlik tablosu
    ├── /store         → Mağaza
    ├── /friends       → Arkadaşlık
    ├── /notifications → Uygulama içi bildirimler
    └── /admin         → Yönetim (mobilde kullanılmaz)
    │
    ▼
PostgreSQL (Knex)
```

> Soru görselleri API'den **değil**, web sunucusundan servis edilir (bkz. 8.3).

### 1.1 Erişim Seviyeleri

| Seviye | Açıklama | Endpointler |
|--------|----------|-------------|
| **Public** | Token gerekmez | `/health`, `/auth/*` (merge hariç), `/exam-groups`, `/quiz/guest-start`, `/quiz/guest-report-question` |
| **Opsiyonel** | Token varsa kullanıcıya özel veri (ilerleme) eklenir, yoksa misafir kabul edilir | `/modules/*`, `/courses/*`, `/store/items` |
| **Auth** | `Authorization: Bearer <token>` zorunlu | Diğer tüm endpointler |

> Opsiyonel endpointlerde **geçersiz veya süresi dolmuş** bir token hata vermez, istek sessizce misafir olarak işlenir. Bu yüzden 401 almadan "ilerleme gelmedi" durumu oluşabilir. Token süresini `/users/me` ile kontrol edin (bkz. 3.8).

### 1.2 Rate Limit

| Kapsam | Limit | 429 Yanıtı |
|--------|-------|------------|
| `/api/auth/*` (**`check-email` ve `check-username` dahil**) | IP başına dakikada 10 | `{ "error": "Too many requests, please try again later" }` |
| `POST /api/quiz/guest-report-question` | IP başına günde 20 | `{ "error": "Too many reports, please try again later" }` |

Yanıtlarda `RateLimit-*` başlıkları döner. Kayıt formunda e-posta/kullanıcı adı kontrolü **debounce** edilmelidir (ör. 500 ms), aksi halde yazarken limite takılınır.

### 1.3 Sağlık Kontrolü

```
GET /api/health
```
- `200` → `{ "status": "ok", "timestamp": "2026-10-15T10:00:00.000Z" }`
- `503` → `{ "status": "unhealthy", "timestamp": "..." }` (veritabanı bağlantısı yok)

---

## 2. Mobil Uygulama Mimarisi (Flutter)

Mevcut proje (`pracby_mobile`) aşağıdaki yapıyı kullanır. Yeni kod bu yapıya uymalıdır.

| Katman | Paket | Kullanım |
|--------|-------|----------|
| State | `flutter_riverpod`, `riverpod_annotation` | Provider'lar `features/*/presentation/providers` altında |
| Routing | `go_router` | Rotalar `core/router/routes.dart`, yönlendirme kuralları `app_router.dart` |
| HTTP | `dio` | `core/api/api_client.dart`; endpoint sabitleri `core/api/endpoints.dart` |
| Token | `flutter_secure_storage` | `core/storage/secure_storage.dart` (Keychain / Keystore) |
| Yerel veri | `hive_flutter` | `core/storage/hive_storage.dart`; misafir durumu ve offline quiz kuyruğu burada |
| Model | `freezed`, `json_serializable` | `features/*/data/models` |
| HTML | `flutter_html` | `core/widgets/html_text.dart` (bkz. Bölüm 8) |
| Görsel | `cached_network_image` | Soru görselleri |
| Bağlantı | `connectivity_plus` | Online olunca offline kuyruğu gönderme |

**Klasör yapısı:** `lib/features/<özellik>/{data, domain, presentation}`. Özellikler şunlardır: `auth`, `onboarding`, `home`, `quiz`, `profile`, `store`, `leaderboard`, `friends`, `notifications`. Misafir modu için ayrı bir `features/guest` modülü önerilir (bkz. 10.10).

**API istemcisi kuralları:**
- Token varsa her isteğe `Authorization: Bearer <token>` eklenir.
- **Auth** endpointinden `401` gelirse token silinir ve uygulama misafir moduna döner. Misafir verisi yoksa giriş ekranı açılır. Web istemcisi de 401'de token'ı silip girişe yönlendirir.
- Hata gövdesi iki farklı formatta gelebilir: `{ error }` ya da Zod'un `{ errors }` formatı. Bkz. Bölüm 18.

---

## 3. Kimlik Doğrulama — `/api/auth`

### 3.1 Token
- **JWT**, HS256, payload `{ userId, username }`, **7 gün** geçerli.
- Refresh token, logout ve token iptali **yoktur**. Süre dolunca `401` döner ve kullanıcı yeniden giriş yapar.
- Token yalnızca `flutter_secure_storage` içinde saklanır.

### 3.2 Kayıt

```
POST /api/auth/register          (public, 201)
```

**Request Body:**
```typescript
{
  email: string;                  // Geçerli e-posta
  username: string;               // 3-20 karakter, regex: ^[a-z0-9](?!.*[._]{2})[a-z0-9._]{1,18}[a-z0-9]$
                                  // Küçük harf, rakam, "." ve "_"; harf/rakam ile başlayıp biter; ".." "__" "._" olamaz
  password: string;               // Min 6 karakter
  exam_type_id?: string;          // UUID — verilmezse "lisans" (KPSS Lisans) atanır. Boş string GÖNDERMEYİN (400 olur)
  acorn_balance?: number;         // int >= 0 — verilmezse 500
  energy?: number;                // int 0-25 — verilmezse 25
  guest_data?: {                  // Misafir ilerlemesini hesaba aktarır (bkz. 10.8)
    quiz_results?: Array<{
      topicId: string;
      stepId?: string;
      testId?: string;
      correctCount: number;       // int >= 0
      totalQuestions: number;     // int >= 0
    }>;
    claimed_reward_step_ids?: string[];
  };
}
```

**Response (201):**
```typescript
{
  user: { id: string; email: string; username: string; active_exam_type_id: string | null; created_at: string };
  token: string;
}
```
> Kayıt yanıtında `role` ve `permissions` **yoktur**. Kayıttan sonra `GET /api/users/me` çağrılmalıdır.

**İş Kuralları:**
- Kayıt tek transaction'da yapılır. Kullanıcıya `student` rolü verilir. `user_stats` satırı ve seçilen sınava ait `enrollment` otomatik oluşturulur.
- Misafir verisinin aktarımı Bölüm 10.8'de anlatılmıştır.

**Hata Kodları:** `400` validasyon · `409` `Email already in use` / `Username already taken` · `500` rol seed'i eksik

### 3.3 Giriş

```
POST /api/auth/login             (public, 200)
Body: { identifier: string; password: string }    // identifier "@" içeriyorsa e-posta, değilse kullanıcı adı
```

**Response:**
```typescript
{
  user: { id: string; email: string; username: string; role: string | null; permissions: string[] };
  token: string;
}
```
> Login yanıtında `active_exam_type_id`, enerji ve palamut **yoktur**. Girişten hemen sonra `GET /api/users/me` çağrılmalıdır.
> Cihazda misafir ilerlemesi varsa girişten sonra `merge-guest-progress` çağrılır (bkz. 10.9).

**Hata Kodları:** `401` `Invalid credentials`

### 3.4 E-posta / Kullanıcı Adı Uygunluğu

```
GET /api/auth/check-email?email=test@mail.com       → { "available": boolean }
GET /api/auth/check-username?username=john123       → { "available": boolean }
```
- Parametre eksikse `400` (`email required` / `username required`) döner.
- `check-username` yalnızca kullanıcı adının var olup olmadığına bakar, **format kontrolü yapmaz**. Regex kontrolünü istemci yapmalıdır.
- Bu endpointler auth rate limit'ine dahildir. Debounce kullanın (1.2).

### 3.5 Şifre Sıfırlama

```
POST /api/auth/forgot-password    Body: { "email": "user@mail.com" }
```
- Kullanıcı olsa da olmasa da aynı yanıt döner: `200 { "message": "Eğer bu e-posta kayıtlıysa, şifre sıfırlama bağlantısı gönderildi." }`
- E-posta Resend ile gönderilir. Link: `{APP_URL}/auth/reset-password?token=<64 karakter hex>`
- Token **1 saat** geçerlidir ve tek kullanımlıktır. Yeni talep, önceki kullanılmamış tokenları iptal eder.
- Link web sayfasını açar. Mobilde yakalamak için `/auth/reset-password` yoluna **universal link (iOS) / app link (Android)** tanımlanmalı ve `token` query parametresi okunmalıdır. Rota: `Routes.resetPassword`.

```
POST /api/auth/reset-password     Body: { "token": "<64 hex>", "password": "yeniSifre" }
```
- `200 { "message": "Şifren başarıyla güncellendi." }`
- `400` `Geçersiz veya süresi dolmuş bağlantı`. Token 64 karakter değilse `Geçersiz token`, şifre kısaysa `Şifre en az 6 karakter olmalıdır` döner.

### 3.6 Misafir İlerlemesini Birleştirme (Auth)

```
POST /api/auth/merge-guest-progress
Authorization: Bearer <token>
```
```typescript
{
  quiz_results?: GuestQuizResult[];   // default []
  claimed_rewards?: string[];         // Açılan sandıkların step ID'leri — default []
  earned_acorns?: number;             // int >= 0 — misafirken kazanılan net palamut — default 0
}
```
**Response:** Aktarılacak bir şey yoksa `{ merged: false }`, aktarım yapıldıysa `{ merged: true, xp_awarded: number, acorns_awarded: number }`. Kurallar Bölüm 10.9'dadır.

### 3.7 Olmayanlar
E-posta doğrulama, Google/Apple ile giriş, token yenileme, logout endpoint'i ve hesap silme **yoktur**. Logout istemci tarafında yapılır: token silinir.

### 3.8 Uygulama Açılış (Splash) Mantığı
```
1. Secure storage'da token var mı?
   ├─ Var  → GET /api/users/me
   │         ├─ 200 → Kayıtlı kullanıcı. Bekleyen offline quiz'ler varsa gönder → Ana sayfa
   │         └─ 401 → Token'ı sil, 2. adıma geç
   └─ Yok  → 2. adım
2. Misafir durumunda (Hive) examTypeId var mı?
   ├─ Var  → Misafir olarak ana sayfa
   └─ Yok  → Hoş geldin / sınav seçimi ekranı
```

---

## 4. Sınav Grupları — `/api/exam-groups`

```
GET /api/exam-groups             (public)
```
```typescript
Array<{
  id: string; name: string; slug: string; description: string; sort_order: number; is_active: boolean;
  exam_types: Array<{ id: string; exam_group_id: string; name: string; slug: string; description: string; sort_order: number; is_active: boolean }>;
}>
```
- Aktif ve pasif **tüm** gruplar `sort_order` sırasıyla döner. Pasif gruplar "Çok Yakında" olarak gösterilir ve seçilemez.
- Pasif grupların `exam_types` dizisi her zaman boştur. Aktif gruplarda yalnızca aktif türler döner.
- Bir grubun **tek** türü varsa web istemcisi o türü otomatik seçer.
- Güncel durum: **KPSS aktif** (Lisans, Önlisans, Ortaöğretim). **YKS pasif.**
- Kayıtlı `examTypeId` artık listede yoksa (tür kaldırılmış/pasif), misafir için seçim temizlenip sınav seçimine dönülmelidir. Web istemcisi böyle yapar.

---

## 5. Modüller — `/api/modules`

```
GET /api/modules?exam_type_id=<uuid>      (opsiyonel auth) — exam_type_id zorunlu, yoksa 400
GET /api/modules/:id                      → modül + courses[]  (404 "Module not found")
```
```typescript
Array<{ id: string; exam_type_id: string; name: string; description: string; icon_url: string; sort_order: number; is_active: boolean; created_at: string }>
```
- Yalnızca aktif modüller döner. KPSS türlerinde iki modül vardır: **Genel Yetenek** (🧠) ve **Genel Kültür** (📚). `icon_url` bir emojidir.
- Seçilen modül ve ders cihazda hatırlanır. Web istemcisi bunları `pb_selectedModuleId` ve `pb_selectedCourseId` anahtarlarında saklar.

---

## 6. Dersler ve Ders Haritası — `/api/courses`

Tüm endpointler **opsiyonel auth** kullanır, misafirler de erişebilir.

### 6.1 Ders Listesi
```
GET /api/courses?module_id=<uuid>
GET /api/courses?exam_type_id=<uuid>
```
- `module_id` verilirse `exam_type_id` yok sayılır. İkisi de verilmezse tüm dersler döner.
```typescript
Array<{ id: string; name: string; description: string; icon_url: string; color: string; sort_order: number; exam_type_id: string | null; module_id: string | null }>
```

### 6.2 Ders Detayı ve Konular
```
GET /api/courses/:id              → Course  (404 "Course not found")
GET /api/courses/:id/topics       → Topic[] (yalnızca status "approved", sort_order sıralı)
```

### 6.3 Tam Ders (Ders Haritası İçin)
```
GET /api/courses/:id/full         (token varsa ilerleme eklenir)
```
```typescript
{
  ...Course,
  topics: Array<{
    ...Topic,
    progress: UserTopicProgress | null;      // Pratikte her zaman null (backend bu tabloya yazmıyor)
    steps: Array<{
      id: string; topic_id: string; name: string; description: string; sort_order: number;
      tests_required: number;                // lesson: 1, reward: 0
      step_type: "lesson" | "reward";
      reward_type: "acorn" | "store_item" | null;
      reward_amount: number | null;          // İçerikte sandıklar 10 palamut
      reward_item_id: string | null;
      created_at: string; updated_at: string;
      progress: UserStepProgress | null;     // null = başlanmamış veya misafir
    }>;
  }>;
}
```
> Misafirde `progress` alanları her zaman `null` gelir. İlerleme cihazdaki misafir verisiyle doldurulur (bkz. 10.6).

### 6.4 Düğüm (Node) Durumları — Ders Haritası
Backend kilit mantığını **zorlamaz**. Yalnızca sandık açmada bir önceki lesson adımının tamamlanmış olmasını kontrol eder. Harita durumları istemcide şöyle hesaplanır (web: `pages/index.vue`):

Her konu için adımlar `sort_order` sırasıyla dolaşılır. Lesson ve sandık adımları **tek bir sıra** oluşturur:
- `progress.is_step_completed === true` → **completed**
- Tamamlanmamış **ilk** adım → **active**
- Ondan sonraki tüm adımlar → **locked**

| Düğüm | Kaynak | completed | active | locked |
|-------|--------|-----------|--------|--------|
| **Lesson** | `step_type: "lesson"` | `best_score` puanı gösterilir, tekrar çözülebilir | Tıklanınca quiz başlar | 🔒, tıklanamaz |
| **Sandık** | `step_type: "reward"` | Açılmış hediye ikonu, **devre dışı** | Tıklanınca ödül diyaloğu açılır | Soluk görünür, ödül alınamaz |
| **Boss** | Her konunun sonuna istemci ekler | — | Konudaki **tüm** adımlar (sandıklar dahil) tamamlanınca | Aksi halde |

- **Lesson** düğümü quiz'i `topicId + stepId (+ testId)` ve `sessionType: "lesson"` ile başlatır.
- **Boss** düğümü konunun final sınavıdır: `topicId` + `sessionType: "topic_final"`, `stepId` yok. Kayıtlı kullanıcıya 15 soru gelir. Misafirlere konudan rastgele 10 soru gelir, çünkü misafirde final yoktur (7.1). Boss'u bitirmek hiçbir adımı tamamlamaz.
- Boss bitince sonuç ekranı "⚔️ Boss Testi Geçildi!" başlığını gösterir (enerji bitip test kesildiyse göstermez). Boss oturumunda `step_id` olmadığı için `finish-bulk` her zaman `step_completed: false` döner; bu yüzden boss ekranı `step_completed`'e bakmaz, yalnızca `sessionType == "topic_final"` kontrol edilir.
- **Sandık açma:** Kayıtlı kullanıcı için `POST /api/quiz/reward/:stepId/claim` çağrılır, ardından `/full` yeniden yüklenir. Misafir için ödül cihazda verilir (10.7).
- Enerji ≤ 0 iken lesson başlatılmamalı, enerji diyaloğu açılmalıdır (bkz. 16.1).

---

## 7. Quiz Sistemi — `/api/quiz`

### 7.1 Misafir Quiz Başlatma (Public)
```
GET /api/quiz/guest-start?topicId=<uuid>&stepId=<uuid>&testId=<uuid>
```
- `topicId` zorunludur (`400 topicId is required`). Parametreler UUID olarak doğrulanmaz. Geçersiz bir değer `500` dönebilir, bu yüzden yalnızca API'den gelen ID'leri gönderin.
- `sessionType` kabul edilir ama **yok sayılır**. Misafirde final soru dağılımı yoktur.
- Soru seçimi:
  - `testId` verilirse o testin soruları (sıralı) gelir.
  - `stepId` verilirse adımın ilk testinin soruları gelir. Test yoksa adımdan rastgele 10 soru gelir.
  - Yalnızca `topicId` verilirse konudan rastgele 10 soru gelir.
- Sunucuda **oturum oluşturulmaz**. Puanlama, enerji ve palamut tamamen cihazda tutulur.
- **Response:** `{ questions: QuestionWithAnswers[] }`
- **Hatalar:** `404 Topic not found`, `404 No questions available`

### 7.2 Quiz Oturumu Başlatma (Auth)
```
POST /api/quiz/start              (201)
Body: { topicId: uuid; stepId?: uuid; testId?: uuid; sessionType?: "lesson" | "review" | "practice" | "step_final" | "topic_final" }   // default "lesson"
```

**Soru seçimi (öncelik sırasıyla):**

| Koşul | Sorular |
|-------|---------|
| `topic_final` | Konudan zorluk dağılımlı 15 soru: 2×Kolay + 7×Orta + 6×Zor (rastgele) |
| `step_final` + `stepId` + `testId` | O testin soruları (sıralı) |
| `step_final` + `stepId` | Adımdan zorluk dağılımlı 15 soru (2/7/6) |
| `testId` | Testin soruları, `sort_order` sıralı |
| `stepId` | Adımın ilk testinin soruları (test yoksa adımdan rastgele 10) |
| Yalnızca `topicId` | Konudan rastgele 10 soru (`review` / `practice`) |

> Normal derslerde `topicId + stepId + testId` ve `lesson` kullanılır. Mevcut içerikte her lesson adımında tek test vardır.

**Response (201):** `{ session: QuizSession; questions: QuestionWithAnswers[] }`

**Hatalar:**
- `403` `Enerjin kalmadı! Enerjinin yenilenmesini bekle veya marketten satın al.` döner. Enerji 0'dır ve `unlimited_energy` efekti yoktur. Bu durumda enerji diyaloğu açılmalıdır.
- `404` `Topic not found` / `No questions available`

### 7.3 Soru Nesnesi
```typescript
interface QuestionWithAnswers extends Question {
  answers: Array<{ id: string; question_id: string; answer_text: string /* HTML */; is_correct: boolean }>;
  // Yalnızca multiple_choice / true_false / swipe için dolu; diğer tiplerde []
}
```
- `is_correct` istemciye **gönderilir**. Doğru/yanlış geri bildirimi anında, sunucuya gitmeden gösterilir. Ödüller sunucuda yeniden hesaplanır.
- Mevcut içeriğin tamamı `multiple_choice` tipindedir.
- Render kuralları Bölüm 8'dedir.

### 7.4 Toplu Cevap Gönderip Bitirme (Önerilen Yol)
```
POST /api/quiz/:sessionId/finish-bulk
Body: { answers: AnswerInput[]; skip_rewards?: boolean }      // skip_rewards default false
```

**AnswerInput:**
```typescript
{
  questionId: string;            // UUID
  answerId?: string;             // multiple_choice, true_false, swipe
  isSkipped?: boolean;           // default false
  timeSpent?: number;            // ms, int >= 0
  answeredAt?: string;           // ISO 8601
  textAnswer?: string;           // fill_blank — max 500, trim + küçük harf karşılaştırılır
  matchingAnswer?: Array<{ leftIndex: number; rightIndex: number }>;   // matching — doğru: leftIndex === rightIndex
  orderedIndices?: number[];     // ordering
  isCorrect?: boolean;           // yalnızca flashcard (istemci değerlendirir)
}
```

**Response (200):**
```typescript
{
  // Güncellenmiş QuizSession alanları
  id: string; user_id: string; topic_id: string; step_id: string | null; test_id: string | null;
  session_type: string; is_final_test: boolean; started_at: string; finished_at: string;
  score: number; xp_earned: number; duration: number /* sn */; total_questions: number; correct_answers: number; energy_lost: number;
  // Ek alanlar
  acorn_earned: number;
  step_completed: boolean;       // Adım bu oturumla İLK KEZ tamamlandıysa true
  topic_completed: boolean;      // Konudaki tüm lesson adımları tamamlandıysa true
}
```

**İş Kuralları:**
- Doğruluk sunucuda yeniden hesaplanır. Çoktan seçmelide `answerId` o soruya ait olmalıdır. İstemcinin gönderdiği `isCorrect` yalnızca flashcard için dikkate alınır.
- **İdempotent:** Oturum zaten bitmişse mevcut kayıt `acorn_earned: 0, step_completed: false, topic_completed: false` ile döner. Ağ hatasında güvenle tekrar denenebilir.
- Her yanlış ve atlanmamış cevap için 1 enerji düşer. `unlimited_energy` aktifse düşmez. Bu düşüş **`skip_rewards: true` olsa da** uygulanır.
- `skip_rewards: false` olduğunda:
  - XP olarak doğru soruların `point_value` toplamı eklenir (şu an her soru 1).
  - Palamut olarak doğru sayısı eklenir.
  - `quizzes_completed`, seri ve `streak_history` güncellenir.
  - `step_id` varsa adım tamamlanır ve `best_score` (yüzde) güncellenir. **Geçme barajı yoktur**, testi bitirmek yeterlidir.
  - Başarımlar kontrol edilir ve her yeni başarım için +5 palamut verilir. Yanıtta yeni başarım listesi **dönmez**.
- `skip_rewards: true` olduğunda XP, palamut, seri ve adım ilerlemesi işlenmez.

### 7.5 Quiz Akışı (Kayıtlı Kullanıcı)
```
1. Lesson düğümü → POST /api/quiz/start  (403 → enerji diyaloğu)
2. Her cevapta answers[].is_correct ile anlık geri bildirim. Cevap yerelde biriktirilir.
   Yanlışta UI'daki enerji 1 azaltılır (unlimited_energy aktifse azaltılmaz,
   enerji diyaloğu da açılmaz — sunucu da düşmez).
3. Enerji 0'a düşerse sonraki soruya geçmeden ENERJİ DİYALOĞU açılır:
   ├─ Enerji satın alır (POST /store/purchase) → quiz devam eder, ödüller korunur
   └─ Reddeder → "Çıkarsan ilerlemen kaybolur" uyarısı
        ├─ Devam → diyalog tekrar açılır
        └─ Çık   → finish-bulk { answers: [], skip_rewards: true }
4. Son soru → finish-bulk { answers, skip_rewards: <enerji 0'da bitti mi> }
5. Sonuç ekranı: xp_earned, acorn_earned, correct_answers, step_completed, topic_completed
6. Kullanıcı quiz'den çıkarsa → finish-bulk { answers: [], skip_rewards: true }
7. Ağ hatası → cevapları offline kuyruğa (Hive) yaz, online olunca / açılışta aynı isteği tekrar gönder
```
- Web istemcisi offline kuyruğu `pb_pending_quiz` anahtarında `{ sessionId, answers, savedAt, skipRewards }[]` olarak tutar. Mobilde karşılığı `features/quiz/domain/offline_quiz_buffer.dart` dosyasıdır.

### 7.6 Eski Endpointler (Kullanmayın)
```
POST /api/quiz/:sessionId/answer   Body: AnswerInput   → { isCorrect, energy_remaining }
POST /api/quiz/:sessionId/finish   Body: { skip_rewards?: boolean }
```
Tek tek cevap gönderme akışıdır. Web istemcisi artık kullanmıyor. Mobilde **7.4** kullanılmalıdır.

### 7.7 Sandık (Ödül) Açma (Auth)
```
POST /api/quiz/reward/:stepId/claim
```
- **Response:** `{ type: "acorn"; amount: number }`, `{ type: "store_item"; itemName: string }` ya da `{ type: "none" }`.
- Yanıtta güncel bakiye dönmez. Bakiyeyi `amount` kadar artırın veya `/users/me` çağırın.
- **Hatalar:**
  - `404` `Reward step not found` (adım yoksa veya `reward` tipinde değilse)
  - `400` `Reward already claimed`
  - `403` `Previous step not completed` (bir önceki adım lesson ise ve tamamlanmamışsa)

---

## 8. Soru Gösterimi (Render Kuralları)

### 8.1 HTML
- `question_text` ve `answers[].answer_text` **HTML**'dir. Sorularda `<p>`, `<b>`, `<u>`, listeler, `<sup>` ve `<sub>` bulunur.
- Web istemcisinin izin verdiği etiketler: `p, ul, ol, li, b, strong, i, em, u, br, sup, sub, span`. Diğer etiketler atılır, içerikleri kalır.
- Mobilde `flutter_html` ile render edilir (`core/widgets/html_text.dart`). Yalnızca bu etiketler için stil tanımlanmalıdır. `<ul>/<ol>` maddeleri ayrı satırlarda görünmelidir, `<sup>/<sub>` üst ve alt simge olarak gösterilmelidir.

### 8.2 Görsel Yerleşimi — `<!--img-->` İşareti
Soru görselinin metin içindeki yeri `question_text` içindeki `<!--img-->` yorumuyla belirlenir:
```
before = metnin ilk "<!--img-->" işaretinden önceki kısmı
after  = sonraki kısmı
Gösterim: [before HTML] → [görsel] → [after HTML]
İşaret yoksa: [görsel] → [tüm metin]
```
- Metni **sanitize etmeden önce** bölün. HTML sanitizer'lar yorumları siler.
- Örnek: Matematik sorularında görsel, kitaptaki gibi soru kökünün ortasında yer alır.

### 8.3 Görsel Adresi
- `image_url` göreli bir yoldur, ör. `QuestionsImage/kpss/matematik/kesir-problemleri_t1_q15.jpg`.
- Dosyalar API'den değil **web sunucusundan** servis edilir: `https://<web-domain>/<image_url>`. Web domain'i ayrı bir yapılandırma değeri olmalıdır (ör. `WEB_BASE_URL`).
- Görsel yüklenemezse web istemcisi "Bu sorunun görseli yüklenemedi veya eksik." mesajını gösterir. Görsel genişliğe sığdırılır, yüksekliği sınırlıdır ve oran korunur.

### 8.4 Açıklama (`explanation`)
- Açıklama düz metindir, yalnızca `<sup>` ve `<sub>` içerebilir. Diğer `<`, `>` karakterleri **metin olarak** gösterilmelidir, ör. `a < b`.
- Web'deki algoritma:
  1. `&lt; &gt; &amp;` karakterlerini çöz.
  2. Tüm metni escape et.
  3. Yalnızca `<sup> </sup> <sub> </sub>` etiketlerini geri aç.
- Açıklama boşsa sırasıyla şu değerler denenir: `explanation`, `type_data.back`, `"Açıklama yok"`.

### 8.5 Cevap Geri Bildirimi
Cevap verildikten sonra alttan açılan bir panel (bottom sheet) gösterilir:
- Doğru/yanlış başlığı
- Yanlışsa doğru seçeneğin `answer_text` değeri (HTML)
- Açılıp kapanabilen açıklama (mobilde varsayılan kapalı)
- **"Bildir"** butonu (bkz. Bölüm 9)
- "Devam" butonu

### 8.6 Diğer Alanlar
- `exam_source` doluysa rozet olarak gösterilir: `📚 2024 KPSS-LİSANS`.
- `hint` veride vardır ama web'de gösterilmiyor (opsiyonel).
- Soru üst barında da bir bildir (bayrak) butonu bulunur.

### 8.7 Soru Tipleri (`type_data`)
Backend tüm tipleri destekler, ancak içerikte şimdilik yalnızca `multiple_choice` vardır.

| Tip | `type_data` | Gönderilecek alan |
|-----|-------------|-------------------|
| `multiple_choice`, `true_false`, `swipe` | `null` (`answers` kullanılır) | `answerId` |
| `fill_blank` | `{ acceptable_answers: string[]; word_options?: string[] }` — boşluklar `question_text` içinde `__` | `textAnswer` |
| `matching` | `{ pairs: [{ left, right }] }` — sağ taraf karıştırılarak gösterilir | `matchingAnswer` (orijinal indeksler) |
| `ordering` | `{ items: [{ text, position }] }` | `orderedIndices` |
| `flashcard` | `{ front?, back }` | `isCorrect` (kullanıcının kendi değerlendirmesi) |

---

## 9. Soru Bildirimi (Hatalı Soru)

Hem **kayıtlı kullanıcılar** hem **misafirler** soru bildirebilir. Bildirimler admin panelinde soru bazında toplanır. Aynı soruyu kaç kişinin bildirdiği önceliği belirler.

**Sebepler ve gösterilecek etiketler:**

| `reason` | Etiket |
|----------|--------|
| `wrong_answer` | Yanlış cevap işaretlenmiş |
| `unclear_question` | Soru belirsiz / anlaşılmıyor |
| `wrong_explanation` | Açıklama hatalı |
| `typo` | Yazım hatası var |
| `missing_image` | Görsel eksik veya yanlış |
| `other` | Diğer |

### 9.1 Kayıtlı Kullanıcı
```
POST /api/quiz/report-question            (auth, 201)
Body: { questionId: uuid; reason: Reason; description?: string /* max 500 */ }
```
- **Response:** Oluşturulan `QuestionReport` kaydı.
- **Hatalar:** `404 Question not found`, `409 You have already reported this question` (kullanıcı başına soru başına 1 bildirim).

### 9.2 Misafir
```
POST /api/quiz/guest-report-question      (public, 201, IP başına günde 20)
Body: { questionId: uuid; guestId: uuid; reason: Reason; description?: string /* max 200 */ }
```
- **Response:** `{ id, question_id, reason, status, created_at }`
- `guestId`, cihazda bir kez üretilen ve **kalıcı** olarak saklanan bir UUID v4'tür (bkz. 10.3). Tekrar bildirimi engellemek için kullanılır.
- **Hatalar:**
  - `400` validasyon (ör. açıklama 200 karakteri aşıyor)
  - `404 Question not found`
  - `409` aynı misafir aynı soruyu tekrar bildirdi
  - `429` günlük limit aşıldı

### 9.3 Arayüz
- Modal içinde sebep seçimi (radyo) zorunludur. Açıklama alanı isteğe bağlıdır ve `maxLength` misafirde 200, üyede 500'dür.
- Hata mesajları:
  - `409` → "Bu soruyu zaten bildirdin."
  - `429` → "Çok fazla bildirim gönderdin, daha sonra tekrar dene."
  - Diğer → "Rapor gönderilemedi."
- Başarıda "Rapor gönderildi, teşekkürler!" gösterilir ve modal 1,5 sn sonra kapanır.

---

## 10. Misafir Modu

Misafir modu, kullanıcının **hesap açmadan** uygulamayı denemesini sağlar. Misafir ders haritasını görür, quiz çözer, enerji harcar, palamut kazanır, sandık açar ve hatalı soru bildirir. Hesap açtığında ya da giriş yaptığında ilerlemesi hesaba aktarılır.

> **Temel ilke:** Misafirin sunucuda hiçbir kaydı yoktur. Puanlama, enerji, palamut ve ilerleme tamamen **cihazda** tutulur. Sunucu misafir için yalnızca içerik verir (soru, ders) ve bildirim alır.

### 10.1 Misafir Kimdir?
- Cihazda geçerli bir token yoksa kullanıcı misafirdir.
- Misafir durumu ile kayıtlı kullanıcı durumu **aynı anda** bulunmaz. Kayıt veya başarılı birleştirme sonrası misafir verisi silinir. Yalnızca `guestId` kalır.

### 10.2 Misafirin Erişebildikleri

| Özellik | Misafir | Not |
|---------|---------|-----|
| Sınav seçimi | ✅ | `GET /exam-groups` |
| Ders haritası | ✅ | `/modules`, `/courses/*` (opsiyonel auth) + yerel ilerleme |
| Lesson quiz'leri | ✅ | `GET /quiz/guest-start` |
| Boss (konu finali) | ✅ | Konudan rastgele 10 soru |
| Sandık açma | ✅ | Yerel (10.7) |
| Enerji ve palamut | ✅ | Yerel (10.4, 10.5) |
| Mağaza | ⚠️ Kısmen | Ürünler listelenir, **yalnızca enerji paketleri** yerel palamutla alınabilir. Diğer ürünler "Profil oluştur" çağrısıyla kilitli |
| Hatalı soru bildirme | ✅ | `POST /quiz/guest-report-question` |
| Liderlik tablosu | ❌ | Ekran açılabilir, veri yüklenmez. Kayıt çağrısı (CTA) gösterilir |
| Profil, istatistik, başarımlar, seri | ❌ | Kayıt ekranına yönlendirilir |
| Arkadaşlar, bildirimler | ❌ | Kayıt ekranına yönlendirilir |

### 10.3 Cihazda Tutulan Misafir Durumu
Hive'da tek bir kutuda (ör. `guest`) saklanması önerilir. Web karşılıkları parantez içindedir.

```dart
// GuestState (web: localStorage "guestState")
class GuestState {
  String? examTypeId;                 // seçilen sınav türü   (web ayrıca: "guestExamTypeId")
  String? examGroupId;                // seçilen sınav grubu  (web ayrıca: "guestExamGroupId")
  List<GuestQuizResult> quizResults;  // bitirilen her quiz için bir kayıt — default []
  List<String> claimedRewardStepIds;  // açılan sandıkların step ID'leri — default []
  int acornBalance;                   // default 500
  int energyCount;                    // default 25 (0-25)
  int? energyRefreshedAtMs;           // yenilenme sayacının başlangıcı (epoch ms) — enerji doluysa null
}

class GuestQuizResult {
  String topicId;
  String? stepId;
  String? testId;
  int correctCount;
  int totalQuestions;
}

// Ayrı ve kalıcı anahtar (web: localStorage "guestId")
String guestId;   // İlk ihtiyaçta UUID v4 üretilir. Kayıt/girişte SİLİNMEZ.
```

Seçilen sınav türü **tek bir kaynaktan** okunmalıdır. Web, sınavı yalnızca `guestExamTypeId` / `guestExamGroupId` anahtarlarında tutar; `guestState` bu değeri kendisi saklamaz, her okumada bu anahtarlardan alır. Böylece misafir sınav değiştirdiğinde kayıt eski sınava yapılmaz. Mobilde bu tek kaynak `GuestState.examTypeId` / `examGroupId` alanlarıdır (`features/guest/guest_provider.dart`).

### 10.4 Enerji (Yerel)
Sabitler sunucuyla aynıdır: `MAX_ENERGY = 25`, `REGEN_INTERVAL = 10 dakika`.

```
Yenilenme (uygulama açılışında, ön plana gelişte ve her saniyelik sayaç tikinde):
  if energyCount >= 25 || energyRefreshedAtMs == null → değişiklik yok
  eklenecek = floor((now - energyRefreshedAtMs) / 10dk)
  if eklenecek > 0:
     energyCount = min(25, energyCount + eklenecek)
     energyRefreshedAtMs = (energyCount == 25) ? null : energyRefreshedAtMs + eklenecek * 10dk

Enerji değiştiğinde (setEnergy):
  değer 0-25 aralığına sıkıştırılır
  yeni değer 25 ise                          → energyRefreshedAtMs = null
  25'ten aşağı düştüyse                       → energyRefreshedAtMs = now   (sayaç başlar)
  zaten 25'in altında ve sayaç yoksa         → energyRefreshedAtMs = now

Sonraki +1 zamanı = energyRefreshedAtMs + 10dk   (enerji doluysa yok)
```
- Her **yanlış** cevapta 1 enerji düşer.
- Enerji 0 iken lesson başlatılamaz, enerji diyaloğu açılır.
- **Enerji paketi satın alma (misafir):**
  - Liste `GET /api/store/items` içinden `item_type == "energy_refill"` olanlardır.
  - Satın alma: `acornBalance >= price_acorn` ise önce `acornBalance -= price_acorn`, sonra `setEnergy(min(25, energy + metadata.energy_count))`.
  - Yetersiz bakiyede "Yetersiz palamut." gösterilir.

### 10.5 Palamut (Yerel)
- Başlangıç bakiyesi 500'dür.
- Quiz bitince doğru cevap başına +1 palamut eklenir.
- Sandık açınca +`reward_amount` eklenir (boşsa 10).
- Yalnızca enerji paketlerine harcanabilir.
- Misafirin XP'si yoktur. Quiz sırasında gösterilen "+XP" yalnızca görseldir.

### 10.6 Yerel İlerlemeyi Haritaya Uygulama (Overlay)
`GET /api/courses/:id/full` yanıtı alındıktan sonra **her adım için** şu kurallar uygulanır (web: `overlayGuestProgress`):
```
topic.progress == null ise   → topic.progress = { is_unlocked: true }

step.progress zaten doluysa → dokunma
step_type == "reward":
   step.progress = { tests_completed: 0,
                     is_step_completed: claimedRewardStepIds.contains(step.id),
                     step_final_passed: false }
step_type == "lesson":
   sonuçlar = quizResults.where(r.stepId == step.id)
   tamamlandı = sonuçlar.isNotEmpty            // geçme barajı yok
   step.progress = { tests_completed: tamamlandı ? 1 : 0,
                     is_step_completed: tamamlandı,
                     step_final_passed: tamamlandı,
                     best_score: max(round(correct / total * 100)) veya 0 }
```
Ardından düğüm durumları kayıtlı kullanıcıdakiyle **aynı** şekilde hesaplanır (6.4).

### 10.7 Misafir Quiz ve Sandık Akışı
```
Lesson:
1. Enerji > 0 kontrolü (değilse enerji diyaloğu)
2. GET /api/quiz/guest-start?topicId&stepId[&testId]
3. Her cevap yerelde puanlanır (answers[].is_correct). Yanlışta setEnergy(energy - 1)
4. Enerji 0 → enerji diyaloğu (10.4'teki yerel satın alma) / reddederse çıkış uyarısı
5. Son soru → GuestQuizResult eklenir ve acornBalance += doğru sayısı
6. Sonuç ekranı → "Devam" → KAYIT DUVARI (10.8)
7. Yarıda çıkış → hiçbir şey kaydedilmez

Boss (topic_final): guest-start?topicId=<id> (stepId yok) → 10 rastgele soru.
  Sonuç stepId'siz kaydedilir. Hiçbir adımı tamamlamaz ama kayıt olunca XP'ye sayılır.

Sandık: claimedRewardStepIds'e step.id eklenir ve acornBalance += reward_amount (boşsa 10)
        → haritayı yeniden hesapla
```
- Web, enerji 0'da biten misafir quiz'ini de kaydedip palamut verir. Kayıtlı kullanıcıda ise `skip_rewards: true` gönderilir. Mobilde iki modun aynı davranması önerilir: enerji 0'da biten misafir quiz'i için palamut verilmez, sonuç kaydedilmez.
- Hatalı soru bildirimi misafirde de çalışır (Bölüm 9.2).

### 10.8 Kayıt Duvarı ve Kayıt Olurken Aktarım
**Kayıt duvarı** (web: `/auth/register-wall`): Misafir her quiz'in sonuç ekranında "Devam"a bastığında gösterilir. Seçenekler:
- **Profil Oluştur** → kayıt ekranı
- **Giriş Yap** → giriş ekranı
- **Ana sayfaya dön** → ders haritası (misafir olarak devam)

Ayrıca profil sekmesi, mağazadaki banner ve kilitli özellikler doğrudan kayıt ekranına yönlendirir.

**Kayıt isteği** (`POST /api/auth/register`):
```jsonc
{
  "email": "...", "username": "...", "password": "...",
  "exam_type_id": "<formda seçilen ya da misafirin seçtiği sınav>",
  "acorn_balance": guest.acornBalance,
  "energy": guest.energyCount,       // Göndermeden önce enerji yenilemesini uygulayın
  "guest_data": {
    "quiz_results": guest.quizResults,
    "claimed_reward_step_ids": guest.claimedRewardStepIds
  }
}
```

**Sunucuda olanlar:**
- `quiz_results[].stepId` ve `claimed_reward_step_ids` içindeki **tüm** ID'ler veritabanında var olmalıdır. **Biri bile geçersizse `guest_data` tamamen sessizce yok sayılır**, kayıt yine başarılı olur. İçerik güncellemesiyle silinmiş bir adım tüm ilerlemeyi kaybettirebilir. Göndermeden önce elinizdeki ders verisinde bulunmayan adımları filtreleyin.
- XP olarak tüm sonuçların `correctCount` toplamı eklenir. Buna `stepId`'siz boss sonuçları da dahildir, ama yalnızca en az bir sonuçta `stepId` varsa.
- Her adım için `user_step_progress` oluşturulur. Adım, en az `tests_required` sayıda farklı testi varsa tamamlanmış sayılır.
- Açılan sandıklar talep edilmiş sayılır. **Palamut tekrar eklenmez**, çünkü misafir bakiyesi `acorn_balance` ile zaten aktarılır.

**Başarılı yanıttan sonra:**
1. Token'ı kaydedin.
2. Misafir durumunu silin (`guestId` hariç).
3. `GET /users/me` çağırın.
4. Ana sayfaya gidin.

### 10.9 Mevcut Hesaba Giriş Yaparken Birleştirme
Girişten sonra cihazda misafir ilerlemesi varsa şu istek gönderilir. İlerleme varsayılır: `quizResults` boş değilse, `claimedRewardStepIds` boş değilse ya da `acornBalance > 500` ise.
```
POST /api/auth/merge-guest-progress
{ "quiz_results": guest.quizResults,
  "claimed_rewards": guest.claimedRewardStepIds,
  "earned_acorns": max(0, guest.acornBalance - 500) }
```
- **Başarılıysa** misafir durumu silinir. **Hata olursa** silinmez, sonraki açılışta tekrar denenir. İlerleme yoksa misafir durumu doğrudan silinir.
- **Sunucu kuralları:**
  - **Adımlar:** Kayıttaki gibi, bir adım ID'si bile geçersizse adımlar ve sandıklar aktarılmaz. Palamut bundan etkilenmez.
  - **XP:** Yalnızca hesapta daha önce tamamlanmamış adımlar için verilir, aynı ilerleme iki kez sayılmaz.
  - **Palamut:** `earned_acorns` bakiyeye eklenir (işlem tipi `guest_sync`). Misafirin harcadığı palamut bu farka dahildir, enerji aktarılmaz.

### 10.10 Mobil Uygulamadaki Durum
Misafir modu mobilde uygulanmıştır:
- [x] `features/guest/guest_provider.dart`: `GuestState` + Hive deposu (`guest` kutusu), `guestId` (UUID v4), enerji yenilenmesi (10.4), palamut işlemleri, overlay (10.6)
- [x] Router: misafir `home`, `quiz`, `store`, `leaderboard` ve kayıt duvarına girer. Profil sekmesi kayıt ekranını mevcut sayfanın üstüne açar. Diğer korumalı rotalar kayıt ekranına yönlendirir.
- [x] Sınav seçimi (`welcome.vue` karşılığı): misafir sınavı seçince doğrudan ders haritasına gider. Pasif gruplar "Çok Yakında" olarak gösterilir.
- [x] Quiz: misafir dalı (`guest-start`, yerel puanlama, enerji ve sonuç kaydı), misafir soru bildirimi, sonuçtan sonra kayıt duvarı
- [x] Enerji diyaloğu ve mağaza: misafir yalnızca enerji paketlerini yerel palamutla alır, diğer ürünler kilitlidir
- [x] Kayıt: `acorn_balance`, `energy` (yenileme uygulanmış) ve `guest_data` gönderilir, ardından misafir verisi silinir
- [x] Giriş: ilerleme varsa `merge-guest-progress`; başarıda misafir verisi silinir, hata olursa saklanır
- [x] `Endpoints.quizGuestReportQuestion`

Kalanlar:
- [ ] Kayıttan önce `guest_data` içindeki, içerikte artık bulunmayan adım ID'lerinin filtrelenmesi (10.8). Web de henüz filtrelemiyor.
- [ ] Kayıt ekranının web'deki gibi 3 adımlı sihirbaz olması (hesap → sınav grubu → düzey)

---

## 11. Kullanıcı Profili — `/api/users`

Tüm endpointler auth gerektirir.

### 11.1 Profil
```
GET /api/users/me
```
Çağrıldığında sunucu enerji yenilemesini hesaplar ve kaydeder.
```typescript
{
  id: string; email: string; username: string; avatar_url: string | null;
  daily_goal_xp: number;           // 10 | 20 | 50 | 100 — default 50
  energy: number;                  // 0-25
  energy_refreshed_at: string;
  next_energy_at: string | null;   // Sonraki +1 enerji zamanı (null = dolu)
  acorn_balance: number;
  active_exam_type_id: string | null;
  created_at: string;
  role: string;                    // "student" | "teacher" | "admin"
  permissions: string[];
}
```

### 11.2 İstatistikler
```
GET /api/users/me/stats
```
```typescript
{
  user_id: string; xp: number; total_xp: number;
  level: number;              // Güncellenmiyor, hep 1
  streak: number;             // current_streak ile aynı
  current_streak: number; max_streak: number;
  daily_xp: number; weekly_xp: number;   // Güncellenmiyor
  quizzes_completed: number;
  last_active_date: string | null;       // YYYY-MM-DD (UTC)
  updated_at: string;
}
```

### 11.3 Başarımlar
```
GET /api/users/me/achievements
```
Kazanılan başarımları en yeniden eskiye döner:
```typescript
Array<{ id: string; name: string; description: string; icon_url: string; category: string;
        requirement_type: string; requirement_value: number; earned_at: string }>
```
Tüm başarımların listesini dönen bir endpoint yoktur. Kilitli olanları göstermek için liste istemcide sabit tutulur (16.5).

### 11.4 Seri Geçmişi (Bu Hafta)
```
GET /api/users/me/streak-history
```
Her zaman 7 eleman döner (Pazartesi → Pazar):
```typescript
Array<{ label: "Pzt" | "Sal" | "Çrş" | "Per" | "Cum" | "Cts" | "Paz"; date: string; done: boolean; isToday: boolean }>
```
Günler UTC'ye göre hesaplanır.

### 11.5 Profil Güncelleme
```
PATCH /api/users/me
```
Alan adları **camelCase**'dir.
```typescript
{
  username?: string;          // 3-30 karakter, [a-z0-9._] — kayıttakinden gevşek; istemcide kayıt regex'ini uygulayın
  email?: string;             // currentPassword zorunlu
  currentPassword?: string;
  newPassword?: string;       // Min 6, currentPassword zorunlu
  avatarUrl?: string;         // Geçerli URL (dosya yükleme yok)
  dailyGoalXp?: "10" | "20" | "50" | "100";   // String
}
```
- **Response:** `{ id, email, username, avatar_url, daily_goal_xp }`
- **Hatalar:**
  - `400` validasyon
  - `401` `Mevcut şifre hatalı`
  - `409` `Bu kullanıcı adı zaten kullanılıyor` / `Bu e-posta zaten kullanılıyor`

### 11.6 Sınav Kayıtları
```
GET    /api/users/me/enrollments
POST   /api/users/me/enrollments            Body: { "exam_type_id": "<uuid>" }
DELETE /api/users/me/enrollments/:examTypeId
PATCH  /api/users/me/active-exam            Body: { "exam_type_id": "<uuid>" }
```
**GET** yanıtı (yalnızca aktif kayıtlar):
```typescript
Array<{ id: string; exam_type_id: string; enrolled_at: string; exam_type_name: string; exam_type_slug: string; exam_group_name: string; exam_group_slug: string }>
```

| İşlem | Başarılı | Hatalar |
|-------|----------|---------|
| `POST` | `201` enrollment kaydı. Silinmiş kayıt yeniden etkinleşir | `404 Exam type not found`, `409 Already enrolled` |
| `DELETE` | `{ newActiveExamTypeId: string \| null }`. Silinen aktif sınavsa en eski kayda geçilir | `400 Son kayıtlı sınavınızı silemezsiniz`, `404 Enrollment not found` |
| `PATCH active-exam` | `{ id, username, email, active_exam_type_id }` | `404 Not enrolled in this exam type` |

`POST` aktif sınavı değiştirmez, gerekirse ardından `PATCH active-exam` çağrılır. Bu iki endpointte `exam_type_id` sunucuda doğrulanmaz, istemci geçerli bir UUID göndermelidir.

---

## 12. Mağaza — `/api/store`

### 12.1 Ürünler (Opsiyonel Auth, misafir de görür)
```
GET /api/store/items      → StoreItem[] (aktif ürünler, fiyata göre artan)
```

| Ürün | `item_type` | Fiyat | Süre | Durum |
|------|-------------|-------|------|-------|
| Seri Dondurma 🧊 | `streak_freeze` | 20 | 24 saat | ⚠️ Etkisi sunucuda uygulanmıyor |
| Sınırsız Enerji 🔋 | `unlimited_energy` | 40 | 8 saat | ✅ Çalışıyor |
| XP Boost ⚡ | `xp_boost` | 30 | 1 saat | ⚠️ Etkisi sunucuda uygulanmıyor |
| 5 Enerji | `energy_refill` | 15 | — | `metadata.energy_count = 5` |
| 15 Enerji | `energy_refill` | 35 | — | `metadata.energy_count = 15` |
| 25 Enerji (Tam Doldur) | `energy_refill` | 50 | — | `metadata.energy_count = 25` |

**Misafir görünümü:**
- Ürünler listelenir ve üstte "Profil Oluştur" banner'ı gösterilir.
- Yalnızca `energy_refill` ürünleri yerel palamutla alınabilir (10.4). Diğerleri devre dışıdır.
- Envanter, efektler ve palamut paketleri gizlenir.

### 12.2 Envanter (Auth)
```
GET /api/store/inventory
```
```typescript
Array<{ id: string; item_id: string; quantity: number /* 0 olabilir */; purchased_at: string;
        name: string; description: string; icon_url: string; item_type: string; duration_hours: number | null }>
```

### 12.3 Aktif Efektler (Auth)
```
GET /api/store/effects   → Array<{ item_type: "streak_freeze" | "unlimited_energy" | "xp_boost"; expires_at: string }>
```

### 12.4 Satın Alma (Auth)
```
POST /api/store/purchase       (201)
Body: { itemId: uuid; quantity?: number /* 1-10, default 1 */ }
```
- **Response:** `{ balance: number; spent: number; item: string; energy?: number }`. `energy` yalnızca `energy_refill` için gelir ve yeni enerji değeridir.
- `energy_refill` anında uygulanır, envantere girmez. Enerji en fazla 25 olur.
- Süreli ürünler envantere eklenir ve 12.5 ile etkinleştirilir.
- **Hatalar:** `404 Item not found`, `400 Insufficient acorn balance`

### 12.5 Etkinleştirme (Auth)
```
POST /api/store/activate/:itemId      // itemId = store_items.id (envanterdeki item_id)
```
- **Response:** `{ itemType: string; expiresAt: string }`
- Envanterden 1 adet düşer. Aynı tipte aktif efekt varsa süre **uzatılmaz**, şimdiden başlayan yeni süreyle değiştirilir.
- **Hatalar:**
  - `404 Item not found in inventory or quantity is 0`
  - `400 This item cannot be activated` (süresiz ürün)

### 12.6 Palamut Paketleri (Auth)
```
GET /api/store/acorn-packages
→ [{ id: "pkg_50", amount: 50, label: "50 Acorn" }, { id: "pkg_150", ... }, { id: "pkg_500", ... }]
```
Yalnızca statik bir liste döner, **gerçek parayla satın alma endpoint'i yoktur**. Web istemcisi "Payment system coming soon!" mesajı gösterir. Mobilde App Store / Google Play IAP eklenecekse backend'e makbuz doğrulama endpoint'i yazılmalıdır.

---

## 13. Liderlik Tablosu — `/api/leaderboard`

```
GET /api/leaderboard?league=bronze        (auth)
```
- `league`: `bronze | silver | gold | diamond`, varsayılan `bronze`. Geçersiz değer `400 Invalid league value` döner.
- **Response:** `Array<{ username: string; avatar_url: string | null; xp_earned: number; rank: number | null }>`. Bu haftanın kayıtlarını (Pazartesi başlangıçlı) `xp_earned` değerine göre azalan sırayla döner, en fazla 30.
- ⚠️ Tabloyu dolduran bir işlem yoktur, endpoint şu an **boş dizi** döner. Arayüz boş durumu desteklemelidir. Misafire bunun yerine kayıt çağrısı gösterilir.

---

## 14. Arkadaşlık — `/api/friends`

Tüm endpointler auth gerektirir.
```
GET    /api/friends              → Arkadaş listesi
GET    /api/friends/requests     → Bana gelen bekleyen istekler
POST   /api/friends/request      Body: { "username": "string" }          (201)
PATCH  /api/friends/:id          Body: { "action": "accept" | "reject" }   (:id = friendship_id)
DELETE /api/friends/:id          → Arkadaşlıktan çıkar (:id = friendship_id)
```
```typescript
// GET /api/friends
Array<{ friendship_id: string; user_id: string; username: string; avatar_url: string | null;
        xp: number | null; level: number | null; current_streak: number | null; friends_since: string }>
// GET /api/friends/requests
Array<{ friendship_id: string; user_id: string /* gönderen */; username: string; avatar_url: string | null; requested_at: string }>
```
- **İstek gönderme (`POST request`):** `201` ve friendship kaydı döner. Alıcıya `friend_request` bildirimi düşer.
- **Kabul (`PATCH` accept):** `{ message: "Friend request accepted" }` döner. Gönderene `friend_accepted` bildirimi düşer.
- **Ret (`PATCH` reject):** `{ message: "Friend request rejected" }` döner ve kayıt silinir.
- **Silme (`DELETE`):** `{ message: "Friend removed" }` döner.
- **Hatalar:**
  - `404`: `User not found`, `Pending request not found`, `Friendship not found`
  - `400`: `Cannot send friend request to yourself`, `Already friends`, `Friend request already exists`
- `status` alanı `0` ise beklemede, `1` ise kabul edilmiş demektir.

---

## 15. Bildirimler — `/api/notifications`

Tüm endpointler auth gerektirir.
```
GET   /api/notifications?page=1&limit=20   → { notifications: Notification[]; total; page; limit }   (önce okunmamışlar, sonra yeniden eskiye)
GET   /api/notifications/unread-count      → { count: number }
PATCH /api/notifications/:id/read          → { message: "Marked as read" }   (404 Notification not found)
POST  /api/notifications/read-all          → { marked: number }
```
- Mevcut bildirim tipleri: `friend_request`, `friend_accepted`.
- Push notification altyapısı (FCM/APNs, cihaz token kaydı) **yoktur**. `unread-count` uygulama ön plana geldiğinde ya da periyodik olarak sorgulanır. `flutter_local_notifications` yalnızca yerel hatırlatmalar için kullanılabilir, ör. "Enerjin doldu".

---

## 16. Oyun Mekanikleri

### 16.1 Enerji
- Maksimum enerji 25'tir. 10 dakikada +1 yenilenir.
- Sunucu yenilemeyi tembel (lazy) hesaplar: `GET /users/me`, `POST /quiz/start` ve enerji satın alımında.
- Her yanlış ve atlanmamış cevapta −1 düşer. `unlimited_energy` aktifse düşmez ve enerji 0 iken de quiz başlatılabilir.
- Enerji 0 iken `POST /quiz/start` 403 döner.
- **Geri sayım:** Kayıtlı kullanıcıda `next_energy_at` değeri kullanılır. Bu değer geçmişte kalırsa `/users/me` yeniden çağrılır. Misafirde 10.4'teki yerel hesap kullanılır.
- **Enerji diyaloğu:** Enerji paketleri `/store/items` içindeki `energy_refill` ürünleridir. Kayıtlı kullanıcı `POST /store/purchase` ile, misafir yerel palamutla alır.

### 16.2 Palamut (Acorn)

| Kazanma | Miktar |
|---------|--------|
| Quiz doğru cevabı (`skip_rewards: false`) | +1 / doğru |
| Sandık | +`reward_amount` (içerikte 10) |
| Başarım | +5 |
| Yeni hesap | 500 (ya da misafir bakiyesi) |
| Misafir birleştirme | +`earned_acorns` |

Palamut yalnızca mağazada harcanır. İşlem tipleri: `earned_quiz`, `earned_achievement`, `spent_store`, `guest_sync`.

### 16.3 XP
- Doğru soruların `point_value` toplamıdır (şu an her soru 1). `user_stats.xp` ve `total_xp` değerlerine eklenir.
- `level`, `daily_xp` ve `weekly_xp` güncellenmez, `level` her zaman 1 döner. API'deki `level` kullanılmaz; seviye istemcide hesaplanır:
  - Seviye = `floor(total_xp / 500) + 1`
  - Seviye çubuğu = `total_xp % 500` / `500` XP
  - Web profil sayfası (`pages/profile/index.vue`) bu formülü kullanır, mobil de aynısını kullanmalıdır.
- Günlük hedef (`daily_goal_xp`) profilde ayarlanır. Bugünkü XP'yi dönen bir endpoint yoktur.

### 16.4 Seri (Streak)
- Ödüllü (`skip_rewards: false`) bir quiz bitince güncellenir.
- Son aktif gün dün ise seri +1 olur, bugün ise değişmez, daha eskiyse 1'e döner.
- Günler **UTC**'ye göre sayılır. Türkiye saatiyle gün 03:00'te değişir.
- Seri bir sonraki quiz'e kadar sıfırlanmaz. `last_active_date` dünden eskiyse arayüzde seri **0** gösterilmelidir.
- `max_streak` tüm zamanların rekorudur.

### 16.5 Başarımlar (Seed)

| İkon | Ad | Koşul (`requirement_type`) |
|------|----|-----------------------------|
| 🎯 | Nişancı | Bir testte %85+ doğruluk (`quiz_accuracy`) |
| 🌟 | Mükemmeliyetçi | Bir testte tüm sorular doğru (`quiz_perfect`) |
| 🌱 | İlk Adım | 1 test tamamla (`quizzes_completed`) |
| 📚 | Hızlı Öğrenci | 10 test tamamla (`quizzes_completed`) |
| 🏆 | Çalışkan | 50 test tamamla (`quizzes_completed`) |
| 🔥 | Azimli | 7 gün seri (`streak_days`) |
| ⚡ | Tutkulu | 30 gün seri (`streak_days`) |

Yeni kazanılan başarımı göstermek için `finish-bulk` öncesi ve sonrası `GET /users/me/achievements` karşılaştırılabilir.

---

## 17. Veri Tipleri

```typescript
interface ExamGroup { id: string; name: string; slug: string; description: string; sort_order: number; is_active: boolean }
interface ExamType  { id: string; exam_group_id: string; name: string; slug: string; description: string; sort_order: number; is_active: boolean }

interface Module { id: string; exam_type_id: string; name: string; description: string; icon_url: string; sort_order: number; is_active: boolean; created_at: string }

interface Course { id: string; name: string; description: string; icon_url: string; color: string /* hex */; sort_order: number; exam_type_id: string | null; module_id: string | null }

interface Topic {
  id: string; course_id: string; name: string; description: string; icon_url: string; sort_order: number;
  total_lessons: number; max_crown_level: number; unlock_after: string | null /* kullanılmıyor */;
  status: "pending" | "approved"; created_by: string | null;
}

interface Step {
  id: string; topic_id: string; name: string; description: string; sort_order: number; tests_required: number;
  step_type: "lesson" | "reward"; reward_type: "acorn" | "store_item" | null; reward_amount: number | null; reward_item_id: string | null;
  created_at: string; updated_at: string;
}

interface Test { id: string; step_id: string; sort_order: number; name: string | null; created_at: string }

type QuestionType = "multiple_choice" | "true_false" | "fill_blank" | "matching" | "ordering" | "flashcard" | "swipe";

interface Question {
  id: string; topic_id: string; step_id: string | null; test_id: string | null; sort_order: number;
  question_text: string;            // HTML, <!--img--> işareti içerebilir
  image_url: string | null;         // Web sunucusuna göreli yol
  question_type: QuestionType;
  difficulty: 1 | 2 | 3;            // Kolay / Orta / Zor
  status: "draft" | "pending" | "approved" | "archived";   // Quiz'e yalnızca approved gelir
  hint: string | null; tags: string[] | null; difficulty_weight: number;
  explanation: string | null;       // Düz metin + <sup>/<sub>
  point_value: number;              // XP — default 1
  type_data: Record<string, unknown> | null;   // Bkz. 8.7
  exam_source: string | null;       // "2024 KPSS-LİSANS"
  created_by: string | null; created_at: string;
}

interface Answer { id: string; question_id: string; answer_text: string /* HTML */; is_correct: boolean }

interface QuizSession {
  id: string; user_id: string; topic_id: string; step_id: string | null; test_id: string | null;
  session_type: "lesson" | "review" | "practice" | "step_final" | "topic_final"; is_final_test: boolean;
  started_at: string; finished_at: string | null; score: number /* kullanılmıyor */; xp_earned: number;
  duration: number | null /* sn */; total_questions: number; correct_answers: number; energy_lost: number;
}

interface UserStepProgress {
  id: string; user_id: string; step_id: string; tests_completed: number; is_step_completed: boolean;
  step_final_passed: boolean; stars: number /* kullanılmıyor */; best_score: number /* 0-100 */; completed_at: string | null;
}

interface UserTopicProgress {   // Backend yazmıyor — hep null
  id: string; user_id: string; topic_id: string; crown_level: number; lessons_completed: number; is_unlocked: boolean;
  last_practiced_at: string | null; strength: number; next_review_at: string | null;
}

interface StoreItem {
  id: string; name: string; description: string; icon_url: string; price_acorn: number;
  item_type: "streak_freeze" | "unlimited_energy" | "xp_boost" | "energy_refill";
  duration_hours: number | null; is_active: boolean; metadata: { energy_count?: number }; created_at: string;
}

interface Notification { id: string; user_id: string; type: "friend_request" | "friend_accepted" | string; title: string; body: string | null; is_read: boolean; created_at: string }

interface QuestionReport {
  id: string; question_id: string;
  user_id: string | null;           // Kayıtlı kullanıcı
  guest_id: string | null;          // Misafir
  reason: "wrong_answer" | "unclear_question" | "wrong_explanation" | "typo" | "missing_image" | "other";
  description: string | null; status: "pending" | "reviewed" | "fixed" | "dismissed";
  admin_note: string | null; resolved_by: string | null; resolved_at: string | null; created_at: string;
}

// Misafir — yalnızca cihazda (Bölüm 10.3)
interface GuestQuizResult { topicId: string; stepId?: string; testId?: string; correctCount: number; totalQuestions: number }
```

**İçerik hiyerarşisi:**
```
ExamGroup → ExamType → Module → Course → Topic → Step [lesson | reward] → Test → Question → Answer
```
Güncel içerik (KPSS Lisans):
- **Genel Yetenek:** Türkçe, Matematik
- **Genel Kültür:** Tarih, Coğrafya, Vatandaşlık

Her konuda lesson adımları (her biri 1 test, yaklaşık 10 soru) ve aralarda 10 palamutluk sandıklar bulunur. Konunun sonunda istemci tarafından eklenen bir boss düğümü vardır.

---

## 18. Hata Formatı ve Kodları

| Kod | Anlam |
|-----|-------|
| 400 | Validasyon veya iş kuralı ihlali |
| 401 | Token yok, geçersiz ya da süresi dolmuş (`Authorization token required` / `Invalid or expired token`) veya hatalı kimlik bilgisi |
| 403 | Enerji bitti, önceki adım tamamlanmamış, yetki yok |
| 404 | Kaynak bulunamadı |
| 409 | Çakışma: e-posta/kullanıcı adı kullanımda, zaten kayıtlı, tekrar bildirim |
| 429 | Rate limit |
| 500 | `Internal server error` |
| 503 | Health check: veritabanı yok |

**İş kuralı hatası:**
```json
{ "error": "Hata mesajı" }
```

**Validasyon (Zod) hatası:** Alan hataları `errors.properties.<alan>.errors[]` altındadır.
```json
{ "errors": { "errors": [], "properties": { "password": { "errors": ["Password must be at least 6 characters"] } } } }
```
> Web istemcisi bu formatı yanlış okuyor (`_errors` arıyor). Mobilde yukarıdaki yol kullanılmalıdır.

Hata mesajları Türkçe ve İngilizce karışıktır. Kullanıcıya gösterilecek metinler HTTP koduna ve endpoint'e göre istemcide eşlenmelidir.

---

## 19. Bilinen Kısıtlar ve Backend Hataları

Arayüz bunlara göre tasarlanmalı ya da backend'e iş açılmalıdır.

| Konu | Durum | Mobilde ne yapılmalı |
|------|-------|----------------------|
| Enerji yenilenmesi | **Düzeltildi:** Enerji 25'ten düşerken yenilenme sayacı artık o andan başlıyor. Eskiden uzun süre dolu kalan kullanıcının harcadığı enerji anında geri geliyordu. Düzeltme yayına alınmadan önceki sunucularda `next_energy_at` geçmişte kalabilir | `next_energy_at` geçmişteyse `/users/me`'yi yeniden çağırın |
| `xp_boost`, `streak_freeze` | Satın alınıp etkinleştirilebiliyor ama hiçbir etkisi yok | Açıklamada belirtin ya da satışı gizleyin |
| Liderlik tablosu | Dolduran bir işlem yok, hep boş | Boş durum ekranı |
| `user_topic_progress` | Hiç yazılmıyor | Konu ilerlemesini adımlardan hesaplayın |
| `level`, `daily_xp`, `weekly_xp`, `stars`, `score` | Güncellenmiyor | İstemcide hesaplayın veya göstermeyin |
| Adım geçme barajı | Yok, testi bitirmek yeterli | — |
| Kilit sistemi | Yalnızca istemcide | 6.4'ü uygulayın |
| Misafir boss sınavı | `guest-start` `sessionType`'ı yok sayıyor, 15 yerine 10 rastgele soru geliyor | — |
| `friends_count` başarımı | Sorgu durum değerini metin olarak (`"accepted"`) arıyor, oysa değer sayı (`1`). Asla kazanılmıyor | — |
| Kayıtta `acorn_balance` | Sunucu istemcinin gönderdiği değere güveniyor | — |
| Misafir verisi aktarımı | Tek bir geçersiz adım ID'si tüm aktarımı iptal ediyor | Göndermeden önce filtreleyin (10.8) |
| Tüm başarımlar listesi | Endpoint yok | İstemcide sabit liste |
| Push notification | Yok | `unread-count` sorgusu |
| Palamut satın alma (IAP) | Yok | "Yakında" |
| Refresh token, logout, hesap silme | Yok. **Hesap silme App Store için zorunludur**, backend'e eklenmeli | — |
| Avatar yükleme | Yok, yalnızca URL kaydedilebiliyor | — |

---

## 20. Güvenlik ve Teknik Notlar

- **HTTPS** zorunludur. Prodüksiyonda nginx ve Let's Encrypt kullanılır.
- **CORS:** Native istemciler `Origin` başlığı göndermediği için etkilenmez. WebView tabanlı ekranlarda origin'in izin listesine eklenmesi gerekir.
- **Rate limit:** IP bazlıdır (1.2). Sunucu nginx arkasında gerçek istemci IP'sini görür.
- **Body limiti:** JSON için en fazla 1 MB.
- **Şifreler** bcrypt (12 tur) ile saklanır.
- **ID'ler** UUID'dir. Misafir `guestId` değeri de UUID v4 olmalıdır, aksi halde 400 döner.
- **Zaman:** Damgalar ISO 8601 (UTC) formatındadır. Tarih alanları (`last_active_date`, `week_start`, `streak_history.date`) `YYYY-MM-DD` biçimindedir.
- **RBAC:** `permissions` dizisi login ve `/users/me` yanıtlarında gelir. Mobilde admin özelliği yoktur.
- **Doğru cevaplar istemciye gönderilir.** Ödüller sunucuda yeniden doğrulanır, ama cevap anahtarı istemcide görünür durumdadır.
- **Token** yalnızca secure storage'da tutulur ve loglara yazılmaz.

---

## 21. Admin API'leri (Referans)

`/api/admin/*` için `view_admin_panel` yetkisi gerekir. Bazı yazma işlemleri `manage_exams` veya `manage_users` yetkisi de ister. **Mobil uygulamada kullanılmaz.**

| Endpoint | Ek Yetki |
|----------|----------|
| `GET /admin/questions`, `GET /admin/questions/:id` | — |
| `POST /admin/questions`, `POST /admin/questions/bulk` (max 100), `PATCH/DELETE /admin/questions/:id` | — |
| `GET /admin/exam-groups`, `GET /admin/exam-types` | — |
| `POST/PATCH/DELETE /admin/exam-groups`, `/admin/exam-types` | `manage_exams` |
| `GET /admin/courses`, `/admin/modules`, `/admin/topics`, `/admin/steps`, `/admin/tests` | — |
| `POST/PATCH/DELETE` courses, modules, topics; `POST/DELETE` steps, tests | `manage_exams` |
| `GET /admin/stats` (`pending_reports` = bekleyen bildirimi olan **soru** sayısı) | — |
| `GET /admin/pending`, `POST /admin/questions/:id/approve\|reject`, `POST /admin/topics/:id/approve\|reject` | `manage_exams` |
| `GET /admin/reports/groups`: soru bazlı gruplanmış bildirimler (`status`, `report_count`, `guest_count`, `reasons`) | — |
| `GET /admin/reports?questionId=`: bir sorunun bildirimleri; `GET /admin/reports/stats`: durum başına soru sayısı | — |
| `PATCH /admin/reports/question/:questionId`: durum ve notu sorunun tüm bildirimlerine uygular | — |
| `PATCH /admin/reports/:id`: tek bildirim (eski) | — |
| `GET /admin/users`, `GET /admin/roles` | — |
| `POST /admin/users`, `GET/PATCH/DELETE /admin/users/:id`, `PATCH /admin/users/:id/role` | `manage_users` |

---

## 22. Geliştirme Sırası ve Mevcut Durum

Mevcut mobil projede ekran iskeletleri ve repository'ler var. Aşağıdaki sıra hem yeni hem eksik işler için önerilir:

1. **Altyapı**
   - API istemcisi: token ekleme, 401'de misafire dönüş, iki hata formatını ayrıştırma
   - Yapılandırma: `API_BASE_URL` ve `WEB_BASE_URL` ayrı değerler
   - Offline quiz kuyruğu (Hive + `connectivity_plus`)
2. **Misafir modu altyapısı (Bölüm 10)**
   - GuestState, `guestId`, enerji yenilenmesi, palamut, overlay
   - Router'da misafir kuralları
3. **Onboarding**
   - Splash mantığı (3.8)
   - Sınav grubu ve türü seçimi
   - Misafir olarak başlama
4. **Ders haritası**
   - Modül ve ders seçimi, `/courses/:id/full`
   - Düğüm durumları: lesson, sandık, boss (6.4)
   - Sandık açma: üye ve misafir
5. **Quiz**
   - HTML render ve `<!--img-->` yerleşimi (Bölüm 8)
   - Cevap paneli, enerji diyaloğu
   - Üye için `finish-bulk`, misafir için yerel sonuç
   - Sonuç ekranı ve kayıt duvarı
   - Hatalı soru bildirimi: üye ve misafir endpoint'leri
6. **Auth**
   - Giriş ve misafir birleştirme (10.9)
   - Kayıt ve misafir aktarımı (10.8)
   - Şifre sıfırlama (deep link)
7. **Profil ve istatistikler**
   - XP, seri haftası, başarımlar
   - Profil düzenleme, sınav kayıtları
8. **Mağaza**
   - Ürünler, satın alma, envanter, efektler
   - Misafirin enerji alması
9. **Arkadaşlık ve bildirimler**
10. **Liderlik tablosu** (backend verisi hazır olduğunda)
