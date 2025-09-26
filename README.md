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
