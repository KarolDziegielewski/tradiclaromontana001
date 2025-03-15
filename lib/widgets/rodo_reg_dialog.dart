import 'package:flutter/material.dart';
import '../texts/rodo_reg_text.dart';  // Plik, gdzie zapisaliśmy treść klauzuli RODO

void showRODORegDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Klauzula Informacyjna RODO"),
        content: SingleChildScrollView(child: Text(RODORegText)),
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
