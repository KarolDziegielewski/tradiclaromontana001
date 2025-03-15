import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter


class PilgrimsListScreen extends StatefulWidget {
  final String role; // Role of the user (admin or authenticator)

  PilgrimsListScreen({required this.role});

  @override
  _PilgrimsListScreenState createState() => _PilgrimsListScreenState();
}

class _PilgrimsListScreenState extends State<PilgrimsListScreen> {
  String searchQuery = '';

  String date_now(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd–kk:mm').format(now);
    return formattedDate;
  }

Future<void> downloadFile(String content, String fileName) async {
  try {
    // Pobranie katalogu "Pobrane" dla Windows
    final directory = await getDownloadsDirectory();
    
    if (directory == null) {
      print("Błąd: Nie można uzyskać katalogu pobierania.");
      return;
    }

    // Tworzenie pliku w katalogu Pobrane
    final filePath = '${directory.path}\\$fileName'; // Użycie `\\` dla Windows
    final file = File(filePath);
    
    await file.writeAsString(content, encoding: utf8);
    
    print("Plik został zapisany w: $filePath");
  } catch (e) {
    print("Błąd zapisu pliku: $e");
  }
}

  void generateTxtFile_mails() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('pilgrims')
        .orderBy('id', descending: true)
        .get();

    if (snapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No pilgrims found!')),
      );
      return;
    }

    // Formatting data for the text file
    StringBuffer txtContent = StringBuffer();

    for (var doc in snapshot.docs) {
      txtContent.writeln('Email: ${doc['email']}');
    }
    String temp = "maile_pielgrzymow_${date_now()}.txt";
    downloadFile(txtContent.toString(), temp);
  }

  void generateTxtFile_ministers_mails() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('pilgrims')
        .orderBy('id', descending: true)
        .get();

    if (snapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No pilgrims found!')),
      );
      return;
    }

    // Formatting data for the text file
    StringBuffer txtContent = StringBuffer();

    for (var doc in snapshot.docs) {
      if (doc['rola'] == "ministrant") {
        txtContent.writeln('Email: ${doc['email']}');
      } else {
        continue;
      }
    }
    String temp = "maile_ministrantow_${date_now()}.txt";
    downloadFile(txtContent.toString(), temp);
  }

  void generateTxtFile() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('pilgrims')
        .orderBy('id', descending: true)
        .get();

    if (snapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No pilgrims found!')),
      );
      return;
    }
    String temp = "pielgrzymi_${date_now()}.txt";
    // Formatting data for the text file
    StringBuffer txtContent = StringBuffer();
    txtContent.writeln('Lista Pielgrzymów\n--------------------------');

    for (var doc in snapshot.docs) {
      txtContent.writeln('ID: ${doc['id']}');
      txtContent.writeln('Imię i nazwisko:: ${doc['imie_i_nazwisko']}');
      txtContent.writeln('Miasto: ${doc['miasto']}');
      txtContent.writeln('Kody pocztowe: ${doc['kod_pocztowy']}');
      txtContent.writeln('Email: ${doc['email']}');
      txtContent.writeln('Tel.: ${doc['telefon']}');
      txtContent.writeln('Piątek: ${doc['piatek'] ? "Yes" : "No"}');
      txtContent.writeln('Sobota: ${doc['sobota'] ? "Yes" : "No"}');
      txtContent.writeln('--------------------------------');
    }
    downloadFile(txtContent.toString(), temp);
  }

  void generateTxtFile_postal_codes() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('pilgrims')
        .orderBy('id', descending: true)
        .get();

    if (snapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No pilgrims found!')),
      );
      return;
    }
    String temp = "kody_pocztowe_pielgrzymow_${date_now()}.txt";
    // Formatting data for the text file
    StringBuffer txtContent = StringBuffer();

    for (var doc in snapshot.docs) {
      txtContent.writeln('${doc['kod_pocztowy']}');
    }
    downloadFile(txtContent.toString(), temp);
  }

  void togglePaymentStatus(String pilgrimId, bool newStatus) {
    if (widget.role == "admin") {
      FirebaseFirestore.instance.collection('pilgrims').doc(pilgrimId).update({
        'Zaplacil(null-zwolniony,false-nie_zaplacil,true-zaplacil)': newStatus,
      });
    }
  }

  void deletePilgrim(String pilgrimId) {
    if (widget.role == "admin") {
      FirebaseFirestore.instance.collection('pilgrims').doc(pilgrimId).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Pielgrzymów'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: generateTxtFile, // 📌 Generate and download file
            tooltip: 'Pielgrzymi',
          ),
          IconButton(
            icon: Icon(Icons.email),
            onPressed: generateTxtFile_mails, // 📌 Generate and download file
            tooltip: 'Maile pielgrzymów',
          ),
          IconButton(
            icon: Icon(Icons.church_rounded),
            onPressed: generateTxtFile_ministers_mails, // 📌 Generate and download file
            tooltip: 'Maile ministrantów',
          ),
          IconButton(
            icon: Icon(Icons.signpost),
            onPressed: generateTxtFile_postal_codes, // 📌 Generate and download file
            tooltip: 'Kody pocztowe pielgrzymow',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Szukaj po nazwisku...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('pilgrims')
            .orderBy('id', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Brak zarejestrowanych pielgrzymów.'));
          }

          final filteredPilgrims = snapshot.data!.docs.where((doc) {
            String name = doc['imie_i_nazwisko'].toString().toLowerCase();
            return name.contains(searchQuery);
          }).toList();

          return ListView(
            children: filteredPilgrims.map((document) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text(document['id'].toString()),
                ),
                title: Text(document['imie_i_nazwisko']),
                subtitle: Text(document['miasto']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (document['Zaplacil(null-zwolniony,false-nie_zaplacil,true-zaplacil)'] == null)
                      Text("Zwolniony", style: TextStyle(color: Colors.green)) // ✅ Tylko gdy faktycznie zwolniony
                    else
                      widget.role == "admin"
                          ? Row(
                              children: [
                                Text(document['Zaplacil(null-zwolniony,false-nie_zaplacil,true-zaplacil)'] == true ? "Zapłacone" : "Nie zapłacone"),
                                Switch(
                                  value: document['Zaplacil(null-zwolniony,false-nie_zaplacil,true-zaplacil)'] ?? false,
                                  onChanged: (value) {
                                    if (widget.role == "admin") {
                                      FirebaseFirestore.instance.collection('pilgrims').doc(document.id).update({
                                        'Zaplacil(null-zwolniony,false-nie_zaplacil,true-zaplacil)': value,
                                      });
                                    }
                                  },
                                ),
                              ],
                            )
                          : Text(document['Zaplacil(null-zwolniony,false-nie_zaplacil,true-zaplacil)'] == true ? "Zapłacone" : "Nie zapłacone"),
                    if (widget.role == "admin")
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deletePilgrim(document.id),
                      ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
