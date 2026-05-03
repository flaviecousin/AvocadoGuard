// Importation de la bibliothèque et des fichiers nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/models/scan_risk.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour accéder à la traduction des textes

class StatusBadge extends StatelessWidget {
  // Classe permettant de configurer le badge de statut des modules
  final String label; // Texte du badge
  final Color backgroundColor; // Couleur du fond du badge
  final Color textColor; // Couleur du texte

  const StatusBadge({
    // Constructeur de la classe
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  // Raccourcis pour accéder plus rapidement au statut du badge dans les autres fichiers
  factory StatusBadge.safe(BuildContext context) => StatusBadge(
    // Raccourci du badge SAIN
    label: AppLocalizations.of(context)!.sain, // Texte en fonction de la variable locale de langue
    backgroundColor:AgrosafeTheme.safePastel,
    textColor: AgrosafeTheme.safe,
  );

  factory StatusBadge.warning(BuildContext context) => StatusBadge(
    // Raccourci du badge DOUTEUX
    label: AppLocalizations.of(context)!.douteux, // Texte en fonction de la variable locale de langue
    backgroundColor: AgrosafeTheme.warningPastel,
    textColor: AgrosafeTheme.warning,
  );

  factory StatusBadge.danger(BuildContext context) => StatusBadge(
    // Raccourci du badge INFECTÉ (module 1)
    label: AppLocalizations.of(context)!.infecte, // Texte en fonction de la variable locale de langue
    backgroundColor:AgrosafeTheme.dangerPastel,
    textColor: AgrosafeTheme.danger,
  );

  factory StatusBadge.danger2(BuildContext context) => StatusBadge(
    // Raccourci du badge DANGER (module 2)
    label: AppLocalizations.of(context)!.danger, // Texte en fonction de la variable locale de langue
    backgroundColor:AgrosafeTheme.dangerPastel,
    textColor: AgrosafeTheme.danger,
  );
  
  factory StatusBadge.fromRisk(ScanRisk risk, BuildContext context) {
    // Permet d'appeler le bon badge en fonction du risque (module 1)
    switch (risk) {
      case ScanRisk.safe:
        return StatusBadge.safe(context);
      case ScanRisk.warning:
        return StatusBadge.warning(context);
      case ScanRisk.danger:
        return StatusBadge.danger(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    // Widget gérant l'affichage du badge du statut
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Marges internes du badge
      // Style du badge
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999), // Forme "Pill"
      ),
      child: Row( // Organisation en ligne
        mainAxisSize: MainAxisSize.min, // Permet de s'adapter à la taille du contenu
        children: [
          // Affichage du petit point avec son style avant le texte
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: textColor, // Le point prend la même couleur que le texte
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8), // Espace entre le point et le texte
          // Affichage du texte avec son style
          Text(
            label.toUpperCase(), // Permet d'afficher en majuscules le texte
            style: AgrosafeTheme.labelsText.copyWith(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}