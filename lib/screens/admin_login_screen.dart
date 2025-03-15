import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/pilgrims_list_screen.dart'; // Import the PilgrimsListScreen

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nieprawidłowy email lub hasło!')),
        );
        return;
      } else {
        String? role = await _getUserRole(user.email!);
        if (role == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nie masz uprawnień do zalogowania!')),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PilgrimsListScreen(role: role)),
          );
        }
      }
    } catch (error) {
      setState(() {
        errorMessage = "Błąd logowania: ${error.toString()}";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String?> _getUserRole(String email) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return query.docs.first['role']; // Returns "admin" or "authenticator"
      } else {
        return null;
      }
    } catch (error) {
      print("❌ Error getting user role: $error");
      return null;
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Logowanie Admin/Authenticator'),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
    ),
    body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Zaloguj się',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Hasło',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 20),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                errorMessage!,
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(height: 10),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: Text(
                    'Zaloguj się',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
        ],
      ),
    ),
  );
}
}