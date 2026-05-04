// Importations des bibliothèques
import 'package:firebase_auth/firebase_auth.dart'; // pour accéder à l'authentification Firebase
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/services/auth_service.dart'; // pour accéder aux services d'authentification
import 'package:avocadoguard/core/services/user_service.dart'; // pour accéder aux services de gestion des utilisateurs
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour la traduction des textes
import 'package:avocadoguard/widgets/bottom_nav.dart'; // pour afficher la barre de navigation en bas de l'écran

class UserScreen extends StatefulWidget {
  // Classe permettant de configurer la page permettant de gérer les données de l'utilisateur
  final Function(int) onNavigate; // permet de naviguer vers les différentes pages

  const UserScreen({
    // Constructeur de la classe
    super.key,
    required this.onNavigate,
  });

  @override
  // Permet d'avoir l'état mutable de la classe UserScreen pour pouvoir modifier les données de l'utilisateur
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  // Classe permettant de gérer l'affichage de la page utilisateur et de modifier les données de l'utilisateur
  final _authService = AuthService(); // Instance du service d'authentification pour gérer les actions liées à l'authentification

  // Email
  bool _isEditingEmail = false; // Permet de savoir si l'utilisateur est en train de modifier son email pour afficher les champs et boutons correspondants
  late TextEditingController _emailController; // Contrôleur pour gérer le champ de texte de l'email

  // Profil (rôle)
  String? _roleKey; // Clé du rôle de l'utilisateur pour gérer la sélection du rôle dans le dropdown
  String? _selectedRole; // Rôle sélectionné dans le dropdown pour pouvoir le sauvegarder

