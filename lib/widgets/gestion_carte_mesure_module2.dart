// Importation de la bibliothèque et des fichiers nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour pouvoir changer la langue de la page
import 'package:avocadoguard/widgets/status_badge.dart'; // pour pouvoir afficher les statuts des capteurs (sain, douteux, danger)
import 'package:avocadoguard/widgets/visu_graphe_module2.dart'; // pour pouvoir afficher les graphes

class SensorCard extends StatelessWidget {
  // Classe gérant les cartes des mesures à l'instant t
  final String icon; // Icône de la mesure (thermomètre, goutte d'eau et molécule)
  final String label; // Titre de la mesure
  final String type; // Type de mesure pour récupérer la couleur
  final double numericValue; // Valeur de la mesure (en numérique)
  final double seuilFao; // Seuil FAO donné par utilisateur dans écran de configuration
  final String value; // Valeur de la mesure des capteurs
  final bool invalid;

  const SensorCard({
    // Constructeur de la classe
    super.key,
    required this.icon,
    required this.label,
    required this.type,
    required this.numericValue,
    required this.seuilFao,
    required this.value,
    required this.invalid,
  });

  // Getter pour récupérer la couleur du badge pour pouvoir l'utiliser sur la courbe du graphe
  Color get tagColor {
  if (type == 'humidity') {
    if (numericValue > seuilFao) return AgrosafeTheme.danger;
    if (numericValue > seuilFao * 0.9) return AgrosafeTheme.warning;
    return AgrosafeTheme.safe;
  } else {
    if (numericValue > seuilFao) return AgrosafeTheme.danger;
    if (seuilFao - 1 <= numericValue) return AgrosafeTheme.warning;
    return AgrosafeTheme.safe;
  }
}

  @override
  Widget build(BuildContext context) {
    // Widget gérant les cartes des mesures des capteurs à l'instant t
    final l10n = AppLocalizations.of(context)!; // permet de changer de langue le texte
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
          Row(
            children: [
              // Affichage de l'icône (émoji) des types de mesure
              Text(
                icon,
                style: const TextStyle(fontSize: 16) // Style de l'icône
              ),
              const SizedBox(width: 6), // Espace ajouté entre l'icône et le titre de la mesure
              Expanded(
                child: Text( // Ajout du titre du type de mesure
                  label,
                  // Style du titre
                  style: const TextStyle(
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
          if (label==l10n.humidite)
            numericValue > seuilFao
              ? StatusBadge.danger2(context)
              : numericValue > seuilFao*0.9 // 10% en-dessous du seuil = warning sinon safe
                ? StatusBadge.warning(context)
                :StatusBadge.safe(context)
          else
            numericValue > seuilFao
              ? StatusBadge.danger2(context)
              : seuilFao-1 <= numericValue // à -1 degré près warning sinon safe
                ? StatusBadge.warning(context)
                : StatusBadge.safe(context),
          const SizedBox(height: 8), // Espace avant valeur de la mesure
          // Valeur de la mesure en chiffre clair
          Text(
            invalid ? '-' : value,
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