// Importation des bibliothèques nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';

class RegisterCard extends StatelessWidget {
  // Classe permettant de construire une carte de saisie avec un label et un champ de saisie de manière responsive (adaptée à la taille de l'écran)
  final String label;
  final Widget field;
  final BuildContext context;

  const RegisterCard({
    // Constructeur de la classe
    super.key,
    required this.label,
    required this.field,
    required this.context,
  });

  @override
  Widget build(BuildContext context){
  // Widget permettant de construire la carte de saisie avec un label et un champ de saisie de manière responsive (adaptée à la taille de l'écran)
    final isDesktop = MediaQuery.of(context).size.width > 600; // Détection de la taille de l'écran pour adapter l'affichage (si la largeur de l'écran est supérieure à 600 pixels, on considère que c'est un écran de bureau)

    // Ecran d'ordinateur : affichage du label et du champ de saisie côte à côte
    if (isDesktop) {
      return Row(
        children: [
          Expanded(
            // Affichage du label à gauche du champ de saisie avec son style
            child: Text(
              label,
              style: AgrosafeTheme.bodyText.copyWith(
                color: AgrosafeTheme.moss,
                fontWeight: FontWeight.w700
              )
            )
          ),
          const SizedBox(width: 15), // Espace entre le label et le champ de saisie
          Expanded(child: field), // Affichage du champ de saisie à droite du label
        ],
      );
    }
    // Ecran mobile : affichage du label au-dessus du champ de saisie
    else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Affichage du label au-dessus du champ de saisie avec son style
          Text(
            label,
            style: AgrosafeTheme.bodyText.copyWith(
              color: AgrosafeTheme.moss,
              fontWeight: FontWeight.w700
            )
          ),
          const SizedBox(height: 6), // Espace entre le label et le champ de saisie
          field, // Affichage du champ de saisie en dessous du label
        ],
      );
    }
  }
}