  @override
  // Permet d'initialiser les données de la page utilisateur au lancement de la page
  void initState() {
    super.initState();
    // Initialise le champ de texte de l'email avec l'email de l'utilisateur connecté ou une chaîne vide si aucun utilisateur n'est connecté
    _emailController = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.email ?? '',
    );
    // Charge les données du profil de l'utilisateur
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    // Permet de charger les données du profil de l'utilisateur pour afficher son rôle et le sélectionner dans le dropdown
    final data = await UserService.getUserProfile(); // Récupère les données du profil de l'utilisateur depuis le service de gestion des utilisateurs
    setState(() { // Met à jour l'état de la page utilisateur avec les données du profil de l'utilisateur
      _roleKey = data?['role']; // Récupère la clé du rôle de l'utilisateur depuis les données du profil
      _selectedRole = _roleKey; // Initialise le rôle sélectionné dans le dropdown avec la clé du rôle de l'utilisateur pour afficher le rôle actuel de l'utilisateur dans le dropdown
    });
  }

  @override
  void dispose() {
    // Fonction permettant de libérer les ressources utilisées par le champ de texte de l'email lorsque la page utilisateur est détruite
    _emailController.dispose(); // Libère les ressources utilisées par le champ de texte de l'email
    super.dispose(); // Appelle la fonction dispose de la classe parente pour s'assurer que toutes les ressources sont correctement libérées
  }

  @override
  Widget build(BuildContext context) {
    // Widget permettant de configurer l'affichage de la page utilisateur
    final l10n = AppLocalizations.of(context)!; // permet de changer la langue des textes
    return Scaffold(
      backgroundColor: AgrosafeTheme.bg(),
      appBar: AppBar(
        backgroundColor: AgrosafeTheme.bg(),
        elevation: 0,
        // Affichage du bouton de retour et son style
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AgrosafeTheme.textPrimary()),
          onPressed: () => Navigator.pop(context),
        ),
        // Titre de la page utilisateur et son style
        title: Text(
          l10n.userScreenTitle,
          style: AgrosafeTheme.displayTitle.copyWith(color: AgrosafeTheme.textPrimary()),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView( // Permet de scroller sur la page si le contenu dépasse la taille de l'écran
          padding: const EdgeInsets.symmetric( // Marge interne de la page
            horizontal: AgrosafeTheme.screenHorizontalPadding,
            vertical: 20,
          ),
          child: Column( // Alignement vertical des éléments de la page
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ------ AFFICHAGE CHAMP DE L'EMAIL ------
              _buildEmailRow(l10n), // Affichage du champ de l'email avec les boutons de modification et de sauvegarde correspondants
              const SizedBox(height: 48), // Espace entre le champ de l'email et le champ du mot de passe

              // ------ AFFICHAGE CHAMP DU MOT DE PASSE ------
              _buildPasswordRow(l10n), // Affichage du champ du mot de passe avec le bouton de réinitialisation correspondant
              const SizedBox(height: 48), // Espace entre le champ du mot de passe et le champ du profil

              // ------ AFFICHAGE CHAMP DU PROFIL ------
              _buildProfileRow(l10n), // Affichage du champ du profil avec le dropdown de sélection du rôle et le bouton de sauvegarde correspondant
            ],
          ),
        ),
      ),
      // Affichage de la barre de navigation en bas de l'écran avec la page profil sélectionnée
      bottomNavigationBar: AgrosafeBottomNav(
        selectedIndex: 2, // Index de la page profil sélectionnée dans la barre de navigation
        // Action à effectuer lorsque l'utilisateur sélectionne une destination dans la barre de navigation pour naviguer vers la page correspondante
        onDestinationSelected: (index) {
          Navigator.pop(context);
          widget.onNavigate(index);
        },
      ),
    );
  }

  // ------ EMAIL ------
  Widget _buildEmailRow(AppLocalizations l10n) {
    // Widget permettant de configurer l'affichage du champ de l'email avec les boutons de modification et de sauvegarde correspondants
    return Column( // Alignement vertical des éléments du champ de l'email
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de la section et son style
        Text(l10n.email2,
          style: AgrosafeTheme.displayTitle.copyWith(
            color: AgrosafeTheme.textPrimary(),
            fontSize: 24
          )
        ),
        const SizedBox(height: 8), // Espace entre le titre de la section et les éléments du champ de l'email
        Align( // Permet d'aligner les boutons de modification et de sauvegarde à droite du champ de l'email
          alignment: Alignment.centerRight,  // Bouton à droite
          child: !_isEditingEmail // Affiche le bouton de modification si l'utilisateur n'est pas en train de modifier son email, sinon affiche les boutons de sauvegarde et d'annulation
            ? OutlinedButton( // Bouton de modification de l'email avec son action et son style
                onPressed: () => setState(() => _isEditingEmail = true), // Action du bouton de modification pour passer en mode édition
                style: OutlinedButton.styleFrom( // Style du bouton de modification
                  backgroundColor: AgrosafeTheme.iconeColor(),
                  foregroundColor: AgrosafeTheme.bg(),
                  side: BorderSide(color: AgrosafeTheme.borderColor()),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AgrosafeTheme.radiusButtons)
                  ),
                ),
                child: Text(l10n.modifier), // Texte du bouton de modification
              )
            : Row( // Permet d'afficher les boutons de sauvegarde et d'annulation côte à côte lorsque l'utilisateur est en train de modifier son email
                mainAxisAlignment: MainAxisAlignment.end,  // Boutons à droite
                children: [
                  OutlinedButton( // Bouton d'annulation de la modification de l'email avec son action et son style
                    onPressed: () => setState(() => _isEditingEmail = false), // Action du bouton d'annulation pour quitter le mode édition sans sauvegarder les modifications
                    style: OutlinedButton.styleFrom( // Style du bouton d'annulation
                      foregroundColor: AgrosafeTheme.textMuted(),
                      side: BorderSide(color: AgrosafeTheme.borderColor()),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AgrosafeTheme.radiusButtons)
                      ),
                    ),
                    child: Text(l10n.annuler), // Texte du bouton d'annulation
                  ),
                  const SizedBox(width: 8), // Espace entre les boutons de sauvegarde et d'annulation
                  ElevatedButton( // Bouton de sauvegarde de la modification de l'email avec son action et son style
                    onPressed: () async { // Action du bouton de sauvegarde pour enregistrer les modifications de l'email
                      final messenger = ScaffoldMessenger.of(context); // Permet d'afficher des messages à l'utilisateur (succès ou erreur) après la tentative de modification de l'email
                      final error = await _authService.updateEmail(_emailController.text.trim()); // Appelle la fonction de mise à jour de l'email du service d'authentification avec le nouvel email saisi par l'utilisateur et récupère une éventuelle erreur
                      if (!mounted) return; // Vérifie que le widget est toujours monté avant d'afficher un message ou de mettre à jour l'état pour éviter les erreurs si l'utilisateur a quitté la page
                      if (error != null) { // Si une erreur est survenue lors de la tentative de modification de l'email, affiche un message d'erreur à l'utilisateur
                        messenger.showSnackBar(SnackBar(content: Text(error), backgroundColor: AgrosafeTheme.danger));
                      } else { // Si la modification de l'email a réussi, affiche un message de succès à l'utilisateur et quitte le mode édition
                        messenger.showSnackBar(SnackBar(content: Text(l10n.emailVerification), backgroundColor: AgrosafeTheme.safe));
                        setState(() => _isEditingEmail = false);
                      }
                    },
                    style: ElevatedButton.styleFrom( // Style du bouton de sauvegarde
                      backgroundColor: AgrosafeTheme.leaf,
                      foregroundColor: AgrosafeTheme.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AgrosafeTheme.radiusButtons)),
                    ),
                    child: Text(l10n.sauvegarder), // Texte du bouton de sauvegarde
                  ),
                ],
              ),
        ),
        const SizedBox(height: 10), // Espace entre les boutons de modification/sauvegarde et le champ de l'email
        TextFormField( // Champ de texte pour saisir l'email avec sa configuration et son style
          controller: _emailController, // Contrôleur pour gérer le champ de texte de l'email et récupérer la valeur saisie par l'utilisateur
          enabled: _isEditingEmail, // Active ou désactive le champ de l'email en fonction du mode édition pour permettre ou empêcher la saisie
          cursorColor: AgrosafeTheme.moss, // Couleur du curseur de saisie dans le champ de l'email
          style: TextStyle(color: AgrosafeTheme.textPrimary()), // Style du texte saisi dans le champ de l'email
          decoration: InputDecoration( // Configuration du champ de l'email avec son style
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AgrosafeTheme.borderColor())), // Bordure du champ de l'email lorsqu'il est activé
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AgrosafeTheme.moss)), // Bordure du champ de l'email lorsqu'il est sélectionné
            disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AgrosafeTheme.borderColor())), // Bordure du champ de l'email lorsqu'il est désactivé
            filled: true, // Permet de remplir le champ de l'email avec une couleur de fond
            fillColor: AgrosafeTheme.cardBg(), // Couleur de fond du champ de l'email
          ),
        ),
      ],
    );
  }

  // ------ Mot de passe ------
  Widget _buildPasswordRow(AppLocalizations l10n) {
    // Widget permettant de configurer l'affichage du champ du mot de passe avec le bouton de réinitialisation correspondant
    return Column( // Alignement vertical des éléments du champ du mot de passe
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de la section et son style
        Text(l10n.motDePasse2,
          style: AgrosafeTheme.displayTitle.copyWith(
            color: AgrosafeTheme.textPrimary(),
            fontSize: 24
          )
        ),
        const SizedBox(height: 8), // Espace entre le titre de la section et les éléments du champ du mot de passe
        Align( // Permet d'aligner le bouton de réinitialisation à droite du champ du mot de passe
          alignment: Alignment.centerRight, // Bouton à droite
          child: OutlinedButton( // Bouton de réinitialisation du mot de passe avec son action et son style
            onPressed: () async { // Action du bouton de réinitialisation pour envoyer un email de réinitialisation du mot de passe à l'utilisateur
              final messenger = ScaffoldMessenger.of(context); // Permet d'afficher des messages à l'utilisateur (succès ou erreur) après la tentative de réinitialisation du mot de passe
              final email = FirebaseAuth.instance.currentUser?.email ?? ''; // Récupère l'email de l'utilisateur connecté pour envoyer l'email de réinitialisation du mot de passe, ou une chaîne vide si aucun utilisateur n'est connecté
              final error = await _authService.resetPassword(email); // Appelle la fonction de réinitialisation du mot de passe du service d'authentification avec l'email de l'utilisateur et récupère une éventuelle erreur
              if (!mounted) return; // Vérifie que le widget est toujours monté avant d'afficher un message pour éviter les erreurs si l'utilisateur a quitté la page
              messenger.showSnackBar(SnackBar( // Affiche un message de succès ou d'erreur à l'utilisateur en fonction du résultat de la tentative de réinitialisation du mot de passe
                content: Text(error ?? l10n.emailReinitialisation),
                backgroundColor: error != null ? AgrosafeTheme.danger : AgrosafeTheme.safe, // Couleur du message en fonction du résultat (vert pour le succès, rouge pour l'erreur)
              ));
            },
            style: OutlinedButton.styleFrom( // Style du bouton de réinitialisation du mot de passe
              backgroundColor: AgrosafeTheme.iconeColor(),
              foregroundColor: AgrosafeTheme.bg(),
              side: BorderSide(color: AgrosafeTheme.borderColor()),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AgrosafeTheme.radiusButtons)
              ),
            ),
            child: Text(l10n.reinitialiserMdp), // Texte du bouton de réinitialisation du mot de passe
          ),
        ),
        const SizedBox(height: 10), // Espace entre le bouton de réinitialisation et le champ du mot de passe
        TextFormField( // Champ de texte pour afficher le mot de passe avec sa configuration et son style
          enabled: false, // Désactive le champ du mot de passe pour empêcher la saisie, car le mot de passe ne peut pas être modifié directement depuis la page utilisateur
          obscureText: true, // Masque le texte saisi dans le champ du mot de passe pour afficher des points à la place des caractères
          initialValue: '••••••••', // Valeur initiale du champ du mot de passe pour indiquer qu'un mot de passe est défini, sans afficher le mot de passe réel
          style: TextStyle(color: AgrosafeTheme.textMuted()), // Style du texte dans le champ du mot de passe pour le différencier du texte saisi dans les autres champs (couleur plus claire)
          decoration: InputDecoration( // Configuration du champ du mot de passe avec son style
            border: const OutlineInputBorder(),
            disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AgrosafeTheme.borderColor())),
            filled: true, // Permet de remplir le champ du mot de passe avec une couleur de fond
            fillColor: AgrosafeTheme.cardBg(), // Couleur de fond du champ du mot de passe
          ),
        ),
      ],
    );
  }

  // ------ Profil ------
  Widget _buildProfileRow(AppLocalizations l10n) {
    // Widget permettant de configurer l'affichage du champ du rôle avec le bouton de sauvegarde correspondant
    return Column( // Alignement vertical des éléments du champ du rôle
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de la section et son style
        Text(l10n.profil,
          style: AgrosafeTheme.displayTitle.copyWith(
            color: AgrosafeTheme.textPrimary(),
            fontSize: 24
          )
        ),
        const SizedBox(height: 10), // Espace entre le titre de la section et les éléments du champ du rôle
        Theme( // Permet de configurer le thème du dropdown de sélection du rôle pour lui appliquer les couleurs du thème de l'application
          data: Theme.of(context).copyWith(canvasColor: AgrosafeTheme.bg()),
          child: DropdownButtonFormField<String>( // Dropdown de sélection du rôle de l'utilisateur avec sa configuration et son style
            initialValue: _selectedRole, // Valeur initiale du dropdown pour afficher le rôle actuel de l'utilisateur
            dropdownColor: AgrosafeTheme.bg(), // Couleur de fond du dropdown
            style: TextStyle(color: AgrosafeTheme.textPrimary()), // Style du texte des éléments du dropdown
            iconEnabledColor: AgrosafeTheme.textMuted(), // Couleur de l'icône du dropdown
            decoration: InputDecoration( // Configuration du champ du dropdown avec son style
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AgrosafeTheme.borderColor())), // Bordure du champ du dropdown lorsqu'il est activé
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AgrosafeTheme.moss)), // Bordure du champ du dropdown lorsqu'il est sélectionné
              filled: true, // Permet de remplir le champ du dropdown avec une couleur de fond
              fillColor: AgrosafeTheme.cardBg(), // Couleur de fond du champ du dropdown
            ),
            items: [ // Liste des éléments du dropdown pour les différents rôles disponibles, avec leur traduction
              DropdownMenuItem(value: 'agriculteur', child: Text(l10n.agriculteur)),
              DropdownMenuItem(value: 'gestionnaire', child: Text(l10n.gestionnaire)),
            ],
            onChanged: (value) => setState(() => _selectedRole = value), // Action lorsque l'utilisateur sélectionne un rôle dans le dropdown pour mettre à jour le rôle sélectionné
          ),
        ),
        const SizedBox(height: 12), // Espace entre le dropdown de sélection du rôle et le bouton de sauvegarde
        Align( // Permet d'aligner le bouton de sauvegarde à droite du champ du rôle
          alignment: Alignment.centerRight,
          child: ElevatedButton( // Bouton de sauvegarde de la modification du rôle avec son action et son style
            onPressed: () async { // Action du bouton de sauvegarde pour enregistrer les modifications du rôle de l'utilisateur
              if (_selectedRole == null) return; // Vérifie qu'un rôle est sélectionné avant de tenter de sauvegarder les modifications, sinon ne fait rien
              final messenger = ScaffoldMessenger.of(context); // Permet d'afficher des messages à l'utilisateur (succès ou erreur) après la tentative de modification du rôle de l'utilisateur
              final error = await UserService.updateRole(_selectedRole!); // Appelle la fonction de mise à jour du rôle de l'utilisateur du service de gestion des utilisateurs avec le rôle sélectionné et récupère une éventuelle erreur
              if (!mounted) return; // Vérifie que le widget est toujours monté avant d'afficher un message ou de mettre à jour l'état pour éviter les erreurs si l'utilisateur a quitté la page
              messenger.showSnackBar(SnackBar( // Affiche un message de succès ou d'erreur à l'utilisateur en fonction du résultat de la tentative de modification du rôle de l'utilisateur
                content: Text(error ?? l10n.profilSauvegarde),
                backgroundColor: error != null ? AgrosafeTheme.danger : AgrosafeTheme.safe, // Couleur du message en fonction du résultat (vert pour le succès, rouge pour l'erreur)
              ));
              if (error == null) setState(() => _roleKey = _selectedRole); // Si la modification du rôle de l'utilisateur a réussi, met à jour la clé du rôle de l'utilisateur dans l'état pour afficher le nouveau rôle dans la carte de profil utilisateur
            },
            style: ElevatedButton.styleFrom( // Style du bouton de sauvegarde de la modification du rôle de l'utilisateur
              backgroundColor: AgrosafeTheme.iconeColor(),
              foregroundColor: AgrosafeTheme.bg(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AgrosafeTheme.radiusButtons)),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
            child: Text(l10n.sauvegarder), // Texte du bouton de sauvegarde de la modification du rôle de l'utilisateur
          ),
        ),
      ],
    );
  }
}
