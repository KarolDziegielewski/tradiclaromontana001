import 'package:flutter/material.dart';
import 'package:tradiclaromontana/texts/donateText1.dart';
import '../texts/donateText2.dart';
import '../texts/donateText3.dart';

void showDonateDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Prośba o wsparcie"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(donatetext1),
              Image.asset(
                'assets/images/donate1.png', // Poprawiona ścieżka
                //width: double.infinity,
                fit: BoxFit.cover,
              ),
              Text(donatetext2),
              Image.asset(
                'assets/images/donate2.png',
                fit: BoxFit.cover, // Poprawiona ścieżka
              ),
              Text(donatetext3),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Zamknij"),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      );
    },
  );
}
