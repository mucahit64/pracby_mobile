# Pracby — Mobile App Geliştirme Dökümantasyonu

> Bu doküman, Pracby platformunun tüm backend API'lerini, veri modellerini, iş akışlarını ve mobile app geliştirirken ihtiyaç duyulacak tüm teknik bilgileri kapsar.

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
    ├── /courses       → Kurslar
    ├── /exam-groups   → Sınav Grupları
    ├── /modules       → Modüller
    ├── /quiz          → Quiz Sistemi
    ├── /users         → Kullanıcı Profili
    ├── /leaderboard   → Liderlik Tablosu
    ├── /store         → Mağaza
    ├── /friends       → Arkadaşlık
    └── /notifications → Bildirimler
    │
    ▼
PostgreSQL (Knex.js ORM)
```

### Auth Yöntemi
- **JWT Token** (Bearer token, 7 gün geçerli)
- Header: `Authorization: Bearer <token>`
- Rate limit: Auth endpointlerine dakikada maksimum 10 istek

---

## 2. Sağlık Kontrolü

```
GET /api/health
```

**Response:**
```json
{ "status": "ok", "timestamp": "2026-05-21T10:00:00.000Z" }
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
  username: string;               // 3-20 karakter, küçük harf/rakam/nokta/alt çizgi
  password: string;               // Min 6 karakter
  exam_type_id?: string;          // UUID — seçilen sınav türü
  acorn_balance?: number;         // Başlangıç acorn (opsiyonel)
  energy?: number;                // 0-25 arası (opsiyonel)
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

**Response:**
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

**Hata Kodları:**
- `409` — Email veya kullanıcı adı zaten kullanımda
- `500` — Varsayılan rol bulunamadı

---

### 3.2 Giriş

```
POST /api/auth/login
```

**Request Body:**
```typescript
{
  identifier: string;   // Email veya kullanıcı adı
  password: string;
}
```

**Response:**
```typescript
{
  token: string;
  user: { id, email, username, role, active_exam_type_id, ... }
}
```

**Hata Kodları:**
- `401` — Geçersiz kimlik bilgileri

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

---

### 3.4 Şifre Sıfırlama

```
POST /api/auth/forgot-password
Body: { "email": "user@mail.com" }
```

```
POST /api/auth/reset-password
Body: { "token": "<64 char hex token>", "password": "newpassword" }
```

---

### 3.5 Misafir İlerlemesi Birleştirme (Auth Gerekli)

```
POST /api/auth/merge-guest-progress
Authorization: Bearer <token>
```

**Request Body:**
```typescript
{
  quiz_results: Array<{
    topicId: string;
    stepId?: string;
    testId?: string;
    correctCount: number;
    totalQuestions: number;
  }>;
  claimed_rewards: string[];    // step ID listesi
  earned_acorns: number;
}
```

---

## 4. Sınav Grupları — `/api/exam-groups`

```
GET /api/exam-groups
```

**Response:**
```typescript
Array<{
  id: string;
  name: string;       // "KPSS", "YKS", "ALES", "DGS"
  slug: string;       // "kpss", "yks", "ales", "dgs"
  description: string;
  sort_order: number;
  is_active: boolean;
  exam_types: Array<{
    id: string;
    name: string;     // "KPSS Lisans", "KPSS Önlisans" vb.
    slug: string;     // "lisans", "onlisans", "ortaogretim"
    description: string;
    sort_order: number;
    is_active: boolean;
  }>;
}>
```

**Not:** Şu an sadece KPSS aktif. Diğerleri `is_active: false`.

---

## 5. Modüller — `/api/modules`

```
GET /api/modules?exam_type_id=<uuid>
GET /api/modules/:id
```

**Response (Liste):**
```typescript
Array<{
  id: string;
  exam_type_id: string;
  name: string;           // "Genel Kültür", "Genel Yetenek" vb.
  description: string;
  icon_url: string;
  sort_order: number;
  is_active: boolean;
  created_at: string;
}>
```

---

## 6. Kurslar — `/api/courses`

Misafir kullanıcılar da bu endpointlere erişebilir (isteğe bağlı auth).

### 6.1 Kurs Listesi

```
GET /api/courses?exam_type_id=<uuid>&module_id=<uuid>
```

