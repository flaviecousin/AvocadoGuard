// Importation de la bibliothèque et du fichier nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';

class ThresholdItem extends StatelessWidget {
  // Classe permettant de gérer le style des seuils affichés sur la page générale du module 2
  final Color color; // Couleur de la pastille
  final String text; // Texte des seuils

  const ThresholdItem({
    // Constructeur de la classe
    super.key,
    required this.color,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    // Widget permettant de gérer le style des seuils
    return Row(
      children: [
        Container(
          width: 8, height: 8, // Dimension de la pastille
          decoration: BoxDecoration(
            color: color, // Couleur de la pastille
            shape: BoxShape.circle // Forme de la pastille
          )
        ),
        const SizedBox(width: 5), // Espace séparant la pastille du texte
        // Affichage du texte du seuil max avec "explication" des alertes
        Text(
          text,
          // Style du texte
          style: TextStyle(
            fontSize: 12,
            color: AgrosafeTheme.textPrimary()
          )
        ),
      ],
    );
  }
}