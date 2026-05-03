// Importation de la bibliothèque pour gérer les notifications sur navigateur web
import 'dart:html' as html;

class NotificationService {
  // Classe permettant de définir les notifications sur navigateur web
  static Future<void> init() async {
    // Initialisation des notifications
    await html.Notification.requestPermission();
  }

  static Future<void> sendAlert({
    required String type, // Type de l'alerte (température, humidité, CO2)
    required double valeur, // Valeur de la mesure
    required double seuil, // Valeur du seuil configué par l'utilisateur
    required String locale, // Variable contenant la langue choisie par l'utilisateur
    
  }) async {
    String title, body;

    // Notification quand la langue choisie est le français
    if (locale == 'fr') {
      title = '⚠️ Alerte AgroSafe';
      switch (type) {
        // Notification de température
        case 'alerte_temperature':
          body = 'Température élevée — ${valeur.toStringAsFixed(1)}°C > ${seuil.toStringAsFixed(0)}°C';
          break;
        // Notification de l'humidité
        case 'alerte_humidite':
          body = 'Humidité élevée — ${valeur.toStringAsFixed(0)}% > ${seuil.toStringAsFixed(0)}%';
          break;
        // Notification du taux de CO2
        case 'alerte_co2':
          body = 'CO₂ élevé — ${valeur.toStringAsFixed(0)}ppm > ${seuil.toStringAsFixed(0)}ppm';
          break;
        default:
          body = 'Alerte détectée';
      }
    } else {
      title = '⚠️ AgroSafe Alert';
      switch (type) {
        // Notification de température
        case 'alerte_temperature':
          body = 'High temperature — ${valeur.toStringAsFixed(1)}°C > ${seuil.toStringAsFixed(0)}°C';
          break;
        // Notification de l'humidité
        case 'alerte_humidite':
          body = 'High humidity — ${valeur.toStringAsFixed(0)}% > ${seuil.toStringAsFixed(0)}%';
          break;
        // Notification du taux de CO2
        case 'alerte_co2':
          body = 'High CO₂ — ${valeur.toStringAsFixed(0)}ppm > ${seuil.toStringAsFixed(0)}ppm';
          break;
        default:
          body = 'Alert detected';
      }
    }
    // Affichage des notifications
    html.Notification(title, body: body);
  }
}
