import 'package:flutter/material.dart';
import '../texts/rules_text.dart';  // Plik, gdzie zapisaliśmy treść regulaminu

void showRulesDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Regulamin Pielgrzymki"),
        content: SingleChildScrollView(child: Text(rulesText)),
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
