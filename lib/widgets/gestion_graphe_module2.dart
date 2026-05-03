// Importation de la bibliothèque nécessaire
import 'package:flutter/material.dart';

class ChartPainter extends CustomPainter {
  // Classe gérant l'affichage d'un graphe décoratif dessiné à la main
  // CustomPainter permet de dessiner des formes personnalisées sur un Canvas
  // Utilisé ici pour afficher une courbe stylisée

  final Color color; // Couleur de la courbe
  ChartPainter({required this.color}); // Constructeur de la classe

  @override
  void paint(Canvas canvas, Size size) {
    // Méthode appelée automatiquement par Flutter pour dessiner sur le canvas (surface de dessin)
    // size : dimensions disponibles (largeur x hauteur)
    final paint = Paint()
    // Paint : l'outil de dessin avec ses propriétés
      ..color = color.withValues(alpha: 0.6) // Couleur de la courbe avec 60% d'opacité pour un effet semi-transparent
      ..strokeWidth = 1.5 // Epaisseur du trait de la courbe en px
      ..style = PaintingStyle.stroke // stroke : on dessine uniquement le contour (pas de remplissage)
      ..strokeCap = StrokeCap.round; // Extrémités arrondies pour un rendu plus doux

    final path = Path(); // Path : chemin que va suivre la courbe
    // On ajoute les points un par un pour former la courbe

    // Liste de points définis en proportions entre 0.0 et 1.0
    // Les valeurs vont par paires : [x1, y1, x2, y2, ...] avec x=0 : bord gauche, x=1 : bord droit, y=0 : haut et y=1 : bas
    final pts = [
      0.0, 0.4,
      0.3, 0.5,
      0.45, 0.35,
      0.5, 0.55,
      0.6, 0.45,
      0.7, 0.5,
      0.85, 0.4,
      1.0, 0.45
    ];
    for (int i = 0; i < pts.length; i += 2) {
      // On parcourt les points par paires : i=x et i+1=y
      final x = pts[i] * size.width; // Convertit la proportion en pixels réels selon la largeur du widget
      final y = pts[i + 1] * size.height; // Convertit la proportion en pixels réels selon la largeur du widget
      if (i == 0) {
        path.moveTo(x, y); // Premier point : on déplace le curseur sans tracer de trait
      } else {
        path.lineTo(x, y); // Points suivants : on trace une ligne droite depuis le point précédemment
      }
    }
    canvas.drawPath(path, paint); // Dessine le chemin complet sur le canvas avec les propriétés du pinceau définies
  }

  @override
  bool shouldRepaint(_) => false;
  // Indique à Flutter s'il faut redessiner la courbe quand le widget se reconstruit
  // Ici c'est false car cette courbe est purement décorative et ses points ne changent pas
}