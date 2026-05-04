// Importations de la bibliothèque et des fichiers nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/widgets/module_tag.dart'; // pour accéder au badge des différents modules

class ModuleSummaryCard extends StatelessWidget {
  // Classe permettant de configurer l'affichage des cartes résumés des modules
  final ModuleTagType tagType; // badge du module
  final String title; // Titre de la carte
  final String subtitle; // Sous-titre de la carte
  final Widget? trailing; // le ? permet de rendre optionnel le badge de statut
  final String ctaLabel; // Texte du bouton
  final VoidCallback onCtaTap; // Action du bouton

  const ModuleSummaryCard({
    super.key,
    required this.tagType,
    required this.title,
    required this.subtitle,
    this.trailing, // pas de required car le badge de statut est optionnel
    required this.ctaLabel,
    required this.onCtaTap,
  });

  @override
  Widget build(BuildContext context) {
    // Widget permettant de gérer l'affichage des cartes de résumés des différents modules
    return Container(
      width: double.infinity, // permet de prendre toute la largeur possible
      padding: const EdgeInsets.all(AgrosafeTheme.cardPadding), // Marges internes de la carte
      // Style de la carte
      decoration: BoxDecoration(
        color: AgrosafeTheme.cardBg(),
        borderRadius: BorderRadius.circular(AgrosafeTheme.radiusCards),
        border: Border.all(color: AgrosafeTheme.borderColor()),
      ),
      child: Column( // Organisation générale de la carte en colonne
        crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
        children: [
          // Ligne 1 : tag + badge (badge affiché seulement s'il existe)
          Row( // Organisation de la ligne
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // permet d'espacer au maximum les éléments
            children: [
              Flexible(
                child: ModuleTag(type: tagType), // Affichage du badge du module
              ),
              if (trailing != null) trailing as Widget, // Affichage du badge du statut s'il est donné dans les arguments
            ],
          ),
          const SizedBox(height: 10), // Espace entre la ligne 1 et 2 de la carte
          // Affichage du titre de la carte et son style
          Text(
            title,
            style: AgrosafeTheme.labelsText.copyWith(
              fontSize: 16,
              color: AgrosafeTheme.textPrimary(),
            ),
          ),
          const SizedBox(height: 4), // Espace entre le titre et le sous-titre
          // Affichage du sous-titre et son style
          Text(
            subtitle,
            style: AgrosafeTheme.dataText.copyWith(color: AgrosafeTheme.textMuted()),
          ),
          const SizedBox(height: 12), // Espace entre la ligne 3 (sous-titre) et 4 (bouton vers la page du module concerné)
          // Action du bouton
          GestureDetector(
            onTap: onCtaTap, // lien vers la page
            child: Text( // Affichage du texte du bouton avec son style
              ctaLabel,
              style: AgrosafeTheme.quickAccess.copyWith(
                fontSize: 13,
                color: AgrosafeTheme.iconeColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}