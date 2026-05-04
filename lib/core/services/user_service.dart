// Importations des bibliothèques nécessaire
import 'package:cloud_firestore/cloud_firestore.dart'; // Pour accéder à la base de données
import 'package:firebase_auth/firebase_auth.dart'; // Pour accéder à Firebase Auth

class UserService {
  // Classe centralisant tous les accès à Firestore pour les données utilisateurs
  static final _db = FirebaseFirestore.instance; // Instance pour accéder à la base de données
  static final _auth = FirebaseAuth.instance; // Instance de Firebase Auth pour accéder à l'identification d'un utilisateur

  static String? get _userId => _auth.currentUser?.uid; // Getter permettant de retourner l'identifiant unique de l'utilisateur connecté

  // ------ PROFIL UTILISATEUR ------
  static Future<Map<String, dynamic>?> getUserProfile() async {
    // Récupère toutes les données du profil de l'utilisateur depuis Firestore
    if (_userId == null) return null; // si pas d'utilisateur connecté on retourne null
    final doc = await _db.collection('users').doc(_userId).get(); // Accède au document de l'utilisateur
    if (!doc.exists) return null; // Si pas de document on retourne null
    return doc.data(); // on retourne les données du document sous forme de Map
  }

  static Future<String?> updateRole(String newRole) async {
    // Mets à jour le rôle principal de l'utilisateur dans Firestore
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      // Si l'utilisateur n'est pas connecté
      if (userId == null) return 'Non connecté';
      // Si l'utilisateur est bien connecté, on met à jour son rôle dans Firestore sans écraser les autres données
      await _db.collection('users').doc(userId).update({'role': newRole});
      return null; // renvoie null en cas de succès
    } catch (e) {
      // En cas d'erreur, il renvoie le code de l'erreur
      return 'Erreur : $e';
    }
  }

  // ------ PRÉFÉRENCES ------
  static Future<void> savePreferences({bool? darkMode, String? locale, bool? notifications}) async {
    // Sauvegarde les préférences de l'utilisateur dans Firestore
    final userId = FirebaseAuth.instance.currentUser?.uid;
    //print('userId: $userId');  // vérifie que l'utilisateur est connecté

    if (userId == null) return; // cas de l'utilisateur non conncecté (sécurité)

    // Construction dynamique de la Map à sauvegarder
    final data = <String, dynamic>{};
    // Préférence du thème ajoutée à une liste de variables
    if (darkMode != null) data['darkMode'] = darkMode;
    // Préférence de langue ajoutée à une liste de variables
    if (locale != null) data['locale'] = locale;
    // Préférence pour les notifications ajoutée à une liste de variables
    if (notifications != null) data['notifications']=notifications;
    //print('data à sauvegarder: $data');  // vérification des données

    try {
      // On sauvegarde les données de préférences (thème, langue, notifications) dans la base de données
      await _db.collection('users').doc(userId).set(
        data,
        SetOptions(merge: true), // merge: true permet de fusionner les données existantes sans cela set() écraserait tout le document
      );
      //print('sauvegarde réussie !');
    } catch (e) {
      // Affichage des erreurs dans le terminal (silencieuse)
      //print('erreur sauvegarde: $e');
    }
  }

  static Future<Map<String, dynamic>?> loadPreferences() async {
    // Chargement des préférences de l'utilisateur depuis Firestore
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return null; // si l'utilisateur n'est pas connecté on retourne null
    // Récupération des préférences depuis la base de données
    final doc = await _db.collection('users').doc(userId).get();
    // On renvoie les préférences de l'utilisateur connecté
    return doc.data();
  }

  // ------ ALERTES ------
  static Future<void> saveAlerte({
    required String nom, // Titre de l'alerte (température, humidité, CO2)
    required String message // Message de l'alerte
  }) 
  async {
    // Permet de sauvegarder une nouvelle alerte dans Firestore
    // Structure : users/{userId}/alertes/{alerteId}
    final userId = _auth.currentUser?.uid; // Vérification de l'utilisateur
    if(userId == null) return; // Si pas d'utilisateur connecté, pas de sauvegarde (sécurité)
    
    // Ajout dans la base de données sur Firebase
    await _db
      .collection('users')
      .doc(userId)
      .collection('alertes') // Sous-collection dédiée aux alertes
      .add({ // génère automatiquement un ID unique pour le document
        'nom':nom,
        'message':message,
        'date': Timestamp.now(), // Date et heure exacte de l'alerte
        'userId': userId, // Redondant mais utile pour les requêtes globales
      });
  }

  static Future<List<Map<String, dynamic>>> getAlertes() async{
    // Permet de récupérer les alertes de l'utilisateur triées par date (de la plus récente à la plus vieille)
    final userId = _auth.currentUser?.uid; // Vérification de l'utilisateur
    if (userId == null) return []; // Si pas d'utilisateur connecté, on retourne une liste vide (sécurité)

    // Récupération des données des alertes
    final recup=await _db
      .collection('users')
      .doc(userId)
      .collection('alertes')
      .orderBy('date', descending: true) // ordonné de la plus récente à la plus ancienne
      .get();
    
    // Transforme chaque document Firestore en Map Dart
    return recup.docs.map((doc) => doc.data()).toList();
  }

  // ------ MESURES ------
  static Future<void> saveMesure({
    required double temperature,
    required double humidity,
    required int co2,
    required double bai,
  }) async {
    // Sauvegarde une mesure des capteurs dans la sous-collection 'mesures' de l'utilisateur
    // Structure : users/{userId}/mesures/{mesureId}
    // Appelée à chaque nouvelle donnée valide reçue depuis Firebase Realtime Database
    final userId = _auth.currentUser?.uid; // Vérification de l'utilisateur
    if (userId == null) return; // Pas d'utilisateur connecté, sécurité (on ne retourne rien)
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('mesures') // Sous-collection dédiée aux mesures
          .add({ // Ajout des mesures
            'temperature': temperature,
            'humidity': humidity,
            'co2': co2,
            'bai':bai,
            'date': Timestamp.now(), // Timestamp Firestore de la sauvegarde
          });
    } catch (e) {
      // Erreur silencieuse (print commenté en développement)
      //print('[saveMesure] Erreur : $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getMesures(int periodIndex) async {
    // Récupère les mesures de l'utilisateur sur une période donnée
    // periodIndex=0 => dernière heure
    // periodIndex=1 => 7 derniers jours
    // periodIndex=2 => 30 derniers jours
    final userId = _auth.currentUser?.uid; // Vérification de l'utilisateur
    if (userId == null) return []; // Si pas d'utilisateur connecté, on retourne une liste vide (sécurité)

    // Calcul de la date de début selon la période choisie
    final now = DateTime.now();
    final debut = switch (periodIndex) {
      0 => now.subtract(const Duration(hours: 1)), // 1 heure
      1 => now.subtract(const Duration(days: 7)), // 7 jours
      _ => now.subtract(const Duration(days: 30)), // 30 jours (cas par défaut)
    };

    try {
      final snapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('mesures')
          .where('date', isGreaterThan: Timestamp.fromDate(debut)) // Filtre uniquement les mesures après la date de début calculée
          .orderBy('date', descending: false) // Ordre chronologique (du plus ancien au plus récent)
          .get();
      // Transforme chaque document Firestore en Map Dart
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      return []; // En cas d'erreur on retourne une liste vide
    }
  }

  static Future<List<Map<String, dynamic>>> getMesuresPeriode(DateTime debut, DateTime fin) async {
    // Récupère les mesures entre 2 dates précises : utilisée pour la page de rapport et de fusion
    final userId = _auth.currentUser?.uid; // Vérification de l'utilisateur
    if (userId == null) return []; // Si pas d'utilisateur connecté, on retourne une liste vide (sécurité)
    try {
      final snapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('mesures')
          // Filtre pour les dates
          .where('date', isGreaterThan: Timestamp.fromDate(debut))
          .where('date', isLessThan: Timestamp.fromDate(fin))
          .orderBy('date', descending: false) // Ordre chronologique (du plus ancien au plus récent)
          .get();
      // Transforme chaque document Firestore en Map Dart
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      // En cas d'erreur, on retourne une liste vide
      return [];
    }
  }

  static Future<DateTime?> getLastMesureDate() async {
    // Récupère la date de la dernière mesure enregistrée dans Firestore 
    // Utilisé pour l'affichage du label dernière mesure sur la page du module 2 et pour le statut de connexion du module 2
    final uid = FirebaseAuth.instance.currentUser?.uid; // Vérification de l'utilisateur
    if (uid == null) return null; // Si pas d'utilisateur connecté, on retourne null (sécurité)

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('mesures')
        .orderBy('date', descending: true) // de la plus récente à la plus ancienne
        .limit(1) // On n'a uniquement besoin du dernier document
        .get();

    if (snapshot.docs.isEmpty) return null; // Cas si aucune mesure n'a été encore sauvegardée

    final data = snapshot.docs.first.data();
    final ts = data['date'];
    if (ts is Timestamp) return ts.toDate();
    // Convertit le Timestamp Firestore en DateTime Dart
    return null; // Retourne null si le champ 'date' n'est pas un Timestamp
  }

  static Future<Map<String, dynamic>?> getLastMesure() async{
    // Récupère la date de la dernière mesure enregistrée dans Firestore 
    // Utilisé pour l'affichage du label dernière mesure sur la page du module 2 et pour le statut de connexion du module 2
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid; // Vérification de l'utilisateur
      if (uid == null) return null; // Si pas d'utilisateur connecté, on retourne null (sécurité)

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('mesures')
          .orderBy('date', descending: true) // de la plus récente à la plus ancienne
          .limit(1) // On n'a uniquement besoin du dernier document
          .get();

      if (snapshot.docs.isEmpty) return null; // Cas si aucune mesure n'a été encore sauvegardée}
      return snapshot.docs.first.data();
    } catch(_){
    return null;
    }
  }
}