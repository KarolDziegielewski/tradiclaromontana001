import 'package:flutter/material.dart';
import 'package:tradiclaromontana/screens/pilgrims_list_screen.dart';
import 'package:tradiclaromontana/widgets/rules_email_dialog.dart';
import '../../services/firebase_service.dart';
import '../../widgets/rules_dialog.dart';
import '../../widgets/rodo_dialog.dart' as rodo;
import '../../widgets/rules_whoregister_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_login_screen.dart';
import '../../widgets/rodo_reg_dialog.dart';
import '../../widgets/rules_reg_dialog.dart';
import '../../widgets/donate_dialog.dart';
import '../../widgets/payment_dialog.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key, required String role});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  User? adminUser;
  final TextEditingController nameofregisterController = TextEditingController();
  final TextEditingController phoneofregisterController = TextEditingController();
  final TextEditingController emailofregisterController = TextEditingController();
  bool showRegisterDatas = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController parentnameController = TextEditingController();

  bool isOver16 = false;
  bool isTrue = false;
  bool attendsFriday = false;
  bool attendsSaturday = false;
  bool acceptsRules = false;
  bool acceptsRODO = false;
  bool acceptsRegRules = false;
  bool acceptsRegRODO = false;

  String? selectedRole = "Osoba swiecka";
  String? whoregister = "Osobiscie"; // 🔹 Użytkownik, który rejestruje pielgrzyma
  bool showPinField = false;
  bool showChildDatas = false;
  bool showdaysDatas = true;
  String? spiritualOrPhysical = "fizycznie";
  String correctPin_kadra = "1234";
  String correctPin_wspolpracownicy_="4321"; // 🔒 PIN dla Kadry Pielgrzymki

