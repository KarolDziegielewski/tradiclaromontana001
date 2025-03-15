import 'package:flutter/material.dart';
import '../texts/rules_email_text.dart';  // Plik, gdzie zapisaliśmy treść regulaminu

void showRulesEmailDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("UWAGA!"),
        content: SingleChildScrollView(child: Text(rulesEmailText)),
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
