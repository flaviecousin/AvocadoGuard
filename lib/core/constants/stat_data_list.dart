// Importation de la bibliothèque nécessaire
import 'package:flutter/material.dart';

class StatData {
  // Classe permettant de gérer la liste utilisée dans la grille des statistiques du lot
  final String label; // Titre de la catégorie
  final String value; // Valeur de la catégorie
  final Color valueColor; // Couleur de la valeur (vert : en-dessous de la limite, orange : proche de la limite, rouge : au-dessus de la limite)

  const StatData({
    // Constructeur de la classe
    required this.label,
    required this.value,
    required this.valueColor,
  });
}