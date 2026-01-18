# Facebook Clone Flutter App

> This is a Facebook-like social app built with Flutter and Firebase, featuring:
>
> - Splash screen, login, signup, and home navigation
> - Email/password and Google sign-in (with Firebase Auth)
> - Feed, stories, notifications, and friends UI

---

## 🚀 Getting Started

### 1. Clone the Repository

```
git clone <your-repo-url>
cd facebook
```

### 2. Install Flutter & Dart

Ensure you have [Flutter](https://docs.flutter.dev/get-started/install) installed (Flutter 3.8+ recommended).

### 3. Install Dependencies

```
flutter pub get
```

### 4. Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
2. Add Android/iOS/Web apps as needed.
3. Download `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) and place them in the correct folders.
4. Enable **Email/Password** and **Google** sign-in in Firebase Authentication.
5. Download and replace `lib/firebase_options.dart` using the [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/).

### 5. Run the App

```
flutter run
```

---

## 📝 Features

- Splash screen → Login page → Home page navigation
- Only authenticated users can access the home page
- Email/password login and signup
- Google sign-in (shows account picker, only allows existing Firebase users)
- Feed, stories, notifications, and friends UI
- Error handling and user feedback

---

## 🔑 Usage Flow

1. **Splash Screen**: Shows on app start
2. **Login**: Enter email/password or use Google sign-in
   - If Google account is not registered, user is prompted to sign up
3. **Signup**: Create a new account with email/password
4. **Home**: See feed, stories, notifications, and friends
5. **Logout**: Signs out from both Firebase and Google

---

## ⚙️ Project Structure

- `lib/main.dart` - App entry, navigation, and Firebase init
- `lib/login_page.dart` - Login UI and logic
- `lib/signup.dart` - Signup UI and logic
- `lib/main_tabs.dart` - Main tab navigation (Home, Friends, Notifications, etc.)
- `lib/google_sign_in_helper.dart` - Google sign-in logic
- `lib/firebase_options.dart` - Firebase config (auto-generated)
- `lib/home_page.dart`, `lib/friends.dart`, `lib/notifications.dart`, etc. - UI pages

---

## 🛠️ Troubleshooting

- If Google sign-in fails, ensure the account exists in Firebase Auth and the correct SHA-1/SHA-256 keys are set in Firebase Console.
- If you change Firebase project, regenerate `firebase_options.dart`.
- For any dependency issues, run `flutter clean` then `flutter pub get`.

---


