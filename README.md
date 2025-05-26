# Cartan

Cartan is a Flutter app for managing loyalty cards, allowing you to add, organize, and access all your cards in one place.

## 📥 Local Setup

1. **Install Flutter** (follow official guide):

    * [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)

2. **Clone the repository**:

   `git clone https://github.com/cogniwave/cartan.git`
   `cd cartan`

3. **Configure environment variables**:

    * Copy `.env.example` to `.env` and fill in required keys (e.g., `SLACK_WEBHOOK_URL`).

4. **Install dependencies**:

   `flutter pub get`

5. **Generate localization files (i18n)**:

   `flutter gen-l10n`

6. **Run the app locally**:

    * Default:

      `flutter run`
   
    * Dev flavor (debug):

      `flutter run --flavor dev --debug --target=lib/main_dev.dart`

    * Staging flavor (debug):

      `flutter run --flavor staging --debug --target=lib/main_staging.dart`

    * Production flavor (debug):

      `flutter run --flavor production --release --target=lib/main_prod.dart`

---

## 🔨 Building for Dev / Staging / Production

### Android

* **Dev (debug)**:

  `flutter build apk --flavor dev --debug --target=lib/main_dev.dart`

* **Staging (release)**:

  `flutter build appbundle --flavor staging --release --target=lib/main_staging.dart`

* **Production (release)**:

  `flutter build appbundle --flavor production --release --target=lib/main_prod.dart`

Generated artifacts:

* APK: `build/app/outputs/flutter-apk/app-<flavor>-<mode>.apk`
* AAB: `build/app/outputs/bundle/<flavor><Mode>/app-<flavor>-<mode>.aab`

### iOS

* **Dev (debug)**:

  `flutter build ios --flavor dev --debug --target=lib/main_dev.dart`

* **Staging / Production**:

    1. Open `ios/Runner.xcworkspace` in Xcode
    2. Select the `staging` or `production` scheme
    3. Choose your device/simulator and go to **Product → Build**

---

## 🚀 Deployment Process

1. **Generate the artifact** (see Build section) for the desired flavor.

2. **Android**: Upload the `.aab` to Google Play Console:

    * Internal Testing → Create Release → Upload `.aab` → Submit.
    * Production → Create Release → Upload `.aab` → Review & Publish.

3. **iOS**: Submit via App Store Connect:

    * Xcode → Product → Archive → Organizer → Distribute App → App Store Connect.

4. **Release Notes**:

    * Fill in titles, descriptions, and release notes for PT and EN.

5. **Credentials & Keystore**:

    * Android: Keep `key.properties` in `.gitignore` and store keystore securely.
    * iOS: Manage certificates and provisioning profiles in Apple Developer Portal.

---

## ✏️ Adding New Merchants

1. Open `lib/assets/data/merchants.json`.
2. Add a new JSON entry with:

  ` {
     "id": "unique_identifier",
     "displayName": "Merchant Name",
     "formats": ["regex1", "regex2"]
     "assetImagePath": "assets/images/merchants/icon.svg",
     "website": "https://www.website.pt/",
     "category": "Simple"
   }`

3. Save and commit your changes.
4. On next app launch, the repository will automatically load the new merchants.

---

## 🌐 Regenerate Localization (i18n)

Whenever you add new keys in the `.arb` files (under `lib/l10n/`), run:

`flutter gen-l10n`

---

## 🤝 Contributing

Feel free to open issues or pull requests. Thanks for helping improve Cartan!
