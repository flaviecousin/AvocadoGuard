// Importations de la bibliothèque et du fichier nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';

class SiloPainter extends CustomPainter {
  // Classe permettant de configurer l'affichage du suivi visuel
  final Color bg;

  // Constructeur de la classe
  const SiloPainter({required this.bg});

  @override
  void paint(Canvas canvas, Size size) {
    // Dessiner le fond du rectangle (le ciel ou le mur derrière les silos)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = bg,
    );

    // Préparation du pinceau pour le corps des silos (couleur très transparente)
    final paint = Paint()..color = AgrosafeTheme.cardBg().withValues(alpha: 0.18);

    // Boucle pour dessiner 3 silos de tailles différentes
    for (int i = 0; i < 3; i++) {
      // Calcul de la position horizontale (x) et des dimensions (w, h)
      // On utilise des pourcentages (size.width * 0.18) pour que ça s'adapte à l'écran
      final x = size.width * (0.18 + i * 0.28); 
      final w = size.width * 0.2;
      final h = size.height * (0.55 + i * 0.06); // Chaque silo est un peu plus haut que le précédent

      // Dessiner le corps du silo (un rectangle avec des coins arrondis)
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          // On place le bas du silo tout en bas (size.height - h)
          Rect.fromLTWH(x, size.height - h, w, h), 
          const Radius.circular(3), // Arrondi des angles
        ),
        paint,
      );

      // Dessiner le toit du silo (forme triangulaire)
      final roof = Path()
        ..moveTo(x - 3, size.height - h) // Point de départ (un peu à gauche du corps)
        ..lineTo(x + w / 2, size.height - h - 12) // Pointe du toit (centrée et plus haute de 12px)
        ..lineTo(x + w + 3, size.height - h) // Point d'arrivée (un peu à droite du corps)
        ..close(); // Relie le dernier point au premier pour fermer le triangle

      // On dessine le toit avec une opacité légèrement plus forte (0.25)
      canvas.drawPath(
        roof, 
        Paint()..color = AgrosafeTheme.cardBg().withValues(alpha: 0.25),
      );
    }
  }

  // Optimisation : doit-on redessiner si le widget change ?
  @override
  bool shouldRepaint(covariant SiloPainter oldDelegate) {
    // On redessine uniquement si la couleur de fond a changé
    return oldDelegate.bg != bg;
  }
}