**Response:**
```typescript
Array<{
  id: string;
  name: string;         // "Tarih", "Matematik", "Türkçe" vb.
  description: string;
  icon_url: string;
  color: string;        // Hex renk kodu
  sort_order: number;
  exam_type_id: string;
  module_id: string;
}>
```

### 6.2 Kurs Detayı

```
GET /api/courses/:id
```

### 6.3 Kursun Konuları

```
GET /api/courses/:id/topics
```

**Response:** `Array<Topic>`

### 6.4 Tam Kurs Detayı (İlerleme Dahil)

```
GET /api/courses/:id/full
Authorization: Bearer <token>  (opsiyonel — varsa ilerleme eklenir)
```

**Response:**
```typescript
{
  id: string;
  name: string;
  // ...kurs alanları
  topics: Array<{
    id: string;
    course_id: string;
    name: string;
    description: string;
    icon_url: string;
    sort_order: number;
    total_lessons: number;
    max_crown_level: number;
    unlock_after: string | null;   // Önceki topic UUID
    status: "approved" | "pending" | "rejected";
    steps: Array<{
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
      progress: UserStepProgress | null;  // null ise kullanıcı başlamamış
    }>;
    progress: UserTopicProgress | null;
  }>;
}
```

---

## 7. Quiz Sistemi — `/api/quiz`

### 7.1 Misafir Quiz Başlatma (Auth Gerekmez)

```
GET /api/quiz/guest-start?topicId=<uuid>&stepId=<uuid>&testId=<uuid>&sessionType=lesson
```

**Response:**
```typescript
{
  questions: Array<Question>
}
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
  stepId?: string;       // UUID — belirli bir step için
  testId?: string;       // UUID — belirli bir test için
  sessionType: "lesson" | "review" | "practice" | "step_final" | "topic_final";
}
```

**Session Türleri:**
| Tür | Soru Sayısı | Seçim |
|-----|------------|-------|
| `lesson` | 10 (veya testteki tüm sorular) | Sıralı, testId ile |
| `review` | 10 | Rastgele, konu seviyesinde |
| `practice` | 10 | Rastgele |
| `step_final` | 15 | Zorluk dağılımı: 2×K1 + 7×K2 + 6×K3 |
| `topic_final` | 15 | Tüm adımlardan zorluk dağılımı |

**Response:**
```typescript
{
  session: {
    id: string;             // sessionId — sonraki isteklerde kullanılacak
    user_id: string;
    topic_id: string;
    step_id: string | null;
    test_id: string | null;
    session_type: string;
    is_final_test: boolean;
    started_at: string;
    total_questions: number;
    score: number;
    xp_earned: number;
    correct_answers: number;
    energy_lost: number;
  };
  questions: Array<Question>;
}
```

**Hata Kodları:**
- `403` — Enerji bitti
- `404` — Konu veya soru bulunamadı

---

### 7.3 Cevap Gönderme

```
POST /api/quiz/:sessionId/answer
Authorization: Bearer <token>
```

**Request Body:**
```typescript
{
  questionId: string;           // UUID
  answerId?: string;            // UUID — multiple_choice, true_false, swipe için
  isSkipped?: boolean;          // default: false
  timeSpent?: number;           // Milisaniye
  answeredAt?: string;          // ISO 8601 timestamp (client-side)
  textAnswer?: string;          // fill_blank için, max 500 karakter
  matchingAnswer?: Array<{      // matching için
    leftIndex: number;
    rightIndex: number;
  }>;
  orderedIndices?: number[];    // ordering için — kullanıcının sırası
  isCorrect?: boolean;          // flashcard için (client-side değerlendirme)
}
```

**Response:**
```typescript
{
  isCorrect: boolean;
  energy_remaining: number;     // Kalan enerji (0-25)
}
```

**Önemli:** Yanlış cevapta enerji 1 azalır (unlimited_energy efekti yoksa).

---

### 7.4 Oturum Bitirme (Tek Tek Cevap Gönderildikten Sonra)

```
POST /api/quiz/:sessionId/finish
Authorization: Bearer <token>
```

**Response:** (aşağıda)

---

### 7.5 Toplu Cevap Gönderip Bitirme (Tek İstek)

```
POST /api/quiz/:sessionId/finish-bulk
Authorization: Bearer <token>
```

