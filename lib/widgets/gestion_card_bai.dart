// Importation de la bibliothèque et des fichiers nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour pouvoir changer la langue des textes
import 'package:avocadoguard/widgets/status_badge.dart'; // pour pouvoir afficher les statuts des capteurs (sain, douteux, danger)
import 'package:avocadoguard/widgets/visu_graphe_module2.dart'; // pour pouvoir afficher les graphes

class BaiCard extends StatelessWidget {
  // Classe gérant la carte de la mesure BAI à l'instant t
  final String type; // Type de mesure pour récupérer la couleur
  final double numericValue; // Valeur de la mesure (en numérique)
  final String value; // Valeur de la mesure des capteurs
  final bool invalid;

  const BaiCard({
    // Constructeur de la classe
    super.key,
    required this.type,
    required this.numericValue,
    required this.value,
    required this.invalid,
  });

  // Getter pour récupérer la couleur du badge pour pouvoir l'utiliser sur la courbe du graphe
  Color get tagColor {
    if (numericValue >= 60) return AgrosafeTheme.danger;
    if (numericValue > 20) return AgrosafeTheme.warning;
    return AgrosafeTheme.safe;
  }

   // Fonction permettant de récupérer le badge
   StatusBadge getBadge (BuildContext context){
    if (numericValue >= 60) return StatusBadge.danger2(context);
    if (numericValue > 20) return StatusBadge.warning(context);
    return StatusBadge.safe(context);
  }

  String getValue (BuildContext context){
    final l10n = AppLocalizations.of(context)!; // permet de changer de langue le texte
    if (invalid == true) return '-';
    if (numericValue >= 60) return l10n.alerteFermentation;
    if (numericValue > 20) return l10n.maturation;
    return l10n.stable;
  }

  @override
  Widget build(BuildContext context) {
    // Widget gérant les cartes des mesures des capteurs à l'instant t
    String label=getValue(context);
    return Container(
      padding: const EdgeInsets.all(14), // Marges à l'intérieur des cartes des mesures
      // Style des cartes de mesures
      decoration: BoxDecoration(
        color: AgrosafeTheme.cardBg(),
        borderRadius: BorderRadius.circular(16), // permet d'arrondir les coins des cartes
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Permet d'aligner les éléments
        children: [
          const Row(
            children: [
              // Affichage de l'icône (émoji) des types de mesure
              Text(
                '🫧',
                style: TextStyle(fontSize: 16) // Style de l'icône
              ),
              SizedBox(width: 6), // Espace ajouté entre l'icône et le titre de la mesure
              Expanded(
                child: Text( // Ajout du titre du type de mesure
                  'BAI',
                  // Style du titre
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AgrosafeTheme.greyCard,
                    letterSpacing: 0.4
                  ),
                  overflow: TextOverflow.ellipsis, // Permet de raccourcir le texte s'il est trop long (en fonction de la taille de l'écran)
                ),
              ),
            ],
          ),
          const SizedBox(height: 4), // Ajout d'espace entre la première ligne (icône + titre) et la 2e ligne (tag du statut d'alerte)
          // Ajout du badge du statut face à la mesure mesure à l'instant t
          getBadge(context),
          const SizedBox(height: 8), // Espace avant valeur de la mesure
          // Valeur de la mesure en chiffre clair
          Text(
            label,
            // Style du texte de la valeur
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: AgrosafeTheme.textPrimary()),
          ),
          const SizedBox(height: 4), // Ajout d'un espace avant le graphe
          MiniChart(color: tagColor),
        ],
      ),
    );
  }
}