void registerPilgrim() async {
  // 🔹 Wyświetlenie ekranu z danymi do płatności
  

  // 🔹 Sprawdzenie, czy wszystkie wymagane pola są wypełnione
  if (nameController.text.isEmpty ||
      cityController.text.isEmpty ||
      postalCodeController.text.isEmpty ||
      (showChildDatas == false && emailController.text.isEmpty) ||
      (showChildDatas == false && phoneController.text.isEmpty) ||
      (!attendsFriday && !attendsSaturday && spiritualOrPhysical == "fizycznie") ||
      !acceptsRules ||
      !acceptsRODO ||
      !isTrue ||
      (whoregister == "Osoba_3." &&
      (acceptsRegRODO == false ||
      acceptsRegRules == false ||
      nameofregisterController.text.isEmpty ||
      phoneofregisterController.text.isEmpty ||
      emailofregisterController.text.isEmpty))) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Wypełnij wszystkie wymagane pola i zaakceptuj zgody!')),
    );
    return;
  }

  showPaymentDialog(context);

  // 🔹 Sprawdzenie, czy pielgrzym jest Kadra Pielgrzymki i czy podał poprawny PIN
  if (selectedRole == "Kadra Pielgrzymki" && pinController.text != correctPin_kadra) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Nieprawidłowy PIN dla Kadry Pielgrzymki!')),
    );
    return;
  }
  else if(selectedRole == "Wspolpracownicy pielgrzymki" && pinController.text != correctPin_wspolpracownicy_){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Nieprawidłowy PIN dla Współpracowników pielgrzymki!')),
    );
    return;
  }
  // 🔹 Sprawdzenie, czy pielgrzym jest zwolniony ze składki
  bool? hasPaidFee;
  if (isOver16 && selectedRole != "Kadra Pielgrzymki" && selectedRole != "Wspolpracownicy pielgrzymki") {
    hasPaidFee = false; // Musi zapłacić
  } else {
    hasPaidFee = null; // Zwolniony
  }

  try {
    await FirebaseService.registerPilgrim(
    nameofregisterController.text,
    phoneofregisterController.text,
    emailofregisterController.text,
    whoregister!, // 🔹 Użytkownik, który rejestruje pielgrzyma
    nameController.text,
    cityController.text,
    postalCodeController.text,
    emailController.text,
    phoneController.text,
    isOver16,
    attendsFriday,
    attendsSaturday,
    acceptsRules,
    acceptsRODO,
    acceptsRegRODO,
    acceptsRegRules,
    selectedRole!, // 🔹 Zapisujemy rolę pielgrzyma
    hasPaidFee,
    parentnameController.text,
    spiritualOrPhysical!,
    );
      } catch (e) {
    print("❌ Error registering pilgrim: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Wystąpił błąd podczas rejestracji!')),
    );
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Rejestracja zakończona sukcesem!')),
  );

  setState(() {
    nameofregisterController.clear();
    phoneofregisterController.clear();
    emailofregisterController.clear();
    whoregister = "Osobiscie";
    nameController.clear();
    cityController.clear();
    postalCodeController.clear();
    emailController.clear();
    phoneController.clear();
    pinController.clear();
    isOver16 = false;
    attendsFriday = false;
    attendsSaturday = false;
    acceptsRules = false;
    acceptsRODO = false;
    acceptsRegRules = false;
    acceptsRegRODO = false;
    selectedRole = "Osoba swiecka";
    showPinField = false;
    showRegisterDatas = false;
    showChildDatas = false;
    isTrue = false;
    parentnameController.clear();
    spiritualOrPhysical = "fizycznie";
  });
}


  void toggleAdminLogin() async {
    if (adminUser == null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminLoginScreen()),
      );

      if (result != null) {
        setState(() {
          adminUser = result;
        });
      }
    } else {
      await FirebaseAuth.instance.signOut();
      setState(() {
        adminUser = null;
      });
    }
  }
  void togglePilgrimsList() async {
    if (adminUser != null) {
      String? role = await FirebaseService.getUserRole(adminUser!.email!);
      if (role != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PilgrimsListScreen(role: role)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(adminUser != null ? 'Lista Pielgrzymów' : 'Rejestracja Pielgrzymów'),
        actions: [
          if (adminUser != null)
            IconButton(
              icon: Icon(Icons.checklist),
              onPressed: togglePilgrimsList,
              tooltip: "Lista Pielgrzymów",
            ),
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: toggleAdminLogin,
            tooltip: "Zaloguj się (dla administracji)",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/images/baner.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => showRulesWhoRegisterDialog(context),
                child: Text("O co chodzi?", style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: whoregister,
              onChanged: (String? newValue) {
                setState(() {
                  whoregister = newValue!;
                  showRegisterDatas = (newValue == "Osoba_3.");
                  showChildDatas = (newValue == "Rodzic");
                });
              },
              decoration: InputDecoration(
                labelText: "Kto rejestruje?",
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: "Osobiscie", child: Text("Zapisuję siebie")),
                DropdownMenuItem(value: "Rodzic", child: Text("Rodzic - zapisuję dziecko (Jestem już zapisanym uczestnikiem)")),
                DropdownMenuItem(value: "Osoba_3.", child: Text("Zapisuję kogoś jako osoba trzecia")),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Imię i nazwisko pielgrzyma',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: 'Miejscowość zamieszkania pielgrzyma',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: postalCodeController,
              decoration: InputDecoration(
                labelText: 'Kod pocztowy pielgrzyma',
                border: OutlineInputBorder(),
              ),
            ),
            if (showChildDatas) ...[
              SizedBox(height: 10),
              TextField(
                controller: parentnameController,
                decoration: InputDecoration(
                  labelText: 'Imię i nazwisko rodzica',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            if (!showChildDatas) ...[
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail pielgrzyma',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Telefon pielgrzyma',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedRole,
              onChanged: (String? newValue) {
                setState(() {
                  selectedRole = newValue!;
                  showPinField = (newValue == "Kadra Pielgrzymki" || newValue == "Wspolpracownicy pielgrzymki");
                });
              },
              decoration: InputDecoration(
                labelText: "Rola pielgrzyma",
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: "Osoba swiecka", child: Text("Osoba swiecka")),
                DropdownMenuItem(value: "Ksiadz", child: Text("Ksiadz")),
                DropdownMenuItem(value: "Siostra zakonna", child: Text("Siostra zakonna")),
                DropdownMenuItem(value: "Kleryk", child: Text("Kleryk")),
                DropdownMenuItem(value: "Chor", child: Text("Chor")),
                DropdownMenuItem(value: "Organista", child: Text("Organista")),
                DropdownMenuItem(value: "Ministrant", child: Text("Ministrant")),
                DropdownMenuItem(value: "Kadra Pielgrzymki", child: Text("Kadra Pielgrzymki")),
                DropdownMenuItem(value: "Wspolpracownicy pielgrzymki", child: Text("Współpracownicy pielgrzymki")),
              ],
            ),
            if (showPinField) ...[
              SizedBox(height: 10),
              TextField(
                controller: pinController,
                decoration: InputDecoration(
                  labelText: "Podaj hasło",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
            if (showRegisterDatas) ...[
              SizedBox(height: 20),
              TextField(
                controller: nameofregisterController,
                decoration: InputDecoration(
                  labelText: 'Imię i nazwisko osoby zapisującej',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneofregisterController,
                decoration: InputDecoration(
                  labelText: 'Nr telefonu osoby zapisującej',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => showRulesEmailDialog(context),
                child: Text("Uwaga dotycząca niepodania adresu poczty elektronicznej"),
              ),
              TextField(
                controller: emailofregisterController,
                decoration: InputDecoration(
                  labelText: 'Email osoby zapisującej',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              CheckboxListTile(
                title: Row(
                  children: [
                    Text("Akceptuję regulamin dla osoby zapisującej"),
                    TextButton(
                      onPressed: () => showRulesRegDialog(context),
                      child: Text("Czytaj"),
                    ),
                  ],
                ),
                value: acceptsRegRules,
                onChanged: (value) => setState(() => acceptsRegRules = value!),
              ),
              CheckboxListTile(
                title: Row(
                  children: [
                    Text("Akceptuję zasady RODO dot. osoby zapisującej"),
                    TextButton(
                      onPressed: () => showRODORegDialog(context),
                      child: Text("Czytaj"),
                    ),
                  ],
                ),
                value: acceptsRegRODO,
                onChanged: (value) => setState(() => acceptsRegRODO = value!),
              ),
            ],
            SizedBox(height: 20),
            CheckboxListTile(
              title: Text(whoregister == "Osobiscie" ? "Czy w dniu pielgrzymki będziesz miał(a) ukończone 16 lat?" : "Czy pielgrzym w dniu pielgrzymki będzie miał ukończone 16 lat?"),
              value: isOver16,
              onChanged: (value) => setState(() => isOver16 = value!),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: spiritualOrPhysical,
              onChanged: (String? newValue) {
                setState(() {
                  spiritualOrPhysical = newValue!;
                  showdaysDatas = (newValue == "fizycznie");
                });
              },
              decoration: InputDecoration(
                labelText: "Forma uczestnictwa",
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: "fizycznie", child: Text("Będę fizycznie na pielgrzymce")),
                DropdownMenuItem(value: "duchowo", child: Text("Biorę duchowy udział w pielgrzymce")),
              ],
            ),
            if (showdaysDatas) ...[
              SizedBox(height: 10),
              CheckboxListTile(
                title: Text("Piątek"),
                value: attendsFriday,
                onChanged: (value) => setState(() => attendsFriday = value!),
              ),
              CheckboxListTile(
                title: Text("Sobota"),
                value: attendsSaturday,
                onChanged: (value) => setState(() => attendsSaturday = value!),
              ),
            ],
            Divider(),
            CheckboxListTile(
              title: Row(
                children: [
                  Text("Akceptuję regulamin"),
                  TextButton(
                    onPressed: () => showRulesDialog(context),
                    child: Text("Czytaj"),
                  ),
                ],
              ),
              value: acceptsRules,
              onChanged: (value) => setState(() => acceptsRules = value!),
            ),
            CheckboxListTile(
              title: Row(
                children: [
                  Text("Akceptuję zasady RODO"),
                  TextButton(
                    onPressed: () => rodo.showRODODialog(context),
                    child: Text("Czytaj"),
                  ),
                ],
              ),
              value: acceptsRODO,
              onChanged: (value) => setState(() => acceptsRODO = value!),
            ),
            CheckboxListTile(
              title: Text("Oświadczam, że podane wyżej informacje są zgodne z prawdą"),
              value: isTrue,
              onChanged: (value) => setState(() => isTrue = value!),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => showDonateDialog(context),
                child: Text("Prośba o wsparcie pielgrzymki", style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: registerPilgrim,
                child: Text('Zarejestruj'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}