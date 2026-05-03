// Importation de la bibliothèque et du fichier nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/widgets/gestion_graphe_module2.dart'; // pour pouvoir accéder à la gestion de l'affichage d'un graphe décoratif dessiné à la main

class MiniChart extends StatelessWidget {
  // Classe gérant le visuel du graphe du capteur affiché
  final Color color;

  const MiniChart({
    // Constructeur de la classe
    super.key,
    required this.color
  }); 

  @override
  Widget build(BuildContext context) {
    // Widget gérant le visuel du graphe
    return CustomPaint(
      size: const Size(double.infinity, 20),
      painter: ChartPainter(color: color),
    );
  }
}