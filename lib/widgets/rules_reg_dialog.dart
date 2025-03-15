import 'package:flutter/material.dart';
import '../texts/rules_reg_text.dart';  // Plik, gdzie zapisaliśmy treść regulaminu

void showRulesRegDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Regulamin Pielgrzymki"),
        content: SingleChildScrollView(child: Text(rulesRegText)),
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
