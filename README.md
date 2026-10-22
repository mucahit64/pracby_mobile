# Pracby Mobile

Pracby'ın Flutter uygulaması (Android ve iOS). API ve web: [pracby](https://github.com/mucahit64/pracby).
API sözleşmesi ve ekran davranışları: [MOBILE_APP_DOCS.md](MOBILE_APP_DOCS.md).

## Geliştirme

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed / json_serializable
flutter run
```

Debug build yerel sunuculara bağlanır: API `:3001`, web (soru görselleri, yasal sayfalar) `:3000`.
Android emülatörde `10.0.2.2`, iOS simülatörde `127.0.0.1` / `[::1]`. Başka bir adres için:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:3100 --dart-define=WEB_BASE_URL=http://192.168.1.10:3200
```

```bash
flutter analyze
flutter test
```

## Yayın

Release build, `--dart-define` verilmezse `https://pracby.com`'a bağlanır.

- Uygulama kimliği: `com.pracby.mobile` (Android `applicationId` ve iOS bundle id). Mağazaya çıktıktan sonra değiştirilemez.
- Sürüm: `pubspec.yaml` içindeki `version: 1.0.0+1`. Her yüklemede `+` sonrasındaki build numarası artmalı.

### Android

Bir kez, yükleme anahtarı oluştur ve **güvenli bir yerde yedekle** (kaybolursa güncelleme yüklenemez):

```bash
keytool -genkey -v -keystore ~/pracby-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

`android/key.properties` (git'e girmez):

```properties
storeFile=/home/<kullanıcı>/pracby-upload.jks
storePassword=...
keyAlias=upload
keyPassword=...
```

```bash
flutter build appbundle --release   # build/app/outputs/bundle/release/app-release.aab
```

`key.properties` yoksa release build debug anahtarıyla imzalanır; Google Play bunu kabul etmez.

### iOS

Xcode'da `ios/Runner.xcworkspace` → Signing & Capabilities (team `WD6SX5QJ86`), sonra:

```bash
flutter build ipa --release
```

`ios/Runner/PrivacyInfo.xcprivacy`, App Store Connect'teki "App Privacy" cevaplarıyla aynı olmalı.

### Mağaza bilgileri

- Gizlilik politikası: https://pracby.com/gizlilik
- Hesap silme (Google Play "Data deletion" URL'si): https://pracby.com/hesap-silme
- Uygulama içi hesap silme: Profil → Profili Düzenle → Hesabımı sil
