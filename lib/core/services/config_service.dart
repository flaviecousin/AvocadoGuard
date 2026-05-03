// Importations des bibliothèques et des fichiers nécessaires
import 'package:cloud_firestore/cloud_firestore.dart'; // pour pouvoir accéder à la base de données Firestore
import 'package:firebase_auth/firebase_auth.dart'; // pour pouvoir accéder aux données de l'authentification
import 'package:avocadoguard/core/models/lot_config.dart'; // pour pouvoir accéder au modèle de données de l'écran de configuration

class ConfigService {
  // Classe de configuration qui permet de sauvegarder les données de l'écran de configuration dans la base de données de Firebase/Firestore
  static final _db = FirebaseFirestore.instance; // Variable permettant d'interagir avec la base de données de Firestore
  static final _auth = FirebaseAuth.instance; // Variable permettant d'interagir avec Firebase Auth

  static String? get _userId => _auth.currentUser?.uid;  // Récupération des données de l'utilisateur

  // ------ SAUVEGARDE DONNÉES ÉCRAN DE CONFIGURATION ------
  static Future<void> saveConfig(LotConfig config) async {
    if (_userId == null) return; // Vérification de l'utilisateur
    await _db.collection('users').doc(_userId).set({// Récupération des données précédemment enregistrées
      'capteurId': config.capteurId, // Identifiant du capteur
      'lotName': config.lotName, // Nom du lot
      'culture': config.culture, // Nom de la culture surveillée
      'temperatureMax': config.temperatureMax, // Valeur de la température max choisie
      'humidityMax': config.humidityMax, // Valeur de l'humidité max choisie
      'co2Max': config.co2Max, // Valeur de la concentration de CO2 max choisie
      'frequency': config.frequency, // Valeur de la fréquence des mesures choisie
      'lastModified': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  // ------ CHARGEMENT DE LA CONFIGURATION DEPUIS FIRESTORE ------
  static Future<LotConfig> loadConfig() async {
    // Si pas d'utilisateur connecté => configuration par défaut
    if (_userId == null) return _defaultConfig();
    try {
      // Récupère les données de l'utilisateur dans Firestore
      final doc = await _db.collection('users').doc(_userId).get();
      // Si les valeurs n'existent pas => configuration par défaut
      if (!doc.exists) return _defaultConfig();

      final data = doc.data()!;
      // Reconstruit un objet LotConfig depuis les données Firestore
      // ?? = valeur par défaut si le champ est absent dans Firestore
      return LotConfig(
        capteurId: data['capteurId'] ?? 'ESP32_AVOC_003',
        lotName: data['lotName'] ?? 'Lot n°X',
        culture: data['culture'] ?? 'Avocat Hass',
        temperatureMax: (data['temperatureMax'] ?? 7.0).toDouble(), // Conversion en double
        humidityMax: (data['humidityMax'] ?? 90.0).toDouble(), // Conversion en double
        co2Max: (data['co2Max'] ?? 1000.0).toDouble(), // Conversion en double
        frequency: data['frequency'] ?? '5 min',
        lastModified: (data['lastModified'] as Timestamp?)?.toDate(),
      );
    } catch (e) {
      // En cas d'erreur réseau ou Firestore => configuation par défaut
      return _defaultConfig();
    }
  }

  // ------ VALEURS PAR DÉFAUT ------
  static LotConfig _defaultConfig() {
    return LotConfig(
      capteurId: 'ESP32_AVOC_003',
      lotName: 'Lot n°X',
      culture: 'Avocat Hass',
      temperatureMax: 7.0,
      humidityMax: 90.0,
      co2Max: 1000.0,
      frequency: '5 min',
    );
  }
}