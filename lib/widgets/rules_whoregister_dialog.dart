import 'package:flutter/material.dart';
import '../texts/WhoRegister_text.dart';  // Plik, gdzie zapisaliśmy treść klauzuli RODO

void showRulesWhoRegisterDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Kto zapisuje?"),
        content: SingleChildScrollView(child: Text(whoregisterText)),
        actions: [
          TextButton(
            child: Text("Zamknij"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
