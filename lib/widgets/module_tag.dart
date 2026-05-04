// Importations des bibliothèques et fichiers nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // permet d'accéder à la traduction des textes

enum ModuleTagType { module1, module2, shared } // Liste des différents modules de notre application

class ModuleTag extends StatelessWidget {
  // Classe permettant de configurer les différentes étiquettes des différents modules de notre application
  final ModuleTagType type; // Variable permettant de récupérer le nom du module concerné

  const ModuleTag({
    // Constructeur de la classe
    super.key,
    required this.type
  });

  @override
  Widget build(BuildContext context) {
    // Widget permettant de gérer l'affichage de l'étiquette des différents modules de notre application
    final config = _getConfig(context); // permet de récupérer les caractéristiques d'affichages des différents modules

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Marges internes des étiquettes
      // Style des étiquettes
      decoration: BoxDecoration(
        color: config['background'],
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: config['border'], width: 1),
      ),
      // Affichage du texte correspondant au module avec la couleur correspondante
      child: Text(
        config['label'],
        style: AgrosafeTheme.labelsText.copyWith(color: config['text']),
      ),
    );
  }

  Map<String, dynamic> _getConfig(BuildContext context) {
    // Fonction permettant de configurer les couleurs et textes de l'étiquette
    return {
      'label': AppLocalizations.of(context)!.module2TitleProfil, // Titre du module
      'background': const Color(0xFFEAF4FB), // Couleur de fond
      'text': const Color(0xFF1A6B99), // Couleur du texte
      'border': const Color(0xFF85C1E9), // Couleur des bordures
    };
  }
}