// Importations des bibliothèques et modules nécessaires au fonctionnement de notre fichier
import 'package:flutter_dotenv/flutter_dotenv.dart'; // pour pouvoir accéder au fichier .env
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // pour pouvoir accéder à Firebase
import 'firebase_options.dart';
// Importation du thème et module
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/widgets/bottom_nav.dart';
import 'package:avocadoguard/screens/home/home_screen.dart';
import 'package:avocadoguard/screens/avocado_module/module2_screen.dart';
import 'package:avocadoguard/screens/profile/profile_screen.dart';
import 'package:avocadoguard/screens/splash/splash_screen.dart';
// Importations des fichiers pour le changement de langues
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:avocadoguard/l10n/app_localizations.dart';
// Importation des fichiers pour les notifications
import 'package:avocadoguard/core/app_notifiers.dart';
import 'package:avocadoguard/core/services/notification_service.dart';
// Importation du fichier pour accéder et sauvegarder les préférences de l'utilisateur
import 'package:avocadoguard/core/services/user_service.dart';

void main() async {
  // Fonction permettant d'exécuter et d'initialiser notre application
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env'); // Charge les valeurs de .env
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);//initialisation des paramètres de préférences de l'application en fonction de son utilisateur
  await NotificationService.init();
  runApp(const AvocadoGuardApp()); // Exécution de l'application
}

class AvocadoGuardApp extends StatelessWidget {
  // Classe organisant l'application
  const AvocadoGuardApp({super.key});
  @override
  Widget build(BuildContext context) {
    // Reconstruit automatiquement l'application quand la langue change
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, locale, _) {
        // Ecoute la variable changeant le thème de l'application et 
        // reconstruit automatiquement l'application quand il change
        return ValueListenableBuilder<bool>(
          valueListenable: darkModeNotifier,
          builder: (context, darkMode, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false, // masque le bandeau DEBUG
              // Définition du thème clair (par défaut)
              theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
              // Définition du thème sombre (Dark mode)
              darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
              // Application du thème en fonction de la valeur de darkModeNotifier
              themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
              // Langue choisie depuis localeNotifier
              locale: locale,
              // Délégués nécessaires pour que flutter_localizations fonctionne
              localizationsDelegates: const [
                AppLocalizations.delegate, // Traductions définies dans app_fr.arb et app_en.arb
                GlobalMaterialLocalizations.delegate, // Traductions Material (boutons, dates,...)
                GlobalWidgetsLocalizations.delegate, // Tradctions des widgets de base
                GlobalCupertinoLocalizations.delegate, // Traduction style iOs
              ],
              // Définitions de langues supportées par l'application
              supportedLocales: const [Locale('fr'), Locale('en')],
              // Premier écran affiché lors du chargement de l'application
              home: const SplashScreen(),  // ← SplashScreen gère tout
            );
          },
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  // Classe gérant l'asect dynamique de la classe MainScreen
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Affichage de la page par défaut (page d'accueil)

   @override
  void initState() {
    // Fonction permettant d'initialiser l'application en fonction des préférences de l'utilisateur connecté
    super.initState(); // Initialisation de l'application
    _loadPreferences(); // Chargement des préférences de l'utilisateur
    NotificationService.init(); // Initialisation des notifications
  }

  Future<void> _loadPreferences() async {
    // Fonction permettant de charger les préférences des utilisateurs
    final data = await UserService.getUserProfile(); // Récupération des données de préférences de l'utilisateur connecté
    if (data == null) return; // Si pas de données, valeurs par défaut
    // Chargement des préférences du Mode Sombre/Dark Mode
    if (data['darkMode'] != null) {
      darkModeNotifier.value = data['darkMode'];
    }
    // Chargement des préférences de la langue (anglais ou français)
    if (data['locale'] != null) {
      localeNotifier.value = Locale(data['locale']);
    }
    // Chargement des préférences de notifications (on/off)
    if (data['notifications']!=null){
      notificationsNotifier.value = data['notifications'];
      if (data['notifications']==true) NotificationService.init();
    }
  }
  // Fonction de navigation entre les pages
  void _navigateTo(int index) => setState(() => _selectedIndex = index);

  List<Widget> get _pages => [
    // Liste comportant les pages principales
    HomeScreen(onNavigate: _navigateTo),
    Module2Screen(onNavigate: _navigateTo),
    ProfileScreen(onNavigate: _navigateTo),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      // Affichage des préférences du dark mode
      valueListenable: darkModeNotifier,
      builder: (context, darkMode, _) {
        return Scaffold(
          // Affichage de la couleur de fond en fonction de la valeur de la variable du dark mode
          backgroundColor: AgrosafeTheme.bg(),
          // Affichage de la page demandée par l'utilisateur
          body: _pages[_selectedIndex],
          // Affichage de la barre de navigation
          bottomNavigationBar: AgrosafeBottomNav(
            selectedIndex: _selectedIndex, // possibilité de naviguer entre les pages
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          ),
        );
      },
    );
  }
}