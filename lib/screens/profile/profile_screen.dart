// Importation des bibliothèques
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/app_notifiers.dart'; // pour gérer les préférences de l'utilisateur
import 'package:avocadoguard/core/services/auth_service.dart'; // pour gérer l'authentification et la déconnexion de l'utilisateur
import 'package:avocadoguard/core/services/notification_service_mobile.dart'; // pour gérer les notifications push sur mobile
import 'package:avocadoguard/core/services/user_service.dart'; // pour récupérer les données du profil utilisateur
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour changer la langue
import 'package:avocadoguard/screens/history/historique_screen.dart';
import 'package:avocadoguard/screens/reports/rapport_lot_screen.dart';
import 'package:avocadoguard/screens/profile/user_screen.dart'; // pour accéder à l'écran de profil utilisateur
import 'package:avocadoguard/screens/splash/login_screen.dart'; // pour accéder à l'écran de connexion
import 'package:avocadoguard/widgets/quick_access_cards.dart'; // pour afficher les cartes d'accès rapide aux modules
import 'package:avocadoguard/widgets/settings_card.dart'; // pour afficher la carte des paramètres
import 'package:avocadoguard/widgets/user_card.dart'; // pour afficher la carte de profil utilisateur

class ProfileScreen extends StatefulWidget {  
  // Classe permettant de configurer la page de profil utilisateur
  final Function(int) onNavigate; // pour naviguer sur les différentes pages de l'application
  const ProfileScreen({
    // Constructeur de la classe
    super.key,
    required this.onNavigate
  });

  @override
  // Permet d'avoir l'état mutable associé à ce widget
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Classe permettant de gérer l'affichage de la page de profil utilisateur
  String? _roleKey; // Variable pour stocker le rôle de l'utilisateur
  bool _isLoading = false; // Variable pour indiquer si une action de chargement est en cours (ex: déconnexion)
  final _authService = AuthService(); // Instance du service d'authentification pour gérer la déconnexion de l'utilisateur