**Request Body:**
```typescript
{
  answers: Array<AnswerInput>;   // Tüm cevaplar (7.3'teki format)
  skip_rewards?: boolean;        // default: false — enerji bitmişse true
}
```

**Response:**
```typescript
{
  session: {
    id: string;
    correct_answers: number;
    total_questions: number;
    xp_earned: number;
    duration: number;             // Saniye
    score: number;
    finished_at: string;
  };
  xp_earned: number;
  acorn_earned: number;
  step_completed: boolean;        // Bu adım tamamlandı mı?
  topic_completed: boolean;       // Bu konu tamamlandı mı?
  new_achievements: Array<Achievement>;
  step?: Step;                    // Mevcut adım bilgisi
  next_step?: Step | null;        // Sonraki adım (varsa)
  reward_available?: boolean;     // Ödül adımı var mı?
  reward_step?: Step | null;      // Ödül adım detayı
}
```

---

### 7.6 Ödül Talep Etme

```
POST /api/quiz/reward/:stepId/claim
Authorization: Bearer <token>
```

**Response:**
```typescript
{
  success: boolean;
  reward_type: "acorn" | "store_item";
  reward_amount: number;
  acorn_balance: number;         // Güncel bakiye
}
```

---

### 7.7 Soru Şikayeti

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

---

## 8. Kullanıcı Profili — `/api/users`

Tüm endpointler auth gerektirir.

### 8.1 Profil

```
GET /api/users/me
```

**Response:**
```typescript
{
  id: string;
  email: string;
  username: string;
  avatar_url: string | null;
  daily_goal_xp: number;
  energy: number;                  // 0-25
  energy_refreshed_at: string;     // ISO 8601 — son enerji yenilenme zamanı
  next_energy_at: string | null;   // ISO 8601 — sonraki enerji ne zaman gelecek (null = dolu)
  acorn_balance: number;
  active_exam_type_id: string | null;
  created_at: string;
  role: string;                    // "student", "admin" vb.
  permissions: string[];           // ["view_admin_panel", "manage_exams", ...]
}
```

**Enerji Sistemi:**
- Maksimum: 25
- Her 10 dakikada 1 enerji yenilenir
- Yanlış cevapta 1 enerji azalır
- `next_energy_at` null ise enerji dolu

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
  level: number;
  streak: number;
  total_xp: number;
  max_streak: number;
  daily_xp: number;
  weekly_xp: number;
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

**Response:**
```typescript
Array<{
  id: string;
  name: string;
  description: string;
  icon_url: string;
  category: string;
  requirement_type: string;
  requirement_value: number;
  earned_at: string;
}>
```

---

### 8.4 Seri Geçmişi (Bu Hafta)

```
GET /api/users/me/streak-history
```

**Response:**
```typescript
Array<{
  date: string;            // YYYY-MM-DD (Pazartesiden Pazara)
  xp_earned: number;
  quizzes_completed: number;
}>
// Her zaman 7 elemanlı (bu haftanın günleri)
```

---

### 8.5 Profil Güncelleme

```
PATCH /api/users/me
```

**Request Body:**
```typescript
{
  username?: string;
  avatar_url?: string;
  daily_goal_xp?: number;
  current_password?: string;
  new_password?: string;
}
```

---

### 8.6 Sınav Kayıtları

```
GET /api/users/me/enrollments
POST /api/users/me/enrollments   Body: { "exam_type_id": "<uuid>" }
DELETE /api/users/me/enrollments/:examTypeId
PATCH /api/users/me/active-exam  Body: { "exam_type_id": "<uuid>" }
```

---

## 9. Mağaza — `/api/store`

### 9.1 Mağaza Ürünleri (Misafir Erişebilir)

```
GET /api/store/items
```

**Response:**
```typescript
Array<{
  id: string;
  name: string;
  description: string;
  icon_url: string;
  price_acorn: number;
  item_type: "streak_freeze" | "unlimited_energy" | "xp_boost" | "energy_refill";
  duration_hours: number | null;    // null = kalıcı/tek kullanımlık
  is_active: boolean;
  metadata: object;                 // Ürüne özel ek veri (energy_count vb.)
  created_at: string;
}>
```

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
  quantity: number;
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

