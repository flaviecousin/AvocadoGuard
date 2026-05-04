// Importations de la bibliothèque et du fichier nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';

class StatItem extends StatelessWidget {
  // Classe gérant l'affichage des statistiques des mesures du capteur sélectionné
  final String label; // Titre de la statistique
  final String value; // Valeur de la statistique

  const StatItem({
    // Constructeur de la classe
    super.key,
    required this.label,
    required this.value
  });

  @override
  Widget build(BuildContext context) => Column(children: [
    // Widget permettant d'afficher les statistiques des mesures d'un capteur sélectionné
    // Texte affichant la valeur de la statistique
    Text(value,
      // Style de texte de la valeur
      style: AgrosafeTheme.dataText.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AgrosafeTheme.textPrimary())),
    const SizedBox(height: 2), // Espace entre le titre de la statistique et de sa valeur
    // Légende de la valeur (min, max ou moyenne)
    Text(label,
      // Style de la légende
      style: AgrosafeTheme.labelsText.copyWith(color: AgrosafeTheme.textMuted())),
  ]);
}