  @override
  // Object permettant d'appeler et d'initialiser _loadProfile au lancement de la page de profil pour charger le profil de l'utilisateur et ses préférences
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    // Permet de charger le profil de l'utilisateur et ses préférences (rôle, thème sombre, langue, notifications)
    final data = await UserService.getUserProfile(); // Récupère les données du profil utilisateur (rôle, préférences, etc.) à partir du service UserService
    setState(() { // Met à jour l'état de la page de profil avec les données récupérées
      _roleKey = data?['role']; // Stocke le rôle de l'utilisateur
      // Met à jour les préférences de thème de l'utilisateur à partir des données récupérées
      if (data?['darkMode'] != null) {
        darkModeNotifier.value = data!['darkMode'];
      }
      // Met à jour les préférences de langue de l'utilisateur à partir des données récupérées
      if (data?['locale'] != null) {
        localeNotifier.value = Locale(data!['locale']);
      }
      // Met à jour les préférences d'affichage de notifications de l'utilisateur à partir des données récupérées
      if (data?['notifications']!=null && data!['notifications']==true){
        NotificationService.init();
      }
    });
  }

  String get _roleLabel {
    // Permet d'obtenir le label du rôle de l'utilisateur à afficher sur la carte de profil en fonction de sa valeur
    final l10n = AppLocalizations.of(context)!; // permet de changer la langue des textes
    switch (_roleKey?.toLowerCase()) {
      case 'agriculteur': return l10n.agri; // Cas où le rôle de l'utilisateur est celui d'un agriculteur
      case 'gestionnaire': return l10n.gestionn; // Cas où le rôle de l'utilisateur est celui d'un gestionnaire de stockage
      default: return l10n.pbProfil; // Cas où le rôle de l'utilisateur n'est pas reconnu ou n'est pas défini
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget permettant de configurer l'affichage de la page de profil utilisateur
    final l10n = AppLocalizations.of(context)!; // permet de changer la langue des textes
    return ValueListenableBuilder<bool>( // Permet de reconstruire la page de profil utilisateur à chaque changement de la préférence de thème pour appliquer le thème correspondant
      valueListenable: darkModeNotifier,// Écoute les changements de la préférence de thème
      builder: (context, darkMode, _){ // Reconstruit la page de profil utilisateur en fonction de la valeur actuelle de la préférence de thème
        return Scaffold(
          backgroundColor: AgrosafeTheme.bg(), // Couleur de fond de la page de profil utilisateur en fonction du thème
          body: SafeArea(
            child: SingleChildScrollView( // Permet de scroller sur la page de profil utilisateur si le contenu dépasse la taille de l'écran
              padding: const EdgeInsets.symmetric( // Marge interne de la page de profil utilisateur
                horizontal: AgrosafeTheme.screenHorizontalPadding,
                vertical: 20,
              ),
              child: Column( // Alignement vertical des éléments de la page de profil utilisateur
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Affichage du titre de la page et son style
                  Text(
                    l10n.profil,
                    style: AgrosafeTheme.displayTitle.copyWith(color: AgrosafeTheme.textPrimary()),
                  ),
                  const SizedBox(height: 10), // Espace entre le titre de la page et la carte d'utilisateur

                  // ------- PROFIL CARD -------
                  UserCard(
                    title: _roleLabel, // Affiche le rôle de l'utilisateur sur la carte
                    subtitle: 'AgroSafe User', // Sous-titre de la carte
                    ctaLabel: l10n.voirProfil, // Texte du bouton de la carte de profil utilisateur
                    onCtaTap: () { // Action du bouton de la carte de profil utilisateur pour naviguer vers sa page de profil détaillé
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserScreen(onNavigate: widget.onNavigate)),
                      );
                    },
                  ),
                  const SizedBox(height: 10),// Espace entre la carte de profil utilisateur et le titre de la section des paramètres

                  // ------- SETTINGS PART -------
                  // Titre de la section des paramètres et son style
                  Text(
                    l10n.settings,
                    style: AgrosafeTheme.displayTitle.copyWith(color: AgrosafeTheme.textMuted())
                  ),
                  const SizedBox(height: 10), // Espace entre le titre de la section des paramètres et la carte des paramètres
                  // Carte des paramètres pour gérer les préférences de l'utilisateur
                  SettingsCard(
                    title: l10n.notifications, // Texte de la préférence d'affichage des notifications
                    subtitle: l10n.darkMode, // Texte de la préférence de thème
                  ),
                  const SizedBox(height: 10), // Espace entre la carte des paramètres et le titre de la section d'accès rapide aux modules

                  // ------- QUICK ACCESS PART -------
                  // Titre de la section d'accès rapide aux modules et son style
                  Text(
                    l10n.quickAccess,
                    style: AgrosafeTheme.displayTitle.copyWith(color: AgrosafeTheme.textMuted())
                  ),
                  const SizedBox(height: 10), // Espace entre le titre de la section d'accès rapide aux modules et la carte d'accès rapide aux modules
                  // Carte d'accès rapide aux modules pour naviguer rapidement vers les pages des modules
                  QuickAccessCard(
                    onCtaTap1: () => widget.onNavigate(2), // Action du bouton d'accès rapide au module 2 pour naviguer vers sa page
                    onCtaTap2: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoriqueScreen(onNavigate: widget.onNavigate),
                        ),
                      );
                    },
                    onCtaTap3: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RapportLotScreen(onNavigate: widget.onNavigate),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 50), // Espace entre la carte d'accès rapide aux modules et le bouton de déconnexion
                  
                  // ------ BOUTON DE DÉCONNEXION ------
                  // Affichage du bouton de déconnexion
                  ElevatedButton(
                    style: AgrosafeTheme.logoutButtonStyle, // Style du bouton de déconnexion
                    onPressed: () async { // Action du bouton de déconnexion pour se déconnecter de l'application et revenir à l'écran de connexion
                      setState(() => _isLoading = true); // Affiche un indicateur de chargement pendant la déconnexion
                      final navigator = Navigator.of(context); // Permet de naviguer vers l'écran de connexion après la déconnexion
                      await _authService.logout(); // Appelle la méthode de déconnexion du service d'authentification pour se déconnecter de l'application
                      navigator.pushReplacement( // Navigue vers l'écran de connexion en remplaçant la page actuelle pour éviter de revenir à la page de profil après la déconnexion
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: _isLoading // Affiche un indicateur de chargement pendant la déconnexion, sinon affiche le texte du bouton de déconnexion
                        ? const CircularProgressIndicator( // Indicateur de chargement pendant la déconnexion avec son style
                            color: AgrosafeTheme.white,
                          )
                        : Text(l10n.deconnexion, // Texte du bouton de déconnexion avec son style
                            style:AgrosafeTheme.displayTitle.copyWith(
                            fontSize: 25)
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}