**Response:**
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
  itemId: string;
  quantity: number;   // Min 1
}
```

**Response:**
```typescript
{
  balance: number;    // Güncel acorn bakiyesi
  spent: number;      // Harcanan acorn
  item: string;       // Ürün adı
  energy?: number;    // Sadece energy_refill ürünleri için
}
```

---

### 9.5 Eşya Aktifleştirme (Auth Gerekli)

```
POST /api/store/activate/:itemId
```

**Response:**
```typescript
{
  itemType: string;
  expiresAt: string;   // ISO 8601
}
```

---

### 9.6 Acorn Paketleri

```
GET /api/store/acorn-packages
```

**Response:**
```typescript
Array<{
  id: string;           // "pkg_50", "pkg_150", "pkg_500"
  amount: number;
  label: string;
}>
```

---

## 10. Liderlik Tablosu — `/api/leaderboard`

```
GET /api/leaderboard?league=bronze
Authorization: Bearer <token>
```

**Parametreler:**
- `league`: `"bronze"` | `"silver"` | `"gold"` | `"diamond"`

**Response:**
```typescript
Array<{
  username: string;
  avatar_url: string | null;
  xp_earned: number;
  rank: number;
}>
// Maksimum 30 kullanıcı, haftalık XP'ye göre sıralı
```

---

## 11. Arkadaşlık — `/api/friends`

Tüm endpointler auth gerektirir.

```
GET    /api/friends                        → Arkadaş listesi
GET    /api/friends/requests               → Bekleyen istekler
POST   /api/friends/request                Body: { "username": "string" }
PATCH  /api/friends/:id                    Body: { "action": "accept" | "reject" }
DELETE /api/friends/:id                    → Arkadaş çıkar
```

**Friendship Status:**
- `0` = Beklemede (pending)
- `1` = Kabul edildi (accepted)
- `2` = Reddedildi (rejected)

---

## 12. Bildirimler — `/api/notifications`

Tüm endpointler auth gerektirir.

```
GET   /api/notifications                   → Bildirim listesi
GET   /api/notifications/unread-count      → { "count": number }
PATCH /api/notifications/:id/read          → Okundu işaretle
POST  /api/notifications/read-all          → Tümünü okundu yap
```

**Notification Response:**
```typescript
Array<{
  id: string;
  user_id: string;
  type: string;
  title: string;
  body: string;
  is_read: boolean;
  created_at: string;
}>
```

---

## 13. Tüm Veri Tipleri (TypeScript)

### User (Kullanıcı)
```typescript
interface User {
  id: string;                      // UUID
  email: string;
  username: string;
  password_hash: string;           // Backend — client'a gönderilmez
  avatar_url: string | null;
  daily_goal_xp: number;           // Default: 50
  energy: number;                  // 0-25, constraint: >= 0
  energy_refreshed_at: string;     // ISO 8601
  active_exam_type_id: string | null;
  acorn_balance: number;           // Constraint: >= 0
  role_id: string;                 // UUID → roles.id
  created_at: string;
}
```

### ExamGroup (Sınav Grubu)
```typescript
interface ExamGroup {
  id: string;
  name: string;       // "KPSS"
  slug: string;       // "kpss"
  description: string;
  sort_order: number;
  is_active: boolean;
}
```

### ExamType (Sınav Türü)
```typescript
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

### Module (Modül)
```typescript
interface Module {
  id: string;
  exam_type_id: string;
  name: string;         // "Genel Kültür"
  description: string;
  icon_url: string;
  sort_order: number;
  is_active: boolean;
  created_at: string;
}
```

### Course (Ders)
```typescript
interface Course {
  id: string;
  name: string;           // "Tarih"
  description: string;
  icon_url: string;
  color: string;          // "#FF6B6B"
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
  total_lessons: number;
  max_crown_level: number;    // Default: 5
  unlock_after: string | null; // Önceki topic ID (kilit sistemi)
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
  tests_required: number;          // Default: 5 — tamamlanma için gereken test sayısı
  step_type: "lesson" | "reward";
  reward_type: "acorn" | "store_item" | null;
  reward_amount: number | null;
  reward_item_id: string | null;
  created_at: string;
  updated_at: string;
}
```

### Test (Sınav/Test)
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
  | "multiple_choice"   // Çoktan seçmeli
  | "true_false"        // Doğru/Yanlış
  | "fill_blank"        // Boşluk doldurma
  | "matching"          // Eşleştirme
  | "ordering"          // Sıralama
  | "flashcard"         // Kart çevirme
  | "swipe";            // Kaydırma (doğru/yanlış swipe)

