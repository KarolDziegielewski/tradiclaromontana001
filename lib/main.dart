import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/registration_screen.dart';
import 'texts/keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: apiKey_mine,
      authDomain: authDomain_mine,
      projectId: projectId_mine,
      storageBucket: storageBucket_mine,
      messagingSenderId: messagingSenderId_mine,
      appId: appId_mine,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
