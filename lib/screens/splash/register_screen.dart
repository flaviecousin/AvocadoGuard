// Importation des bibliothèques nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/app_notifiers.dart'; // pour accéder aux variables de préférences de l'application
import 'package:avocadoguard/core/services/auth_service.dart'; // pour gérer l'authentification de l'utilisateur lors de l'inscription
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour la traduction des textes de l'interface
import 'package:avocadoguard/main.dart'; // pour accéder à l'écran principal de l'application après l'inscription réussie
import 'package:avocadoguard/widgets/register_card.dart'; // pour afficher les champs de saisie du formulaire d'inscription avec un style personnalisé

class RegisterScreen extends StatefulWidget {
  // Classe permettant de configurer l'affichage de l'écran d'inscription de l'application
  const RegisterScreen({super.key}); // Constructeur de la classe

  @override
  State<RegisterScreen> createState() => _RegisterScreenState(); // Création de l'état mutable de la classe
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Classe permettant de gérer l'affichage de l'écran d'inscription de l'application et les interactions de l'utilisateur avec cet écran
  bool _isPasswordHidden = true; // Variable permettant de gérer l'affichage du mot de passe (masqué ou visible) pour le champ de saisie du mot de passe
  bool _isConfirmPasswordHidden = true; // Variable permettant de gérer l'affichage du mot de passe (masqué ou visible) pour le champ de saisie du mot de passe
  final _formKey = GlobalKey<FormState>(); // Clé de formulaire pour valider les champs de saisie du formulaire d'inscription avant de soumettre les données d'inscription pour éviter les erreurs d'inscription
  final _passwordController = TextEditingController(); // Contrôleur pour le champ de saisie du mot de passe pour pouvoir accéder à la valeur saisie dans ce champ lors de la validation du formulaire et de la soumission des données d'inscription
  final _confirmPasswordController = TextEditingController(); // Contrôleur pour le champ de saisie de confirmation du mot de passe pour pouvoir accéder à la valeur saisie dans ce champ lors de la validation du formulaire et de la soumission des données d'inscription pour vérifier que le mot de passe et sa confirmation correspondent
  final _emailController = TextEditingController(); // Contrôleur pour le champ de saisie de l'email pour pouvoir accéder à la valeur saisie dans ce champ lors de la validation du formulaire et de la soumission des données d'inscription
  final _authService = AuthService(); // Instance du service d'authentification pour gérer l'inscription de l'utilisateur avec les données saisies dans le formulaire d'inscription et communiquer avec Firebase pour créer un compte utilisateur avec ces données
  bool _isLoading = false; // Variable pour gérer l'état de chargement lors de la soumission du formulaire d'inscription pour afficher un indicateur de chargement pendant que les données d'inscription sont traitées et éviter les interactions multiples avec le formulaire pendant ce temps
  String? _selectedRole; // Variable pour stocker le rôle sélectionné par l'utilisateur dans le formulaire d'inscription pour pouvoir inclure ce rôle dans les données d'inscription soumises au service d'authentification et créer un compte utilisateur avec ce rôle spécifique

