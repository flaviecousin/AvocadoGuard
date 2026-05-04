// Importation de la bibliothèque et du fichier nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';

class ActionCard extends StatelessWidget {
  // Classe gérant les cartes d'accès aux pages historique et rapport du lot
  final IconData icon; // Icône symbolisant la page
  final Color iconColor; // Couleur de l'icône
  final String label; // Nom de la page
  final VoidCallback onCtaTap; // Action permettant d'accéder à la page

  const ActionCard({
    // Constructeur de la classe
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onCtaTap,
  });

  @override
  Widget build(BuildContext context) {
    // Widget gérant l'affichage et l'action de la carte d'action
    return GestureDetector(
      onTap: onCtaTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18), // Marge du contenu de la carte
        // Style de la carte
        decoration: BoxDecoration(
          color: AgrosafeTheme.cardBg(),
          borderRadius: BorderRadius.circular(16), // coins arrondis
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28), // Affichage de l'icône avec son style
            const SizedBox(height: 8), // Espace avant le sous-titre
            // Affichage du sous-titre
            Text(label,
              // Style du texte
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AgrosafeTheme.textPrimary()
                )
              ),
          ],
        ),
      ),
    );
  }
}