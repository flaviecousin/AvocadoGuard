// Importation des bibliothèques nécessaires pour la configuration de Firebase dans l'application
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions; // pour configurer les options de Firebase pour l'application 
import 'package:flutter_dotenv/flutter_dotenv.dart'; // pour pouvoir accéder au fichier .env
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform; // pour détecter la plateforme sur laquelle l'application est exécutée (Android, iOS, etc.) afin de configurer les options de Firebase en conséquence

class DefaultFirebaseOptions {
  // Classe permettant de configurer les options de Firebase pour l'application en fonction de la plateforme sur laquelle elle est exécutée
  static FirebaseOptions get currentPlatform { // Permet de récupérer les options de Firebase correspondant à la plateforme sur laquelle l'application est exécutée pour configurer correctement Firebase pour cette plateforme
    switch (defaultTargetPlatform) { // Permet de détecter la plateforme sur laquelle l'application est exécutée pour configurer les options de Firebase en conséquence
      case TargetPlatform.android: // Si l'application est exécutée sur Android, retourne les options de Firebase pour Android
        return android;
      default: // Si l'application est exécutée sur une plateforme non supportée, lance une erreur pour indiquer que la configuration de Firebase n'est pas disponible pour cette plateforme
        return android;
    }
  }

  // Options de Firebase pour Android
  static FirebaseOptions get android => FirebaseOptions(
    // Configuration des options de Firebase pour Android avec les valeurs spécifiques à l'application pour cette plateforme (clé d'API, ID de l'application, etc.) pour permettre à l'application d'utiliser les services de Firebase correctement sur Android
    apiKey: dotenv.env['FIREBASE_API_KEY']!,
    appId: dotenv.env['FIREBASE_APP_ID']!,
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
    projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
  );
}