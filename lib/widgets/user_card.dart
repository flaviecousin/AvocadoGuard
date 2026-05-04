// Importations de la bibliothèque et des fichiers nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';

class UserCard extends StatelessWidget {
  // Classe permettant de configurer la carte utilisateur (page profil)
  final String title; // Rôle de l'utilisateur
  final String subtitle; // Sous-titre de l'utilisateur
  final String ctaLabel; // Texte du bouton
  final VoidCallback onCtaTap; // Lien vers la page de l'utilisateur

  const UserCard({
    // Constructeur de la classe
    super.key,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.onCtaTap,
  });

  @override
  Widget build(BuildContext context) {
    // Widget permettant de gérer l'affichage de la carte de l'utilisateur
    return Container(
      width: double.infinity, // permet de prendre toute la largeur disponible
      padding: const EdgeInsets.all(AgrosafeTheme.cardPadding), // Marges internes de la carte
      // Style de la carte
      decoration: BoxDecoration(
        color: AgrosafeTheme.cardBg(),
        borderRadius: BorderRadius.circular(AgrosafeTheme.radiusCards),
        border: Border.all(color: AgrosafeTheme.borderColor()),
      ),
      child: Column( // Organisation générale de la carte en colonne
        crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
        children: [
          Row( // Organisation en ligne (pour la première ligne uniquement)
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Permet d'espacer au maximum les éléments
            children: [
              Icon(Icons.account_circle, size: 40, color: AgrosafeTheme.iconeColor()), // Affichage de l'icône et son style
              const SizedBox(width: 12), // Espace entre l'icône et les textes
              Expanded(
                child: Column( // Organisation en colonne
                  crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
                  children: [
                    // Affichage du texte du rôle avec son style
                    Text(title,
                        style: AgrosafeTheme.displayTitle.copyWith(
                          fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 32, // Permet de changer la taille de la police en fonction de la taille de l'écran
                          color: AgrosafeTheme.textPrimary(),
                        ),
                        overflow: TextOverflow.ellipsis, // Si le texte est trop grand on affiche '...' 
                        maxLines: 1, // On veut que le texte ne soit écrit que sur une seule ligne
                    ),
                    // Affichage du sous-titre (AgroSafe User) de l'utilisateur avec son style
                    Text(subtitle,
                        style: AgrosafeTheme.bodyText.copyWith(
                          fontSize: MediaQuery.of(context).size.width < 600 ? 13 : 19,  // ← adaptatif
                          color: AgrosafeTheme.textMuted(),
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 8), // Espace entre la colonne (titre + sous-titre) et le bouton
              // Action du bouton
              GestureDetector(
                onTap: onCtaTap, // lien vers la page Utilisateur
                child: Text( // Texte du bouton avec son style
                  ctaLabel,
                  style: AgrosafeTheme.quickAccess.copyWith(fontSize: MediaQuery.of(context).size.width < 600 ? 13 : 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}