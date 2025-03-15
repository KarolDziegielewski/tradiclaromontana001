import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBPGzueFzJJf0OCPITeeiEWjHaLIM-38JE",
      authDomain: "tradiclaromontana.firebaseapp.com",
      projectId: "tradiclaromontana",
      storageBucket: "tradiclaromontana.firebasestorage.app",
      messagingSenderId: "242551174305",
      appId: "1:242551174305:web:f9c226e77139186498ece0",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrationScreen(role: 'user'),
    );
  }
}

// Reminder: Ensure Flutter is correctly installed and updated.
// Run `flutter doctor` to check for any issues.
// Run `flutter pub get` to fetch dependencies.
