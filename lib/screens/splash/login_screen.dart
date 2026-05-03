// Importation des bibliothèques nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/app_notifiers.dart'; // pour accéder aux variables de préférences de l'application
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/core/services/auth_service.dart'; // pour accéder au service d'authentification pour la connexion et la réinitialisation du mot de passe
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour la traduction des textes
import 'package:avocadoguard/main.dart'; // pour accéder à l'écran principal de l'application après la connexion réussie de l'utilisateur
import 'package:avocadoguard/screens/splash/register_screen.dart'; // pour accéder à l'écran d'inscription de l'application pour permettre à l'utilisateur de créer un compte


class LoginScreen extends StatefulWidget {
  // Classe permettant de configurer l'affichage de l'écran de connexion de l'application
  const LoginScreen({super.key}); // Constructeur de la classe

  @override
  State<LoginScreen> createState() => _LoginScreenState(); // Création de l'état mutable de la classe
}

class _LoginScreenState extends State<LoginScreen> {
  // Classe permettant de gérer l'affichage de l'écran de connexion de l'application et les interactions de l'utilisateur avec cet écran
  bool _isPasswordHidden = true; // Variable pour gérer l'affichage du mot de passe saisi dans le champ de saisie du mot de passe (masqué par défaut pour la sécurité)
  final _formKey = GlobalKey<FormState>(); // Clé pour gérer l'état du formulaire de connexion et permettre la validation des champs de saisie avant de soumettre les données de connexion au service d'authentification
  final _emailController = TextEditingController(); // Contrôleur pour gérer la saisie de l'email de l'utilisateur dans le champ de saisie de l'email pour pouvoir accéder à cette valeur lors de la validation du formulaire et de la soumission des données de connexion au service d'authentification
  final _passwordController = TextEditingController(); // Contrôleur pour gérer la saisie du mot de passe de l'utilisateur dans le champ de saisie du mot de passe pour pouvoir accéder à cette valeur lors de la validation du formulaire et de la soumission des données de connexion au service d'authentification
  final _authService = AuthService(); // Instance du service d'authentification pour pouvoir appeler les méthodes de connexion et de réinitialisation du mot de passe lors des interactions de l'utilisateur avec l'écran de connexion
  bool _isLoading = false; // Variable pour gérer l'état de chargement lors de la soumission des données de connexion au service d'authentification pour afficher un indicateur de chargement dans le bouton de connexion et éviter les interactions multiples avec ce bouton pendant le traitement de la connexion

