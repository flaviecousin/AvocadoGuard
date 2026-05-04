// Importation des bibliothèques et des fichiers nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/widgets/app_bar_rapports.dart'; // pour afficher l'en-tête de la page de rapport
import 'package:avocadoguard/widgets/bottom_nav.dart'; // pour afficher la barre de navigation
import 'package:avocadoguard/widgets/export_bouton.dart'; // pour afficher le bouton d'export
import 'package:avocadoguard/widgets/risque_global_card.dart'; // pour afficher la carte de risque global
import 'package:avocadoguard/widgets/stats_capteurs_cards.dart'; // pour afficher aux cartes des résumés (statistiques) des mesures

class Rapport30Screen extends StatefulWidget {
  // Classe permettant de configurer la page de rapport du lot
  final Function(int) onNavigate; // pour naviguer sur l'application (barre de navigation)
  final DateTime beginning; // pour accéder à la date de début du rapport
  final DateTime end; // pour accéder à la date de fin du rapport
  
  const Rapport30Screen({
    // Constructeur de la classe
    super.key,
    required this.onNavigate,
    required this.beginning,
    required this.end
  });

  @override
  // Permet d'avoir l'état mutable associé à ce widget
  State<Rapport30Screen> createState() => _Rapport30ScreenState();
}

class _Rapport30ScreenState extends State<Rapport30Screen> {
  // Classe permettant de gérer l'affichage de la page de rapport du lot

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgrosafeTheme.bg(),
      body: SafeArea(
        child: Column(children: [
          // Affichage de l'en-tête
         AppBarRapport(
          beginningDate: widget.beginning,
          endDate: widget.end,
         ),
          Expanded(
            child: ListView( // Marge
              padding: const EdgeInsets.fromLTRB(
                  AgrosafeTheme.screenHorizontalPadding, 4,
                  AgrosafeTheme.screenHorizontalPadding, 32),
              children: [
                const SizedBox(height: 14), // Espace avant la carte de risque
                // Affichage de la carte du risque global du lot
                RiskCard(
                  beginning: widget.beginning, 
                  end: widget.end
                ),
                const SizedBox(height: 12), // Ajout d'un espace avant la grille
                // Affichage des différentes carte de plusieurs statistiques (capteurs + alertes + autres)
                StatsCapteursCards(
                  beginning: widget.beginning,
                  end: widget.end,
                  showDuree: false,
                ),
                const SizedBox(height: 24), // Ajout d'un espace avant le prochain élément
                // Affichage du bouton d'exportation de l'historique en format CSV
                ExportButton(
                  beginningDate: widget.beginning,
                  endDate: widget.end
                ),
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: AgrosafeBottomNav(
        selectedIndex: 1,
        onDestinationSelected: (index){
          Navigator.pop(context);
          widget.onNavigate(index);
        },
      ),
    );
  }
}