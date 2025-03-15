import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> registerPilgrim(
  String nameofregister, 
  String phoneofregister, 
  String emailofregister, 
  String whoregister,
  String name, 
  String city, 
  String postalCode, 
  String email, 
  String phone,
  bool isOver16, 
  bool attendsFriday, 
  bool attendsSaturday, 
  bool acceptsRules, 
  bool acceptsRODO, 
  bool acceptsRODOReg, 
  bool acceptsRulesReg,
  String selectedRole, 
  bool? hasPaidFee,
  String parentname,
  String spiritualOrPhysical,
) async {
  try {
    final CollectionReference pilgrimsCollection = _firestore.collection('pilgrims');
    final CollectionReference registerCollection = _firestore.collection('register');
    int newId = await _getNextId();
    if (nameofregister != "") {
      await registerCollection.add({
        'whorehister': whoregister,
        'phoneofregister': phoneofregister,
        'emailofregister': emailofregister,
        'nameofregister': nameofregister,
        'id': newId,
        'acceptsRODOReg': acceptsRODOReg,
        'acceptsRulesReg': acceptsRulesReg,
        
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
    await pilgrimsCollection.add({
      'kto_zapisal': whoregister, 
      'id': newId,
      'imie_i_nazwisko': name,
      'miasto': city,
      'kod_pocztowy': postalCode,
      'email': email,
      'telefon': phone,
      'ukonczyl_16': isOver16,

      'akceptuje_regulamin': acceptsRules,
      'akceptuje_RODO': acceptsRODO,
      'sposob_uczestnictwa': spiritualOrPhysical,
      'rola': selectedRole, // 🔹 Zapisujemy rolę pielgrzyma
      'Zaplacil(null-zwolniony,false-nie_zaplacil,true-zaplacil)': hasPaidFee,
      if (whoregister == 'Rodzic') 'imie_rodzica': parentname,
      
      if (spiritualOrPhysical == 'fizycznie') 'piatek': attendsFriday,
      if (spiritualOrPhysical == 'fizycznie') 'sobota': attendsSaturday,
      'timestamp': FieldValue.serverTimestamp(),
    });

    print("✅ Pilgrim registered successfully!");

  } catch (error) {
    print("❌ Error registering pilgrim: $error");
  }
}



  // Generate the next available ID for a pilgrim
  static Future<int> _getNextId() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('pilgrims')
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        int lastId = snapshot.docs.first['id'] as int;
        return lastId + 1;
      } else {
        return 1;
      }
    } catch (error) {
      print("❌ Error getting next ID: $error");
      return 1;
    }
  }

  // Fetch role of the logged-in user by matching email
  static Future<String?> getUserRole(String email) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email.trim()) // Ensure no spaces
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        String role = query.docs.first['role'];
        print("✅ Retrieved role: $role for $email");
        return role; // Should return "admin" or "authenticator"
      } else {
        print("⚠️ No role found for $email");
        return null;
      }
    } catch (error) {
      print("❌ Error getting user role: $error");
      return null;
    }
  }
}

