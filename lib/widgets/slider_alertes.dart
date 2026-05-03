// Importation de la bibliothèque et du fichier nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';

class SliderAlertes extends StatelessWidget {
  // Classe permettant de construire le slider d'un des capteurs
  final String icon; // Icône du type de mesure
  final String label; // Nom du type de mesure
  final double value; // Valeur choisie
  final double min; // Minimum du slider
  final double max; // Maximum du slider
  final String unit; // Unité de la valeur
  final Function(double) onChanged; // Pour pouvoir sauvegarder la nouvelle valeur

  const SliderAlertes({
    // Constructeur de la classe
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context){
    // Widget permettant de construire le slider avec son titre et la valeur affichée
    return Column( // Alignement en colonne
      crossAxisAlignment: CrossAxisAlignment.start, // aligné à gauche
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              // Affichage du titre avec son icône (émoji) et leurs styles
              child: Text(
                '$icon $label',
                style: AgrosafeTheme.bodyText.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AgrosafeTheme.textPrimary(),
                ),
              ),
            ),
            // Affichage de la valeur du seuil et son unité avec leurs styles
            Text(
              '${value.toStringAsFixed(0)}$unit',
              style: AgrosafeTheme.displayTitle.copyWith(color: AgrosafeTheme.textPrimary()),
            ),
          ],
        ),
        // Affichage du slider
        SliderTheme(
          // Style du slider
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AgrosafeTheme.iconeColor(),
            inactiveTrackColor: AgrosafeTheme.borderColor(),
            thumbColor: AgrosafeTheme.cardBg(),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayColor: AgrosafeTheme.iconeColor().withValues(alpha: 0.2),
            trackHeight: 4,
          ),
          // Action et valeurs (min, max, sélectionnée)
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}