import 'package:flutter/material.dart';
import '../texts/rodo_text.dart';  // Plik, gdzie zapisaliśmy treść klauzuli RODO

void showRODODialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Klauzula Informacyjna RODO"),
        content: SingleChildScrollView(child: Text(rodoText)),
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
