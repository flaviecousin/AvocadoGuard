// Importation des bibliothèques nécessaires
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // pour accéder aux polices Google
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour la traduction des textes
import 'package:avocadoguard/core/theme/app_theme.dart';

class AgrosafeBottomNav extends StatelessWidget {
  // Classe permettant de construire la barre de navigation de l'application avec les différentes destinations
  final int selectedIndex; // Sélection de la page
  final Function(int) onDestinationSelected; // Fonction pour gérer la sélection d'une destination dans la barre de navigation et naviguer vers la page correspondante

  const AgrosafeBottomNav({
    // Constructeur de la classe
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Widget permettant de construire la barre de navigation de l'application avec les différentes destinations
    final l10n = AppLocalizations.of(context)!; // pour changer la langue des textes
    return NavigationBarTheme(
      // Style de la barre de navigation
      data: NavigationBarThemeData(
        backgroundColor: AgrosafeTheme.bottomnav(), // Couleur de fond
        indicatorColor: Colors.transparent, // Couleur de l'indicateur de sélection (transparent pour ne pas afficher d'indicateur)
        height: 72, // Hauteur de la barre de navigation
        // Style des textes des onglets
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            // Onglet sélectionné : style du texte
            return GoogleFonts.instrumentSans(
              fontSize: 12,
              color: AgrosafeTheme.lime,
              fontWeight: FontWeight.w600,
            );
          }
          // Onglet non sélectionné : style du texte
          else{
            return GoogleFonts.instrumentSans(
              fontSize: 12,
              color: AgrosafeTheme.textMuted(),
            );
          }
        }),
        // Style des icônes des onglets
        iconTheme: WidgetStateProperty.resolveWith((states) {
          // Onglet sélectionné : style de l'icône
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AgrosafeTheme.lime, size: 24);
          }
          else{
            // Onglet non sélectionné : style de l'icône}
            return const IconThemeData(color: AgrosafeTheme.muted, size: 24);
          }
        }),
      ),
      // Navigation entre les différentes pages de l'application en fonction de la destination sélectionnée dans la barre de navigation
      child: NavigationBar(
        selectedIndex: selectedIndex, // Index de la page sélectionnée actuelle pour l'afficher
        onDestinationSelected: onDestinationSelected, // Fonction pour gérer la sélection d'une destination dans la barre de navigation et naviguer vers la page correspondante
        destinations: [
          // Onglet de la page d'accueil avec son icône et son label
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_outlined),
            label: l10n.home,
          ),
          // Onglet du module 2 avec son icône et son label
          NavigationDestination(
            icon: const Icon(Icons.thermostat_outlined),
            selectedIcon: const Icon(Icons.thermostat),
            label: l10n.module2,
          ),
          // Onglet du profil avec son icône et son label
          NavigationDestination(
            icon: const Icon(Icons.person),
            selectedIcon: const Icon(Icons.person),
            label: l10n.profil,
          ),
        ],
      ),
    );

  }
}