  @override
  void dispose() {
    // Fonction pour nettoyer les ressources utilisées par les contrôleurs de texte pour éviter les fuites de mémoire lorsque l'écran d'inscription est détruit
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Widget permettant de configurer l'affichage de l'écran d'inscription de l'application
    final l10n = AppLocalizations.of(context)!; // pour changer la langue des textes
    return Scaffold(
      backgroundColor: AgrosafeTheme.cream, // ne change pas la couleur de fond peut importe le thème utilisé précédemment
      body: SafeArea(
        child: SingleChildScrollView( // Permet de scroller si le contenu de l'écran d'inscription dépasse la taille de l'écran pour éviter les problèmes d'affichage sur les petits écrans
          padding: const EdgeInsets.symmetric( // Marges interne de la page
            horizontal: AgrosafeTheme.screenHorizontalPadding,
            vertical: 20,
          ),
          child: Form( // Formulaire pour regrouper les champs de saisie de l'écran d'inscription et permettre la validation de ces champs avant de soumettre les données d'inscription pour éviter les erreurs d'inscription
            key: _formKey, // Clé de formulaire pour valider les champs de saisie du formulaire d'inscription avant de soumettre les données d'inscription
            child: Column( // Alignement vertical des éléments de l'écran d'inscription
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center( // On centre le titre de la page sur l'écran (horizontalement)
                  child: Text( // Affichage du titre de la page avec son style
                    l10n.creerCompte,
                    style: AgrosafeTheme.displayTitle.copyWith(color: AgrosafeTheme.moss),
                  ),
                ),

                // ------ BOUTONS DE LANGUE ------
                Align( // Alignement des boutons
                  alignment: Alignment.centerRight, // Alignement des boutons de langue à droite de l'écran
                  child: ValueListenableBuilder<Locale>( // Permet de reconstruire les boutons de langue lorsque la langue sélectionnée change (la couleur du bouton change en fonction de si elle est sélectionnée ou non)
                    valueListenable: localeNotifier,
                    builder: (context, locale, _) { // Permet de configurer l'affichage des boutons de langue avec une couleur différente pour le bouton de la langue sélectionnée pour indiquer à l'utilisateur quelle langue est actuellement sélectionnée et lui permettre de changer de langue en cliquant sur les boutons
                      return Row( // Organisation des boutons de langue en ligne
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Action du bouton de langue (français)
                          GestureDetector(
                            onTap: () => localeNotifier.value = const Locale('fr'), // Met à jour la variable locale de langue pour afficher le texte en français
                            child: Container( // Affichage du bouton de langue
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Taille du bouton de langue
                              decoration: BoxDecoration(
                                color: locale.languageCode == 'fr' ? AgrosafeTheme.leaf : AgrosafeTheme.cream, // Utilisattion de 2 couleurs si elle est sélectionnée ou non pour indiquer si le français est la langue sélectionnée
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AgrosafeTheme.leaf),
                              ),
                              // Affichage du texte du bouton de langue (français) avec son style
                              child: Text('🇫🇷 FR',
                                  style: TextStyle(
                                    color: locale.languageCode == 'fr' ? AgrosafeTheme.white : AgrosafeTheme.leaf, // Couleur de texte différente si le français est la langue sélectionnée ou non
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                          ),
                          const SizedBox(width: 8), // Espace entre les boutons de langue
                          // Action du bouton de langue (anglais)
                          GestureDetector(
                            onTap: () => localeNotifier.value = const Locale('en'), // Met à jour la variable locale de langue pour afficher le texte en anglais
                            child: Container( // Affichage du bouton de langue (anglais)
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Taille du bouton de langue
                              decoration: BoxDecoration(
                                color: locale.languageCode == 'en' ? AgrosafeTheme.leaf : AgrosafeTheme.cream, // Changement de couleur du fond du bouton en fonction de la langue sélectionnée
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AgrosafeTheme.leaf),
                              ),
                              // Affichage du texte du bouton de langue (anglais) avec son style
                              child: Text('🇬🇧 EN',
                                  style: TextStyle(
                                    color: locale.languageCode == 'en' ? AgrosafeTheme.white : AgrosafeTheme.leaf, // Couleur de texte différente si l'anglais est la langue sélectionnée ou non
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40), // Espace entre les boutons de langue et la partie de l'email

                // ------- PARTIE EMAIL -------
                RegisterCard(
                  label: l10n.email, // Titre de la partie
                  context: context, // Contexte pour la construction de la carte de saisie
                  field: TextFormField( // Champ de saisie pour l'email avec validation pour vérifier que l'email est au bon format et n'est pas vide avant de soumettre les données d'inscription
                    controller: _emailController, // Contrôleur pour accéder à la valeur saisie dans ce champ lors de la validation du formulaire et de la soumission des données d'inscription
                    cursorColor: AgrosafeTheme.moss, // Couleur du curseur de saisie
                    style: const TextStyle(color: AgrosafeTheme.moss), // Style du texte saisi dans le champ de saisie
                    decoration: InputDecoration( // Style du champ de saisie avec une bordure, un label et des couleurs différentes pour les états normal et focus
                      border: const UnderlineInputBorder(),
                      labelText: l10n.emailEntre,
                      labelStyle: const TextStyle(color: AgrosafeTheme.muted),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AgrosafeTheme.moss),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AgrosafeTheme.border),
                      ),
                    ),
                    validator: (value) { // Validation du champ de saisie de l'email pour vérifier que l'email est au bon format et n'est pas vide avant de soumettre les données d'inscription
                      if (value == null || value.isEmpty) return l10n.needEmail; // Vérifie que le champ de saisie de l'email n'est pas vide
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) { // Vérifie que le champ de saisie de l'email est au bon format (une adresse email valide doit contenir un "@" et un domaine après le "@")
                        return l10n.invalidEmail;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16), // Espace entre la partie de l'email et la partie du mot de passe

                // ------- PARTIE MOT DE PASSE -------
                RegisterCard(
                  label: l10n.motDePasse, // Titre de la partie
                  context: context, // Contexte pour la construction de la carte de saisie
                  field: TextFormField( // Champ de saisie pour le mot de passe avec validation pour vérifier que le mot de passe n'est pas vide, qu'il a une longueur minimale et pour permettre à l'utilisateur de basculer entre l'affichage masqué et visible du mot de passe pour éviter les erreurs de saisie du mot de passe
                    controller: _passwordController, // Contrôleur pour accéder à la valeur saisie dans ce champ lors de la validation du formulaire et de la soumission des données d'inscription
                    cursorColor: AgrosafeTheme.moss,
                    obscureText: _isPasswordHidden, // Permet de masquer ou d'afficher le mot de passe saisi en fonction de la valeur de _isPasswordHidden
                    style: const TextStyle(color: AgrosafeTheme.moss),
                    decoration: InputDecoration( // Style du champ de saisie avec une icône pour basculer entre l'affichage masqué et visible du mot de passe, et des couleurs différentes pour les états normal et focus
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                          color: AgrosafeTheme.moss,
                        ),
                        onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden), // Action de l'icône pour basculer entre l'affichage masqué et visible du mot de passe en inversant la valeur de _isPasswordHidden
                      ),
                      border: const UnderlineInputBorder(),
                      labelText: l10n.mdpEntre, // Texte du label du champ de saisie du mot de passe
                      labelStyle: const TextStyle(color: AgrosafeTheme.muted),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AgrosafeTheme.moss),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AgrosafeTheme.border),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return l10n.needMdp; // Vérifie que le champ de saisie du mot de passe n'est pas vide
                      if (value.length < 6) return l10n.mdpTooShort; // Vérifie que le mot de passe a une longueur minimale de 6 caractères pour des raisons de sécurité
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16), // Espace entre la partie du mot de passe et la partie de confirmation du mot de passe

                // ------- PARTIE CONFIRMATION MOT DE PASSE -------
                RegisterCard(
                  label: l10n.confirmation, // Titre de la partie
                  context: context, // Contexte pour la construction de la carte de saisie
                  field: TextFormField( // Champ de saisie pour la confirmation du mot de passe avec validation pour vérifier que la confirmation du mot de passe correspond au mot de passe saisi et pour permettre à l'utilisateur de basculer entre l'affichage masqué et visible de la confirmation du mot de passe
                    controller: _confirmPasswordController, // Contrôleur pour accéder à la valeur saisie dans ce champ lors de la validation du formulaire et de la soumission des données d'inscription pour vérifier que le mot de passe et sa confirmation correspondent
                    cursorColor: AgrosafeTheme.moss,
                    obscureText: _isConfirmPasswordHidden, // Permet de masquer ou d'afficher la confirmation du mot de passe saisi en fonction de la valeur de _isConfirmPasswordHidden
                    style: const TextStyle(color: AgrosafeTheme.moss),
                    decoration: InputDecoration( // Style du champ de saisie avec une icône pour basculer entre l'affichage masqué et visible de la confirmation du mot de passe, et des couleurs différentes pour les états normal et focus
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordHidden ? Icons.visibility_off : Icons.visibility,
                          color: AgrosafeTheme.moss,
                        ),
                        onPressed: () => setState(() => _isConfirmPasswordHidden = !_isConfirmPasswordHidden), // Action de l'icône pour basculer entre l'affichage masqué et visible de la confirmation du mot de passe en inversant la valeur de _isConfirmPasswordHidden
                      ),
                      border: const UnderlineInputBorder(),
                      labelText: l10n.confirmationMdp,
                      labelStyle: const TextStyle(color: AgrosafeTheme.muted),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AgrosafeTheme.moss),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AgrosafeTheme.border),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return l10n.needConfirm; // Vérifie que le champ de saisie de confirmation du mot de passe n'est pas vide
                      if (value != _passwordController.text) return l10n.mdpMismatch; // Vérifie que la confirmation du mot de passe correspond au mot de passe saisi en comparant la valeur saisie dans le champ de confirmation du mot de passe avec la valeur saisie dans le champ de mot de passe
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16), // Espace entre la partie de confirmation du mot de passe et la partie de choix du profil

                // ------- PARTIE CHOIX DU PROFIL -------
                RegisterCard(
                  label: l10n.profilPref, // Titre de la partie
                  context: context, // Contexte pour la construction de la carte de saisie
                  field: Theme( // Permet de personnaliser le thème du champ de saisie du choix du profil pour changer la couleur de fond du menu déroulant et des éléments sélectionnés pour qu'ils soient cohérents avec le thème de l'application
                    data: Theme.of(context).copyWith(
                      canvasColor: AgrosafeTheme.cream,
                    ),
                    // Menu déroulant pour le choix du profil avec validation pour vérifier qu'un profil est sélectionné avant de soumettre les données d'inscription
                    child: DropdownButtonFormField<String>( 
                      initialValue: _selectedRole, // Valeur sélectionnée dans le menu déroulant pour le choix du profil pour pouvoir accéder à cette valeur lors de la validation du formulaire et de la soumission des données d'inscription pour inclure le rôle sélectionné dans les données d'inscription soumises au service d'authentification
                      // Style du menu déroulant
                      dropdownColor: AgrosafeTheme.cream,
                      style: const TextStyle(color: AgrosafeTheme.moss),
                      iconDisabledColor: AgrosafeTheme.moss,
                      iconEnabledColor: AgrosafeTheme.moss,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: l10n.profilChoix,
                        labelStyle: const TextStyle(color: AgrosafeTheme.muted),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AgrosafeTheme.moss),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AgrosafeTheme.border),
                        ),
                      ),
                      // Liste des options du menu déroulant pour le choix du profil avec les rôles disponibles (agriculteur et gestionnaire)
                      items: [
                        DropdownMenuItem(value: l10n.agri, child: Text(l10n.agriculteur)), // Rôle de l'agriculteur (module 1)
                        DropdownMenuItem(value: l10n.gestionnaire, child: Text(l10n.gestionnaire)), // Rôle du gestionnaire de stockage (module 2)
                      ],
                      onChanged: (value) => setState(() => _selectedRole = value), // Action du menu déroulant pour le choix du profil pour mettre à jour la variable _selectedRole avec la valeur sélectionnée dans le menu déroulant pour pouvoir inclure ce rôle dans les données d'inscription
                      validator: (value) {
                        if (value == null) return l10n.profilChoix; // Vérifie qu'un profil est sélectionné dans le menu déroulant pour le choix du profil avant de soumettre les données d'inscription
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Espace entre la partie de choix du profil et le bouton de validation

                // ------- BOUTON VALIDER -------
                Align( // Alignement du bouton de validation à droite de l'écran pour suivre la convention d'alignement des boutons d'action dans les interfaces utilisateur
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 160, // Taille du bouton
                    child: ElevatedButton(
                      style: AgrosafeTheme.primaryLightButtonStyle, // Style du bouton
                      onPressed: () async { // Action du bouton
                        if (_formKey.currentState!.validate()) { // Vérifie que tous les champs de saisie du formulaire d'inscription sont valides avant de soumettre les données d'inscription pour éviter les erreurs d'inscription
                          setState(() => _isLoading = true); // Met à jour la variable _isLoading pour afficher un indicateur de chargement pendant que les données d'inscription sont traitées et éviter les interactions multiples avec le formulaire pendant ce temps
                          final messenger = ScaffoldMessenger.of(context); // Permet d'afficher des messages à l'utilisateur (comme les erreurs d'inscription) en utilisant un SnackBar pour informer l'utilisateur de ce qui se passe pendant le processus d'inscription
                          final navigator = Navigator.of(context); // Permet de naviguer vers l'écran principal de l'application après une inscription réussie en utilisant pushReplacement pour remplacer l'écran d'inscription par l'écran principal dans la pile de navigation pour éviter que l'utilisateur puisse revenir à l'écran d'inscription avec le bouton de retour du système après s'être inscrit
                          final error = await _authService.register( // Appelle la fonction d'inscription du service d'authentification avec les données saisies dans le formulaire d'inscription pour créer un compte utilisateur avec ces données et récupérer une éventuelle erreur d'inscription pour l'afficher à l'utilisateur si l'inscription échoue
                            _emailController.text.trim(), // Récupère la valeur saisie dans le champ de saisie de l'email, supprime les espaces inutiles au début et à la fin de l'email pour éviter les erreurs d'inscription dues à des espaces accidentels dans l'email
                            _passwordController.text, // Récupère la valeur saisie dans le champ de saisie du mot de passe pour l'inclure dans les données d'inscription soumises au service d'authentification pour créer un compte utilisateur avec ce mot de passe
                            _selectedRole!, // Récupère la valeur sélectionnée dans le menu déroulant pour le choix du profil pour l'inclure dans les données d'inscription soumises au service d'authentification pour créer un compte utilisateur avec ce rôle spécifique
                          );
                          setState(() => _isLoading = false); // Met à jour la variable _isLoading pour masquer l'indicateur de chargement après que les données d'inscription ont été traitées
                          if (!mounted) return; // Vérifie que le widget est toujours monté avant d'afficher un message ou de naviguer vers un autre écran pour éviter les erreurs d'affichage ou de navigation si l'utilisateur a quitté l'écran d'inscription pendant que les données d'inscription étaient en cours de traitement
                          if (error != null) { // Si une erreur d'inscription a été retournée par le service d'authentification, affiche un message d'erreur à l'utilisateur avec un SnackBar pour l'informer de ce qui s'est mal passé pendant le processus d'inscription
                            messenger.showSnackBar(
                              SnackBar(content: Text(error), backgroundColor: AgrosafeTheme.danger),
                            );
                          } else { // Pas d'erreur, on navigue vers l'écran principal de l'application pour que l'utilisateur puisse commencer à utiliser l'application après s'être inscrit
                            navigator.pushReplacement(
                              MaterialPageRoute(builder: (context) => const MainScreen()),
                            );
                          }
                        }
                      },
                      child: _isLoading // Si les données d'inscription sont en cours de traitement, affiche un indicateur de chargement dans le bouton pour informer l'utilisateur que le processus d'inscription est en cours et éviter les interactions multiples avec le bouton pendant ce temps. Sinon, affiche le texte "Valider" pour indiquer à l'utilisateur que c'est le bouton pour soumettre les données d'inscription.
                          ? const CircularProgressIndicator(color: AgrosafeTheme.white)
                          : Text(l10n.valider),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}