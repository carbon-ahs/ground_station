i want to add a fix habit, drink 8 glass of water per day. i may change this 8 in future. i want to change it from settings but deflut is 8. add this ui to dashbourd and make it work.


--- 
json data export import not working. also hydration card and sleep card not is not consistant in colors. They are not matching with theme. also sleep card btn color not working in dark mode. also i need daily_focas history ui. There is no edit option on daily focus . 

---
stake logic is not woring. fix it.

---

# Play Store Deployment Checklist

## 1. Prerequisites
- [ ] **Google Play Console Account**: Ensure you have a developer account ($25 one-time fee).
- [ ] **App Content**: Have your Privacy Policy URL, App Icon (512x512), Feature Graphic (1024x500), and Screenshots ready.

## 2. App Configuration
- [ ] **Package Name**: Verify `applicationId` in `android/app/build.gradle` is unique (e.g., `com.yourcompany.appname`).
- [ ] **App Label**: Check `android:label` in `android/app/src/main/AndroidManifest.xml`.
- [x] **App Icon**: Ensure launcher icons are generated (use `flutter_launcher_icons` package if needed).
- [ ] **Permissions**: Review `AndroidManifest.xml` and remove unused permissions.

## 3. Signing the App
- [ ] **Create Keystore**: Run `keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`.
- [ ] **Secure Keystore**: Move `upload-keystore.jks` to `android/app/` (add to `.gitignore`!).
- [ ] **Configure Gradle**:
    - Create `android/key.properties` with password/alias info.
    - Update `android/app/build.gradle` to use the signing config for release builds.

## 4. Build Release Bundle
- [ ] **Clean Build**: Run `flutter clean`.
- [ ] **Get Dependencies**: Run `flutter pub get`.
- [ ] **Build App Bundle**: Run `flutter build appbundle --release`.
    - Output: `build/app/outputs/bundle/release/app-release.aab`.

## 5. Play Console Setup
- [ ] **Create App**: Click "Create app" in Play Console.
- [ ] **Store Listing**: Fill in Title, Short description, Full description, Graphics.
- [ ] **App Content**: Complete declarations (Privacy Policy, Ads, App Access, Content Ratings, Target Audience, News Apps, COVID-19, Data Safety).

## 6. Release & Testing
- [ ] **Internal Testing** (Optional but recommended):
    - Upload `.aab` to Internal Testing track.
    - Add testers (email lists).
- [ ] **Closed/Open Testing**: Promote to these tracks for broader feedback.
- [ ] **Production Release**:
    - Promote release to Production.
    - Review and roll out.

## 7. Post-Release
- [ ] **Monitor**: Check "Vitals" and "Crashlytics" (if integrated).
- [ ] **Updates**: Increment `versionCode` in `pubspec.yaml` for every new upload (e.g., `1.0.1+2`).