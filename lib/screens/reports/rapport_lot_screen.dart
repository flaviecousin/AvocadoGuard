// Importation des bibliothèques et des fichiers nécessaires
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // pour changer le format de la date
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour pouvoir changer la langue de la page
import 'package:avocadoguard/screens/reports/rapport_1mois.dart'; // pour accéder à la page du rapport du mois précédent
import 'package:avocadoguard/widgets/app_bar_rapports.dart'; // pour afficher l'en-tête de la page de rapport
import 'package:avocadoguard/widgets/bottom_nav.dart'; // pour afficher la barre de navigation
import 'package:avocadoguard/widgets/export_bouton.dart'; // pour afficher le bouton d'export
import 'package:avocadoguard/widgets/risque_global_card.dart'; // pour afficher la carte de risque global
import 'package:avocadoguard/widgets/silo_visuel.dart'; // pour afficher le dessin des silos
import 'package:avocadoguard/widgets/stats_capteurs_cards.dart'; // pour afficher les cartes résumés (statistiques) des mesures selon la période de temps définie

class RapportLotScreen extends StatefulWidget {
  // Classe permettant de configurer la page de rapport du lot
  final Function(int) onNavigate; // pour naviguer sur l'application (barre de navigation)
  
  const RapportLotScreen({
    // Constructeur de la classe
    super.key,
    required this.onNavigate
  });

  @override
  // Permet d'avoir l'état mutable associé à ce widget
  State<RapportLotScreen> createState() => _RapportLotScreenState();
}

class _RapportLotScreenState extends State<RapportLotScreen> {
  // Classe permettant de gérer l'affichage de la page de rapport du lot

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now(); // Récupération de la date d'aujourd'hui
    final derniers30Jours = now.subtract(const Duration(days: 30)); // Récupération de la date d'il y a 30 jours
    return Scaffold(
      backgroundColor: AgrosafeTheme.bg(),
      body: SafeArea(
        child: Column(children: [
          // Affichage de l'en-tête
         AppBarRapport(
          beginningDate: derniers30Jours,
          endDate: now,
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
                  beginning: derniers30Jours,
                  end: now,
                ),
                const SizedBox(height: 12), // Ajout d'un espace avant la grille
                // Affichage des différentes carte de plusieurs statistiques (capteurs + alertes + autres)
                StatsCapteursCards(
                  beginning: derniers30Jours,
                  end: now
                ),
                const SizedBox(height: 24), // Ajout d'un espace avant le prochaine élément
                // Affichage du suivi visuel
                _buildVisualSection(context),
                const SizedBox(height: 24), // Ajout d'un espace avant le bouton
                // Affichage du bouton d'exportation de l'historique en format CSV
                ExportButton(
                  beginningDate: derniers30Jours,
                  endDate: now
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
  
  // ------ SUIVI VISUEL ------
  Widget _buildVisualSection(BuildContext context) {
    // Widget gérant l'affichage du suivi visuel sous forme de 3 silos cliquables
    // Chaque silo représente une période de 30 jours et donne accès au rapport correspondant
    final l10n = AppLocalizations.of(context)!; // pour changer la langue du texte
    final now = DateTime.now(); // Récupération de la date d'aujourd'hui
    final mois1 = now.subtract(const Duration(days: 30)); // Récupération de la date d'il y a 30 jours
    final mois2 = now.subtract(const Duration(days: 60)); // Récupération de la date d'il y a 60 jours
    final mois3 = now.subtract(const Duration(days: 90)); // Récupération de la date d'il y a 90 jours
    final mois4 = now.subtract(const Duration(days: 120)); // Récupération de la date d'il y a 120 jours
    // Liste permettant de récupérer les informations de chaque période pour les rapports précédents et les différentes couleurs pour les silos
    // 3 tuples pour chaque période de 30 jours
    // Chaque tuple contient : le label affiché, la couleur du silo et les dates
    final period=[
      (
        // Période la plus ancienne : de -120 jours à -90 jours
        label: '${DateFormat('yyyy-MM-dd').format(mois4)} - ${DateFormat('yyyy-MM-dd').format(mois3)}',  // On formate la date sous le bon format, sans l'heure
        color: const Color(0xFF1B4F6B), // couleur bleu foncé du silo
        start: mois4, // date du début de la période
        end: mois3 // date de la fin de la période
      ),
      (
        // Période intermédiaire : de -90 jours à -60 jours
        label:'${DateFormat('yyyy-MM-dd').format(mois3)} - ${DateFormat('yyyy-MM-dd').format(mois2)}', // Formatage de la date
        color: const Color(0xFF1C5070),
        start: mois3,
        end: mois2
      ),
      (
        // Période la plus récente : de -60 jours à -30 jours
        label:'${DateFormat('yyyy-MM-dd').format(mois2)} - ${DateFormat('yyyy-MM-dd').format(mois1)}',  // Formatage de la date
        color: const Color(0xFF1A4C68),
        start: mois2,
        end: mois1
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // alignement à gauche
      children: [
        // Affichage du titre de la section avec son style
        Text(
          l10n.visuel,
          style: AgrosafeTheme.labelsText.copyWith(color: AgrosafeTheme.textMuted()),
        ),
        const SizedBox(height: 12), // Ajout d'un espace
        Row(
          // Liste de tuples (date, couleur) représentant 3 snapshots du silo
          children: period.map((p) => Expanded(
            // Chaque silo prend 1/3 de la largeur disponible
            child: GestureDetector(
              // Permet d'accéder aux pages des rapports précédents en fonction des données de la période
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Rapport30Screen(
                      onNavigate: widget.onNavigate,
                      beginning: p.start, // date de début passée au rapport
                      end:p.end // date de fin passée au rapport
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8), // Espace entre les silos
                child: Column(
                  children: [
                    // Dessin du silo avec Custom Paint et coins arrondis
                    ClipRRect(
                      // ClipRRect applique les coins arrondis au CustomPaint
                      borderRadius: BorderRadius.circular(AgrosafeTheme.radiusInputFields),
                      child: SizedBox(
                        height: 80, // hauteur du silo
                        child: CustomPaint(
                          // CustomPaint permet de dessiner des formes personnalisées
                          // ici il dessine le silo via la classe SiloPainter
                          size: const Size(double.infinity, 80),
                          painter: SiloPainter(
                            bg: p.color, // couleur du silo selon la période
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Affichage du label (période) sous le silo
                    Text(
                      p.label, // date du silo selon la date // p.$1 fait référence à la date définie dans le tuple
                      style: AgrosafeTheme.dataText.copyWith(
                        color: AgrosafeTheme.textMuted(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )).toList(), 
          // convertit le résultat du .map() en List<Widget>
          // nécessaire car Row attend une List et non un Iterable
        ),
      ],
    );
  }
}