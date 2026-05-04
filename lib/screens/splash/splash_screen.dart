// Importation des bibliothèques
import 'package:firebase_auth/firebase_auth.dart'; // pour gérer l'authentification de l'utilisateur
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/app_notifiers.dart'; // pour gérer les préférences de l'utilisateur
import 'package:avocadoguard/core/services/user_service.dart'; // pour charger les préférences de l'utilisateur
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/main.dart'; // pour accéder à l'écran principal de l'application
import 'package:avocadoguard/screens/splash/login_screen.dart'; // pour accéder à l'écran de connexion de l'application

class SplashScreen extends StatefulWidget {
  // Classe permettant de configurer l'affichage de l'écran de chargement de l'application
  const SplashScreen({super.key}); // Constructeur de la classe
  @override
  State<SplashScreen> createState() => _SplashScreenState(); // Création de l'état mutable de la classe SplashScreen
}

class _SplashScreenState extends State<SplashScreen>
 // Classe permettant de gérer l'affichage de l'écran de chargement de l'application
    with SingleTickerProviderStateMixin { // Permet d'utiliser un ticker pour l'animation de la barre de progression
  late AnimationController _controller; // Contrôleur de l'animation de la barre de progression
  late Animation<double> _progressAnimation; // Animation de la barre de progression

  @override
  void initState() {
    // Fonction permettant d'initialiser l'animation de la barre de progression et de charger les préférences de l'utilisateur au lancement de l'écran de chargement
    super.initState();
    _controller = AnimationController(// Configuration du contrôleur de l'animation de la barre de progression
      vsync: this, // Permet d'utiliser le ticker pour l'animation
      duration: const Duration(seconds: 3), // Durée de l'animation de la barre de progression (3 secondes) pour simuler le temps de chargement de l'application
    );
    //..forward(); // Démarre l'animation de la barre de progression dès l'initialisation de l'écran de chargement
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller); // Configuration de l'animation de la barre de progression pour faire progresser la barre de 0% à 100% pendant la durée de l'animation

    _initApp(); // Appelle la fonction d'initialisation de l'application pour charger les préférences de l'utilisateur et naviguer vers l'écran principal ou l'écran de connexion en fonction de l'état de connexion de l'utilisateur après la fin de l'animation de la barre de progression
  }

  Future<void> _initApp() async {
    // Fonction permettant de charger les préférences de l'utilisateur et de naviguer vers l'écran principal ou l'écran de connexion en fonction de l'état de connexion de l'utilisateur après la fin de l'animation de la barre de progression
    await Future.wait([ // Attend la fin de l'animation de la barre de progression et le chargement des préférences de l'utilisateur en parallèle
      _controller.forward(), // Attend la fin de l'animation de la barre de progression
      _loadPreferences(), // Attend le chargement des préférences de l'utilisateur
    ]);
    if (!mounted) return; // Vérifie que le widget est toujours monté avant de naviguer vers l'écran principal ou l'écran de connexion pour éviter les erreurs de navigation si l'utilisateur quitte l'écran de chargement avant la fin de l'animation ou du chargement des préférences
    final user = FirebaseAuth.instance.currentUser; // Récupère l'utilisateur actuellement connecté pour déterminer vers quel écran naviguer (écran principal si l'utilisateur est connecté, sinon écran de connexion)
    Navigator.of(context).pushReplacement( // Navigue vers l'écran principal ou l'écran de connexion en fonction de l'état de connexion de l'utilisateur après la fin de l'animation de la barre de progression
      MaterialPageRoute(
        builder: (context) => user != null
            ? const MainScreen()
            : const LoginScreen(),
      ),
    );
  }

  Future<void> _loadPreferences() async {
    // Fonction permettant de charger les préférences de l'utilisateur à partir du service utilisateur et de mettre à jour les notifiers correspondants pour que l'application puisse utiliser ces préférences lors de son fonctionnement
    final user = await FirebaseAuth.instance.authStateChanges().first; // Récupère l'utilisateur actuellement connecté pour charger les préférences de cet utilisateur spécifique, sinon ne charge pas les préférences si aucun utilisateur n'est connecté
    if (user == null) return; // Si aucun utilisateur n'est connecté, ne charge pas les préférences et retourne simplement pour éviter les erreurs de chargement des préférences pour un utilisateur non connecté

    final prefs = await UserService.loadPreferences(); // Charge les préférences de l'utilisateur connecté à partir du service utilisateur (par exemple, à partir d'une base de données ou d'un stockage local) pour récupérer les préférences spécifiques de cet utilisateur
    darkModeNotifier.value = prefs?['darkMode'] ?? false; // Met à jour le notifier du thème sombre avec la préférence de l'utilisateur ou thème clair par défaut si la préférence n'est pas définie
    localeNotifier.value = Locale(prefs?['locale'] ?? 'fr'); // Met à jour le notifier de langue avec la préférence de l'utilisateur ou 'fr' par défaut si la préférence n'est pas définie
  }

  @override
  void dispose() {
    // Fonction permettant de nettoyer les ressources utilisées par l'animation de la barre de progression lorsque le widget est supprimé pour éviter les fuites de mémoire
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Widget permettant de configurer l'affichage de l'écran de chargement de l'application avec le nom de l'application, son slogan et la barre de progression
    return Scaffold(
      backgroundColor: AgrosafeTheme.soil,
      body: Center( // Permet de centrer le contenu de l'écran de chargement horizontalement
        child: Padding(
          padding: EdgeInsets.symmetric( // Marge interne de l'écran de chargement avec une marge horizontale plus grande pour les écrans plus larges pour éviter que le contenu ne soit trop étiré sur des écrans larges
            horizontal: MediaQuery.of(context).size.width > 600 ? 300 : 40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,  // Permet de réduire la taille verticale de la colonne au minimum nécessaire pour contenir son contenu pour éviter que le contenu ne soit trop étiré verticalement sur des écrans plus grands
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child:RichText( // Permet d'afficher le nom de l'application avec des styles différents pour "AgroSafe" et "App"
                  textAlign: TextAlign.center,
                  text: TextSpan( // Configuration du texte avec des styles différents pour "AgroSafe" et "App"
                    children: [
                      // Partie 1 du nom de l'application (AgroSafe) avec son style
                      TextSpan(
                        text: 'Avocado',
                        style: AgrosafeTheme.splashTitle,
                      ),
                      // Partie 2 du nom de l'application (App) avec son style
                      TextSpan(
                        text: ' Guard',
                        style: AgrosafeTheme.splashSubtitle,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12), // Espace entre le nom de l'application et le slogan
              // Affichage du slogan de l'application et son style
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "SÉCURISER. SURVEILLER. PROTÉGER.",
                  textAlign: TextAlign.center,
                  style: AgrosafeTheme.splashSlogan,
                ),
              ),
              const SizedBox(height: 40), // Espace entre le slogan et la barre de progression
              // Affichage de la barre de progression avec son animation pour simuler le temps de chargement de l'application
              AnimatedBuilder(
                animation: _progressAnimation, // Permet de faire progresser la barre de progression en fonction de l'animation de la barre de progression configurée dans initState pour simuler le temps de chargement de l'application
                builder: (context, child) {
                  // Style de la barre de progression (couleur de progression différente de celle du fond pour être visible)
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: _progressAnimation.value, // Permet de faire progresser la barre de progression en fonction de l'animation de la barre de progression configurée dans initState pour simuler le temps de chargement de l'application
                      backgroundColor: AgrosafeTheme.bark,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AgrosafeTheme.lime, // Valeur de la barre de progression avec une couleur différente du fond pour être visible pendant l'animation de chargement de l'application
                      ),
                      minHeight: 3, // Hauteur de la barre de progression pour qu'elle soit suffisamment visible pendant l'animation de chargement de l'application sans être trop épaisse pour ne pas prendre trop de place à l'écran
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
