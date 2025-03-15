import 'package:flutter/material.dart';
import 'package:tradiclaromontana/texts/paymenttext.dart';

void showPaymentDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Informacje dotyczące płatności"),
        content: SingleChildScrollView(child: Text(finalInfoText)),
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


