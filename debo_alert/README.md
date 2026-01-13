# Debo Alert

A Flutter mobile application for real-time alerts and location-based services, using Firebase as the backend.

## Features

- **User Authentication:** Email/password sign-in using Firebase Authentication.
- **Location Services:** Uses Geolocator to get the user's current location.
- **Cloud Firestore:** Stores and retrieves alert data in real time.
- **Google Maps Integration:** Displays user and alert locations on a map.
- **Push Notifications:** (If implemented) Sends notifications for new alerts.

## Backend

This app uses **Firebase** as its backend, providing:

- **Authentication:** Secure user login and registration.
- **Firestore Database:** Stores alerts, user profiles, and other app data.
- **Firebase Storage:** (If used) For storing images or files.
- **(Optional) Cloud Functions:** For advanced backend logic or notifications.

You do **not** need to run a separate backend server. All backend services are managed by Firebase.

## How It Works

1. **User signs up or logs in** using email and password.
2. **User can send or receive alerts** (e.g., emergency, location-based notifications).
3. **Location is fetched** and shown on Google Maps.
4. **Alerts are stored and synced** in real time using Firestore.
5. **(Optional) Notifications** are sent to users when new alerts are created.

## Getting Started

1. **Clone the repository:**

   ```sh
   git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
   cd debo_alert
   ```

2. **Install dependencies:**

   ```sh
   flutter pub get
   ```

3. **Firebase configuration:**

   - Download `google-services.json` from your Firebase Console.
   - Place it in `android/app/google-services.json`.

4. **Run the app:**
   ```sh
   flutter run
   ```

## Notes

- Do **not** commit your `google-services.json` file to public repositories.
- Update your `.gitignore` to exclude sensitive files.

## License

[MIT](LICENSE)
