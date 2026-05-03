// Importations des bibliothèques nécessaires pour se connecter à la base de données Firebase
import 'package:firebase_core/firebase_core.dart'; // pour accéder à l'instance principale de Firebase
import 'package:firebase_database/firebase_database.dart'; // pour accéder à Firebase Realtime Database
import 'package:flutter_dotenv/flutter_dotenv.dart'; // pour pouvoir accéder au fichier .env

class RealtimeService {
  // Classe permettant de configurer l'accès à la base de données Firebase Realtime Database, utilisée pour les mesures des capteurs
  
  static final _db = FirebaseDatabase.instanceFor(
    // Crée une référence vers un noeud spécifique de la Realtime Database
    // Utilisation de static final car il n'y a qu'une seule référence partagée dans toute l'application
    app: Firebase.app(), // Récupère l'instance Firebase principale déjà initialisée dans main.dart
    databaseURL: dotenv.env['FIREBASE_DATABASE_URL']!, // URL de la base de données Firebase dont le serveur est basé en Europe
  ).ref('capteurs/module1/live'); // pointe ver le noeud 'capteurs/live' dans la base de données

  // ------ STREAM EN TEMPS RÉEL : écoute les changements en continu ------
  static Stream<Map<String, dynamic>> watchData() {
    // Retourne un Stream qui émet une nouvelle valeur à chaque modification des données dans le noeud de la Realtime Database
    return _db.onValue
    .where((event)=> event.snapshot.value !=null)
    .map((event) { // Stream qui se déclenche à chaque changement de valeur dans le noeud et transforme chaque événement reçu en Map Dart exploitable
      try{
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        // event.snapshot correspond aux données brutes reçues de Firebase
        // Map<String, dynamic>.from() correspond à la conversion en Map Dart correctement typé
        return {
          // Retourne une Map avec les valeurs correctement typées et renommées
          'temperature': (data['temperature'] as num?)?.toDouble() ?? -999.0, // le as num permet de renvoyer un int ou un double
          'humidity': (data['humidite'] as num?)?.toDouble() ?? -999.0,
          'co2': (data['co2'] as num?)?.toInt() ?? -999.0, // .toInt() car CO2 est toujours un entier
          'bai': (data['bai'] as num?)?.toDouble() ?? -999.0,
          'timestamp': (data['ts'] as num?)?.toInt() ?? 0, // Timestamp Unix (nombre de secondes depuis 01/01/1970) envoyé par la carte
        };
      }
      catch(e){
        //print('[Realtime] Erreur parsing : $e');
        rethrow;
      }
    });
  }

  // ------ LECTURE UNIQUE (pour historique/rapport) ------
  static Future<Map<String, dynamic>?> readOnce() async {
    // Lit les données une seule fois sans écouter les changements
    // Permet d'obtenir les données à l'instant T et retourne null s'il n'existe aucune donnée
    final snapshot = await _db.get(); // Récupère les données actuelles du noeud en une seule requête
    if (!snapshot.exists) return null; // Si le noeud est vide ou non existant, on retourne null pour éviter une erreur lors du cast
    final data = Map<String, dynamic>.from(snapshot.value as Map); // Permet de faire la même conversion que dans watchData()
    return {
      // Retourne la même structure que dans watchData() pour garder une certaine cohérence
      'temperature': (data['temperature'] as num).toDouble(),
      'humidity': (data['humidite'] as num).toDouble(),
      'co2': (data['co2'] as num).toDouble(),
      'bai': (data['bai'] as num).toDouble(),
      'timestamp': (data['ts'] as num).toInt(),
    };
  }

  // Vérifie si la valeur est valide (pas un code d'erreur)
  static bool isValid(double value) => value != -999;
  // Cela permet de filtrer les valeurs invalides avant de les afficher ou les sauvegarder dans Firestore
}