type QuestionStatus = "pending" | "approved" | "rejected";

interface Question {
  id: string;
  topic_id: string;
  question_text: string;
  image_url: string | null;
  question_type: QuestionType;
  difficulty: 1 | 2 | 3;           // 1=Kolay, 2=Orta, 3=Zor
  status: QuestionStatus;
  hint: string | null;
  tags: string[] | null;
  difficulty_weight: number;       // Default: 1.0
  created_by: string | null;
  explanation: string | null;
  point_value: number;             // Default: 1 (XP hesaplamasında kullanılır)
  step_id: string | null;
  type_data: QuestionTypeData | null;  // Soru türüne göre ek veri
  test_id: string | null;
  sort_order: number;
  created_at: string;
  // Client'a gönderilince:
  answers?: Answer[];
}
```

### QuestionTypeData (Soru Türü Verisi)
```typescript
// fill_blank için:
interface FillBlankData {
  acceptable_answers: string[];   // Kabul edilen cevaplar (lowercase karşılaştırılır)
}

// matching için:
interface MatchingData {
  pairs: Array<{ left: string; right: string }>;
}

// ordering için:
interface OrderingData {
  items: Array<{ text: string; position: number }>;   // position doğru sırayı belirtir
}

// flashcard için type_data genellikle { front: string, back: string }
// swipe ve true_false için type_data genellikle null
```

### Answer (Cevap Seçeneği)
```typescript
interface Answer {
  id: string;
  question_id: string;
  answer_text: string;
  is_correct: boolean;
}
```

### QuizSession (Quiz Oturumu)
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
  score: number;
  xp_earned: number;
  duration: number;               // Saniye
  total_questions: number;
  correct_answers: number;
  energy_lost: number;
}
```

### UserAnswer (Kullanıcı Cevabı)
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

### UserStats (Kullanıcı İstatistikleri)
```typescript
interface UserStats {
  user_id: string;
  xp: number;
  level: number;
  streak: number;
  total_xp: number;
  max_streak: number;
  daily_xp: number;
  weekly_xp: number;
  current_streak: number;
  quizzes_completed: number;
  updated_at: string;
  last_active_date: string | null;   // YYYY-MM-DD
}
```

### UserTopicProgress (Konu İlerlemesi)
```typescript
interface UserTopicProgress {
  id: string;
  user_id: string;
  topic_id: string;
  crown_level: number;              // 0-max_crown_level
  lessons_completed: number;
  is_unlocked: boolean;
  last_practiced_at: string | null;
  strength: number;                 // 0.0-1.0 (tekrar sistemi kuvveti)
  next_review_at: string | null;    // ISO 8601
}
```

### UserStepProgress (Adım İlerlemesi)
```typescript
interface UserStepProgress {
  id: string;
  user_id: string;
  step_id: string;
  tests_completed: number;
  is_step_completed: boolean;
  step_final_passed: boolean;
  stars: number;                    // 0-3
  completed_at: string | null;
}
```

### Achievement (Başarım)
```typescript
interface Achievement {
  id: string;
  name: string;
  description: string;
  icon_url: string;
  category: string;
  requirement_type: string;         // "streak", "quiz_count", "xp" vb.
  requirement_value: number;
}
```

### UserAchievement (Kazanılan Başarım)
```typescript
interface UserAchievement {
  user_id: string;
  achievement_id: string;
  earned_at: string;
}
```

### StoreItem (Mağaza Ürünü)
```typescript
type ItemType = "streak_freeze" | "unlimited_energy" | "xp_boost" | "energy_refill";

interface StoreItem {
  id: string;
  name: string;
  description: string;
  icon_url: string;
  price_acorn: number;
  item_type: ItemType;
  duration_hours: number | null;    // null = tek kullanımlık/kalıcı
  is_active: boolean;
  metadata: Record<string, unknown>;
  created_at: string;
}
```

### UserActiveEffect (Aktif Efekt)
```typescript
interface UserActiveEffect {
  id: string;
  user_id: string;
  item_type: "streak_freeze" | "unlimited_energy" | "xp_boost";
  expires_at: string;       // ISO 8601
  created_at: string;
}
```