  @override
  void dispose() {
    // Fonction pour nettoyer les ressources utilisées par les contrôleurs de saisie de l'email et du mot de passe lorsque le widget de l'écran de connexion est supprimé de l'arbre des widgets pour éviter les fuites de mémoire
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ------ BOÎTE DE DIALOGUE RÉINITIALISATION MOT DE PASSE ------
  void _showResetPasswordDialog(BuildContext context) {
  // Fonction pour afficher une boîte de dialogue de réinitialisation du mot de passe lorsque l'utilisateur clique sur le lien "Mot de passe oublié ?" pour permettre à l'utilisateur de saisir son email et recevoir un email de réinitialisation du mot de passe si l'email est associé à un compte dans le service d'authentification
  final emailController = TextEditingController();
  final messenger = ScaffoldMessenger.of(context);
  showDialog( // Affiche une boîte de dialogue pour la réinitialisation du mot de passe avec un champ de saisie pour l'email et des boutons pour annuler ou envoyer la demande de réinitialisation du mot de passe
    context: context,
    builder: (context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.motDePasseOublie), // Titre de la boîte de dialogue
      content: TextFormField( // Formulaireire pour saisir l'email de l'utilisateur pour la réinitialisation du mot de passe
        controller: emailController,
        // Style du champ de saisie de l'email dans la boîte de dialogue
        decoration: InputDecoration(
          labelText: l10n.email,
          border: const UnderlineInputBorder(),
        ),
      ),
      // Action des 2 boutons (annluler et valider)
      actions: [
        // Bouton 'Annuler' pour fermer la boîte de dialogue sans envoyer la demande de réinitialisation du mot de passe
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.annuler),
        ),
        // Bouton 'Envoyer'
        ElevatedButton(
          style: AgrosafeTheme.primaryButtonStyle, // Style du bouton
          // Action du bouton
          onPressed: () async {
            // Appelle la méthode de réinitialisation du mot de passe du service d'authentification avec l'email saisi dans le champ de saisie de la 
            // boîte de dialogue pour envoyer un email de réinitialisation du mot de passe à l'utilisateur si l'email est associé à un compte dans le 
            //service d'authentification, et récupérer une éventuelle erreur pour afficher un message à l'utilisateur
            final navigator = Navigator.of(context);
            final error = await _authService.resetPassword( 
              emailController.text.trim(),
            );
            navigator.pop(); // Ferme la boîte de dialogue après l'envoi de la demande de réinitialisation du mot de passe
            // Si une erreur est retournée par le service d'authentification lors de la tentative d'envoi de l'email de réinitialisation du mot de passe, affiche un message d'erreur à l'utilisateur dans un SnackBar
            if (error != null) { 
              messenger.showSnackBar(
                SnackBar(
                  content: Text(error),
                  backgroundColor: AgrosafeTheme.danger,
                ),
              );
            } 
            // Sinon, affiche un message de succès indiquant que l'email de réinitialisation du mot de passe a été envoyé.
            else {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(l10n.emailReinitialisation),
                  backgroundColor: AgrosafeTheme.safe,
                ),
              );
            }
          },
          child: Text(l10n.envoyer), // Texte du bouton
        ),
      ],
    );
    }
  );
  }

  @override
  Widget build(BuildContext context) {
    // Widget pour configurer l'affichage de l'écran de connexion
    final l10n = AppLocalizations.of(context)!; // pour la traduction des textes
    return Scaffold(
      backgroundColor: AgrosafeTheme.cream,
      body: SafeArea(
      child: SingleChildScrollView( // permet de scroller sur l'écran de connexion si le contenu dépasse la taille de l'écran
        padding: const EdgeInsets.symmetric( // Marge interne de la page
          horizontal: AgrosafeTheme.screenHorizontalPadding,
          vertical: 20,
        ),
        child: Form( // Formulaire pour gérer la validation des champs de saisie de l'email et du mot de passe avant de soumettre les données de connexion au service d'authentification
          key: _formKey, // Clé du formulaire pour gérer son état et permettre la validation des champs de saisie
          child: Column( // Alignement vertical des éléments de l'écran de connexion
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Affichage du titre de la page et son style au centre de l'écran
              Center(
                child: Text(
                  l10n.connexion,
                  style: AgrosafeTheme.displayTitle.copyWith(color: AgrosafeTheme.moss),
                ),
              ),
              // ------ BOUTONS DE LANGUE ------
              Align(
                alignment: Alignment.centerRight,  // Alignement à droite
                child: ValueListenableBuilder<Locale>(
                  valueListenable: localeNotifier,
                  builder: (context, locale, _) {
                    return Row( // Permet de mettre les boutons de langue l'un à côté de l'autre
                      mainAxisSize: MainAxisSize.min, // pour ne pas prendre toute la largeur disponible
                      children: [
                        // Action du bouton français
                        GestureDetector(
                          onTap: () => localeNotifier.value = const Locale('fr'), // Valeur de la variable locale de langue
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Taille du bouton
                            decoration: BoxDecoration( // Style du bouton
                              color: locale.languageCode == 'fr' ? AgrosafeTheme.leaf : AgrosafeTheme.cream,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AgrosafeTheme.leaf),
                            ),
                            // Texte du bouton français et son style
                            child: Text('🇫🇷 FR',
                                style: TextStyle(
                                  color: locale.languageCode == 'fr' ? AgrosafeTheme.white : AgrosafeTheme.leaf,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                        ),
                        const SizedBox(width: 8), // Espace entre les deux boutons de langue
                        // Action du bouton anglais
                        GestureDetector(
                          onTap: () => localeNotifier.value = const Locale('en'), // valeur de la variable locale de langue
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Taille du bouton
                            decoration: BoxDecoration( // Style du bouton
                              color: locale.languageCode == 'en' ? AgrosafeTheme.leaf : AgrosafeTheme.cream,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AgrosafeTheme.leaf),
                            ),
                            // Texte du bouton anglais et son style
                            child: Text('🇬🇧 EN',
                                style: TextStyle(
                                  color: locale.languageCode == 'en' ? AgrosafeTheme.white : AgrosafeTheme.leaf,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 100), // Espace entre les boutons de langue et le formulaire de connexion

              // ------- PARTIE EMAIL -------
              Row(
                children: [
                  Expanded(
                    // Titre la partie et son style
                    child: Text(
                      l10n.email,
                      style: AgrosafeTheme.bodyText.copyWith(
                        color: AgrosafeTheme.moss,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15), // Espace entre le titre de la partie et le champ de saisie de l'email
                  Expanded(
                    // Champ de saisie de l'email
                    child: TextFormField(
                      controller: _emailController,
                      cursorColor: AgrosafeTheme.moss,
                      // Style du champ de saisie de l'email
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: l10n.emailEntre,
                        labelStyle:const TextStyle(color: AgrosafeTheme.muted),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:BorderSide(color:AgrosafeTheme.moss),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AgrosafeTheme.border),
                        )
                      ),
                      style:const TextStyle(color: AgrosafeTheme.moss),
                      validator: (value) {
                        if (value == null || value.isEmpty) { // Vérifie que le champ de saisie de l'email n'est pas vide
                          return l10n.needEmail;
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$') // Vérifie que le format de l'email saisi est valide en utilisant une expression régulière pour valider le format de l'email
                            .hasMatch(value)) {
                          return l10n.invalidEmail;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Espace entre la partie de saisie de l'email et celle de saisie du mot de passe

              // ------- PARTIE MOT DE PASSE -------
              Row(
                children: [
                  Expanded(
                    // Titre la partie et son style
                    child: Text(
                      l10n.motDePasse,
                      style: AgrosafeTheme.bodyText.copyWith(
                        color: AgrosafeTheme.moss,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15), // Espace entre le titre de la partie et le champ de saisie du mot de passe
                  Expanded(
                    // Champ de saisie du mot de passe avec un bouton pour afficher ou masquer le mot de passe saisi pour permettre à l'utilisateur de vérifier le mot de passe qu'il a saisi s'il le souhaite, tout en gardant le mot de passe masqué par défaut pour la sécurité
                    child: TextFormField(
                      controller: _passwordController, 
                      cursorColor: AgrosafeTheme.moss,
                      obscureText: _isPasswordHidden, // Permet de masquer ou d'afficher le mot de passe saisi en fonction de la valeur de la variable _isPasswordHidden qui est modifiée par le bouton d'affichage du mot de passe
                      // Style du champ de saisie du mot de passe avec un bouton d'affichage du mot de passe intégré dans le champ de saisie pour permettre à l'utilisateur d'afficher ou de masquer le mot de passe saisi
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            color:AgrosafeTheme.moss,
                            _isPasswordHidden // Icône modifiée si mot de passe visible ou masqué
                                ? Icons.visibility_off // Mot de passe masqué : icône d'œil barré
                                : Icons.visibility, // Mot de passe visible : icône d'œil
                          ),
                          // Action de l'icône
                          onPressed: () => setState(
                              () => _isPasswordHidden = !_isPasswordHidden),
                        ),
                        border: const UnderlineInputBorder(),
                        labelText: l10n.mdpEntre,
                        labelStyle: const TextStyle(color: AgrosafeTheme.muted),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AgrosafeTheme.moss),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AgrosafeTheme.border)),
                      ),
                      style: const TextStyle(color:AgrosafeTheme.moss),
                      validator: (value) {
                        if (value == null || value.isEmpty) { // Vérifie que le champ de saisie du mot de passe n'est pas vide
                          return l10n.confirmationMdp;
                        }
                        if (value.length < 6) { // Vérifie que le mot de passe saisi contient au moins 6 caractères
                          return 'Minimum 6 caractères';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Espace entre la partie de saisie du mot de passe et le bouton de connexion

              // ------- BOUTON CONNEXION -------
              Align(
                alignment: Alignment.centerRight, // Alignement du bouton de connexion à droite de l'écran pour suivre la convention d'alignement des boutons d'action dans les interfaces utilisateur
                child: SizedBox(
                  width: 160, // Taille du bouton de connexion
                  child: ElevatedButton(
                    style: AgrosafeTheme.primaryLightButtonStyle, // Style du bouton de connexion
                    // Action du bouton de connexion
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Si le formulaire de connexion est valide (les champs de saisie de l'email et du mot de passe sont correctement remplis), 
                        // soumet les données de connexion au service d'authentification pour tenter de connecter l'utilisateur, et gérer l'état de chargement pendant
                        // le traitement de la connexion pour afficher un indicateur de chargement dans le bouton et éviter les interactions multiples avec ce bouton
                        // pendant ce temps
                        setState(() => _isLoading = true);
                        final messenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);
                        final error = await _authService.login(
                          _emailController.text.trim(),
                          _passwordController.text,
                        );
                        setState(() => _isLoading = false);
                        if (!mounted) return; // Vérifie que le widget est toujours monté avant d'afficher un message ou de naviguer vers l'écran principal pour éviter les erreurs si l'utilisateur a quitté l'écran de connexion pendant le traitement de la connexion
                        if (error != null) {
                          // Affiche le message d'erreur dans un SnackBar s'il y en a un
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(error),
                              backgroundColor: AgrosafeTheme.danger,
                            ),
                          );
                        } 
                        // Sinon, on navigue vers l'écran principal de l'application pour que l'utilisateur puisse commencer à utiliser l'application après s'être connecté avec succès
                        else {
                          navigator.pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ),
                          );
                        }
                      }
                    },
                    // Si les données de connexion sont en cours de traitement, affiche un indicateur de chargement dans le bouton pour informer
                    // l'utilisateur que le processus de connexion est en cours et éviter les interactions multiples avec le bouton pendant ce temps.
                    // Sinon, affiche le texte "Connexion" pour indiquer à l'utilisateur que c'est le bouton pour soumettre les données de connexion.
                    child: _isLoading 
                        ? const CircularProgressIndicator(
                            color: AgrosafeTheme.white,
                          )
                        : Text(l10n.connexion),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espace entre le bouton de connexion et le lien "Mot de passe oublié ?"

              // ------- LIEN MOT DE PASSE OUBLIE -------
              // Action du lien
              GestureDetector(
                onTap: () => _showResetPasswordDialog(context),
                child: Text(
                  l10n.motDePasseOublie, // Texte du lien et son style
                  style: AgrosafeTheme.bodyText.copyWith(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espace entre le lien "Mot de passe oublié ?" et le lien "Créer un compte"

              // ------- LIEN CRÉATION COMPTE -------
              InkWell( // Bouton sur le texte
                // Action du lien pour naviguer vers la page de création de compte
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                // Texte du lien et son style
                child: Text(
                  l10n.creerCompte,
                  style: AgrosafeTheme.bodyText.copyWith(
                    color: AgrosafeTheme.moss,
                    fontWeight: FontWeight.w700,
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