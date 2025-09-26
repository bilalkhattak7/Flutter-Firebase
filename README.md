📱 Flutter Firebase Authentication + Firestore + Realtime Database
📌 Overview

This Flutter project demonstrates how to integrate Firebase Authentication, Cloud Firestore, and Realtime Database in one simple app.

The app allows users to:

Sign up and sign in with Firebase Authentication (email + password).

Stay signed in (auto login) after restarting the app using a Splash Screen.

Store text data into Cloud Firestore and Realtime Database.

Show stored messages in real time directly on the home screen.

This project is designed as a beginner-friendly guide to understand Firebase integration in Flutter.

🚀 Features
🔑 Authentication

Sign Up: Create a new account using email & password.

Sign In: Log into the app with credentials.

Auto Login: If a user is already signed in, they are taken directly to the home screen from the splash screen.

Error Handling: Clear messages for invalid credentials, weak password, or network issues.

🌟 Splash Screen

Loads first when the app starts.

Checks if the user is already logged in.

Navigates automatically to:

Home Page → if logged in.

Login Page → if not logged in.

🔥 Firestore Integration

Save messages into Cloud Firestore under the messages collection.

Each message has:

{
  "text": "Message content",
  "createdAt": "Timestamp"
}


Display saved messages in real time below the input field.

⚡ Realtime Database Integration

Save messages under the messages node in Realtime Database.

Example structure:

{
  "messages": {
    "msg1": {
      "text": "Hello World",
      "createdAt": "2025-09-26T12:00:00Z"
    }
  }
}


Show saved messages instantly below the save button.

📂 Project Structure
lib/
 ├── main.dart                   # Entry point
 ├── Screens/
 │    ├── splash_screen.dart     # Splash + auto login check
 │    ├── login.dart             # Sign In page
 │    ├── sign_up.dart           # Sign Up page
 │    ├── firestore_datasave_datashow.dart # Save + show Firestore data
 │    ├── realtime_dbstored_show.dart      # Save + show Realtime DB data

🛠️ Dependencies

Add these to pubspec.yaml:

dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.30.1
  firebase_auth: ^4.17.5
  cloud_firestore: ^4.17.5
  firebase_database: ^10.5.7

⚙️ How It Works

App Start → SplashScreen loads → checks if user is logged in.

Authentication → login or signup using email & password.

Home Screen → enter text and save to Firebase.

Firestore: stores in messages collection.

Realtime Database: stores in messages node.

Data Display → messages show instantly below the input field.

✅ Conclusion

This project is a complete Firebase starter kit for Flutter:

Authentication

Auto Login with Splash Screen

Realtime Database

Cloud Firestore

It’s a perfect learning project for beginners who want to store and fetch real-time data in Flutter apps using Firebase.
