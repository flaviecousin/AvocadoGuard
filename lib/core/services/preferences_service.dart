// Importation de la bibliothèque permettant de garder en mémoire les préférences de paramètres des utilisateurs
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  // Classe gérant les préférences des utilisateurs
  static const _darkModeKey = 'darkMode';
  static const _localeKey = 'locale';

  // ------ DARK MODE ------
  static Future<void> saveDarkMode(bool value) async {
    // Sauvegarde les préférences du thème
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  static Future<bool> loadDarkMode() async {
    // Charge les préférences du thème
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  // ------ LANGUES ------
  static Future<void> saveLocale(String languageCode) async {
    // Sauvegarde la langue choisie
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, languageCode);
  }

  static Future<String> loadLocale() async {
    // Charge la langue choisie
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localeKey) ?? 'fr';
  }
}