### Leaderboard (Liderlik)
```typescript
type League = "bronze" | "silver" | "gold" | "diamond";

interface LeaderboardEntry {
  id: string;
  user_id: string;
  week_start: string;       // YYYY-MM-DD (Pazartesi)
  xp_earned: number;
  rank: number;
  league: League;
}
```

### Friendship (Arkadaşlık)
```typescript
interface Friendship {
  id: string;
  user_id: string;
  friend_id: string;
  created_at: string;
  status: 0 | 1 | 2;        // 0=Beklemede, 1=Kabul, 2=Reddedildi
}
```

### Notification (Bildirim)
```typescript
interface Notification {
  id: string;
  user_id: string;
  type: string;
  title: string;
  body: string;
  is_read: boolean;
  created_at: string;
}
```

### AcornTransaction (Acorn İşlem Kaydı)
```typescript
type TransactionType = "earned_quiz" | "earned_achievement" | "purchased" | "spent_store";

interface AcornTransaction {
  id: string;
  user_id: string;
  amount: number;           // Pozitif = kazanıldı, negatif = harcandı
  type: TransactionType;
  reference_id: string | null;   // Session ID, item ID vb.
  created_at: string;
}
```

### Role & Permission (RBAC)
```typescript
interface Role {
  id: string;
  name: string;               // "student", "admin", "moderator" vb.
  description: string;
  created_at: string;
}

interface Permission {
  id: string;
  name: string;               // "view_admin_panel", "manage_exams", "manage_users" vb.
  description: string;
}
```

---

## 14. İçerik Hiyerarşisi

```
ExamGroup (Sınav Grubu)
  └── ExamType (Sınav Türü)
        └── Module (Modül)
              └── Course (Ders)
                    └── Topic (Konu)
                          └── Step (Adım)   [lesson | reward]
                                └── Test (Test)
                                      └── Question (Soru)
                                            └── Answer (Cevap)
```

**Örnek:**
```
KPSS (ExamGroup)
  └── KPSS Lisans (ExamType)
        └── Genel Kültür (Module)
              └── Tarih (Course)
                    └── Osmanlı Devleti (Topic)
                          ├── 1. Ders (Step - lesson, tests_required: 5)
                          │     ├── Test 1 (Test — 10 soru)
                          │     ├── Test 2 (Test — 10 soru)
                          │     └── ... (5 test tamamlanınca step biter)
                          ├── Ödül (Step - reward)
                          └── Final (step_final / topic_final)
```

---

## 15. Temel Uygulama Akışları

### 15.1 Yeni Kullanıcı Onboarding Akışı
```
1. Uygulama açılır → /api/exam-groups GET → Sınav grupları gösterilir
2. Kullanıcı sınav türü seçer (exam_type_id alınır)
3. Kayıt formu doldurulur → POST /api/auth/register (exam_type_id dahil)
4. JWT token alınır, güvenli depolanır (Keychain/Keystore)
5. Ana sayfa yüklenir
```

### 15.2 Misafir → Kayıtlı Kullanıcı Akışı
```
1. Kullanıcı kayıt olmadan quiz yapar (GET /api/quiz/guest-start)
2. Quiz sonuçları client-side saklanır (quiz_results, claimed_reward_step_ids)
3. Kayıt sırasında bu veriler guest_data alanı ile gönderilir
4. Backend ilerlemeyi hesaba aktarır
```

### 15.3 Quiz Akışı (Normal Ders)
```
1. Kurs detayı al → GET /api/courses/:id/full
2. Topic ve Step seç
3. Quiz başlat → POST /api/quiz/start (topicId, stepId, testId, sessionType:"lesson")
4. Sorular gelir (session.id kaydedilir)
5. Her soru için cevap gönder → POST /api/quiz/:sessionId/answer
   → isCorrect ve energy_remaining döner
   → Enerji 0 ise quiz bitirilebilir (skip_rewards: true)
6. Quiz bitir → POST /api/quiz/:sessionId/finish-bulk
   → xp_earned, acorn_earned, step_completed, new_achievements döner
7. Sonuç ekranı gösterilir
```

### 15.4 Enerji Sistemi
```
- Maksimum: 25 enerji
- Yenilenme: Her 10 dakikada 1 enerji
- Azalma: Her yanlış cevapta -1
- Dolu enerji: next_energy_at = null
- Enerji 0 → Quiz başlatılamaz (403 hatası)
- unlimited_energy efekti aktifse enerji azalmaz
- energy_refill ürünü satın alınca anında dolar
```

