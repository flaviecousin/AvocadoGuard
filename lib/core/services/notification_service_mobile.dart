// Importation de la bibliothèque pour gérer les notifications sur mobile
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Classe permettant de définir les notifications
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Initialisation des paramètres de notifications en fonction de son système (Android, iOS)
    const settings = InitializationSettings( // définit les paramètres d'initialisation pour chaque plateforme
      android: AndroidInitializationSettings('@mipmap/ic_launcher'), // Sur Android : on précise l'icône à afficher dans la barre de notifications
      iOS: DarwinInitializationSettings(), // Sur iOS : on utilise les paramètres par défaut d'Apple

    );
    await _localNotifications.initialize(settings); // Initialise le plugin de notifications locales avec les paramètres définis précédemment
    final androidPlugin = _localNotifications
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> sendAlert({
    // Gestion des notifications d'alerte
    required String type, // Type de l'alerte (température, humidité, CO2)
    required double valeur, // Valeur du capteur
    required double seuil, // Valeur du seuil configuré par l'utilisateur
    required String locale, // Variable contenant la langue choisie par l'utilisateur
  }) async {
    String title, body;

    // Notifications quand la langue choisie est le français
    if (locale == 'fr') {
      title = '⚠️ Alerte AgroSafe';
      switch (type) {
        // Notifications pour la température
        case 'alerte_temperature':
          body = 'Température élevée — ${valeur.toStringAsFixed(1)}°C > ${seuil.toStringAsFixed(0)}°C';
          break;
        // Notifications pour le taux d'humidité dans l'air
        case 'alerte_humidite':
          body = 'Humidité élevée — ${valeur.toStringAsFixed(0)}% > ${seuil.toStringAsFixed(0)}%';
          break;
        // Notifications pour le taux de CO2 dans l'air
        case 'alerte_co2':
          body = 'CO₂ élevé — ${valeur.toStringAsFixed(0)}ppm > ${seuil.toStringAsFixed(0)}ppm';
          break;
        default:
          body = 'Alerte détectée';
      }
    } 
    // Notifications quand la langue choisie est l'anglais
    else {
      title = '⚠️ AgroSafe Alert';
      // Notifications pour la température
      switch (type) {
        case 'alerte_temperature':
          body = 'High temperature — ${valeur.toStringAsFixed(1)}°C > ${seuil.toStringAsFixed(0)}°C';
          break;
        // Notifications pour le taux d'humidité dans l'air
        case 'alerte_humidite':
          body = 'High humidity — ${valeur.toStringAsFixed(0)}% > ${seuil.toStringAsFixed(0)}%';
          break;
        // Notifications pour le taux de CO2 dans l'air
        case 'alerte_co2':
          body = 'High CO₂ — ${valeur.toStringAsFixed(0)}ppm > ${seuil.toStringAsFixed(0)}ppm';
          break;
        default:
          body = 'Alert detected';
      }
    }

    const androidDetails = AndroidNotificationDetails(
      // Définition des notifications pour un appareil Android
      'agrosafe_alerts',
      'Alertes AgroSafe',
      channelDescription: 'Notifications des alertes IoT',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _localNotifications.show(
      // Affichage des notifications
      0,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }
}