### 15.5 Acorn (Para Birimi) Sistemi
```
Kazanma:
  - Her doğru cevap → +1 acorn
  - Quiz ödül adımları (reward step claim)
  - Başarım kazanma

Harcama:
  - Mağazadan ürün satın alma (spent_store)

Efektler:
  - streak_freeze: Seri koruyucu (belirli süre)
  - unlimited_energy: Sonsuz enerji (belirli süre)
  - xp_boost: XP çarpanı (belirli süre)
  - energy_refill: Anlık enerji doldurma
```

### 15.6 Seri (Streak) Sistemi
```
- Günlük quiz yapılınca streak +1 artar
- Ard arda gün sayısıdır
- Bir gün atlanırsa sıfırlanır (streak_freeze ile korunabilir)
- streak_history: Bu haftanın günlük XP ve quiz verileri
- max_streak: Tüm zamanlar rekoru
```

### 15.7 Liderlik Tablosu Sistemi
```
- Haftalık (Pazartesi başlar)
- League: bronze → silver → gold → diamond
- Her ligde en iyi 30 kullanıcı gösterilir
- Haftalık XP'ye göre sıralanır
```

---

## 16. Hata Kodları

| HTTP Kodu | Anlam |
|-----------|-------|
| 400 | Geçersiz istek / iş kuralı ihlali |
| 401 | Kimlik doğrulama başarısız |
| 403 | Yetki yok (enerji bitti dahil) |
| 404 | Kaynak bulunamadı |
| 409 | Çakışma (email/username kullanımda) |
| 429 | Rate limit aşıldı |
| 500 | Sunucu hatası |
| 503 | Servis kullanılamıyor (DB bağlantısı yok) |

**Hata Response Formatı:**
```json
{ "error": "Hata mesajı buraya gelir" }
```

---

## 17. Güvenlik & Teknik Notlar

- **HTTPS** zorunludur (prodüksiyon)
- **JWT** token 7 gün geçerli — refresh mekanizması yok, süre dolunca yeniden giriş
- **Rate Limiting:** Auth endpointleri dakikada 10 istek
- **Dosya boyutu limiti:** JSON body max 1MB
- **Şifre hashing:** bcrypt, 12 round
- **Tüm ID'ler:** UUID v4 (PostgreSQL `gen_random_uuid()`)
- **Timestamp formatı:** ISO 8601 (UTC)
- **RBAC:** Role tabanlı erişim kontrolü — `permissions` dizisi kullanıcıyla birlikte gelir

---

## 18. Admin Panel API'leri (Yönetim)

Admin endpointleri `view_admin_panel` yetkisi gerektirir. Mobil uygulama için genellikle gerekli değil, ancak referans için:

- `GET/POST/PATCH/DELETE /api/admin/questions` — Soru yönetimi
- `GET/POST/PATCH/DELETE /api/admin/topics` — Konu yönetimi
- `GET/POST/DELETE /api/admin/steps` — Adım yönetimi
- `GET/POST/DELETE /api/admin/tests` — Test yönetimi
- `GET/POST/PATCH/DELETE /api/admin/courses` — Ders yönetimi
- `GET/POST/PATCH/DELETE /api/admin/modules` — Modül yönetimi
- `GET /api/admin/stats` — Dashboard istatistikleri
- `POST /api/admin/questions/:id/approve` — Soru onaylama
- `POST /api/admin/questions/:id/reject` — Soru reddetme
- `GET/POST/PATCH/DELETE /api/admin/users` — Kullanıcı yönetimi

---

## 19. Önerilen Mobile App Geliştirme Sırası

1. **Auth Ekranları** — Giriş, Kayıt, Şifre Sıfırlama
2. **Onboarding** — Sınav türü seçimi
3. **Ana Sayfa** — Kullanıcı profili, enerji, ders listesi
4. **Ders / Konu Detayı** — Adım haritası (`GET /courses/:id/full`)
5. **Quiz Akışı** — Soru tipleri (7 farklı), cevap gönderme, sonuç ekranı
6. **Profil & İstatistikler** — XP, seri, başarımlar
7. **Mağaza** — Ürün listesi, satın alma, efektler
8. **Liderlik Tablosu**
9. **Arkadaşlık**
10. **Bildirimler**
