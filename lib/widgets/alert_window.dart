// Importation de la bibliothèque et des fichiers nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour pouvoir changer la langue de la page

class AlertModal extends StatelessWidget {
  // Classe gérant la bannière déployée entièrement = fenêtre d'alerte
  final List<String> alerts; // Liste contenant les alertes actives
  const AlertModal({
    // Constructeur de la classe
    super.key,
    required this.alerts
  });

  @override
  Widget build(BuildContext context) {
    // Widget gérant l'affichage et les actions de la fenêtre d'alertes
    final l10n = AppLocalizations.of(context)!; // permet de changer la langue des textes
    return Container(
      margin: const EdgeInsets.all(16), // Position de la fenêtre sur la page quand elle est ouverte
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32), // Marge intérieure de la fenêtre
      // Style de la fenêtre
      decoration: BoxDecoration(
        color: AgrosafeTheme.warningPastel,
        borderRadius: BorderRadius.circular(24), // coins arrondis
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icône danger
          Container(
            width: 60, height: 60, // Taille du contenant du premier élément (icône danger)
            // Style de la pastille entourant l'icône
            decoration: BoxDecoration(
              color: AgrosafeTheme.danger.withValues(alpha: 0.12), // Pastille couleur 
              shape: BoxShape.circle, // Cercle autour de l'icône
            ),
            // Icône et son style
            child: const Icon(Icons.warning_amber_rounded, color: AgrosafeTheme.danger, size: 30),
          ),
          const SizedBox(height: 16), // Espace avant titre
          // Titre d'alertes actives avec nombre si plus d'une
          Text(
            alerts.length == 1 ? l10n.alerteRisque : '${alerts.length} ${l10n.alertesActives}',
            // Style du titre
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AgrosafeTheme.danger),
          ),
          const SizedBox(height: 16), // Espace
          // Liste des alertes
          ...alerts.map((alert) => Padding(
            padding: const EdgeInsets.only(bottom: 8), // Espace entre chaque ligne
            child: Row(
              children: [
                const Icon(Icons.circle, size: 8, color: AgrosafeTheme.danger), // point avant texte
                const SizedBox(width: 10), // Espace avant le texte
                Expanded(
                  // Texte de l'alerte
                  child: Text(
                    alert,
                    // Style du texte
                    style: TextStyle(fontSize: 14, color: AgrosafeTheme.bottomnav()),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 20), // Ajout d'un espace avant la séparation
          Divider(color: AgrosafeTheme.borderColor()), // Ligne séparatrice
          const SizedBox(height: 16), // Ajout d'un espace avant le texte
          // Texte des conseils
          Text(
            l10n.ventilationChambreFroide,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AgrosafeTheme.bottomnav(), height: 1.5),
          ),
          const SizedBox(height: 24), // Ajout d'un espace avant les boutons
          SizedBox(
            width: double.infinity, // permet au bouton de prendre toute la place disponible en largeur
            // Bouton Accusé de réception
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check, size: 18), // icône
              // Texte et style du texte
              label: Text(l10n.accuse,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              // Style du bouton
              style: ElevatedButton.styleFrom(
                backgroundColor: AgrosafeTheme.danger,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 10), // Espace avant d'ajouter le 2e bouton
          SizedBox(
            width: double.infinity, // permet de prendre toute la largeur disponible
            // Bouton pour accéder à l'historique (voir dashboards)
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              // Style du bouton
              style: OutlinedButton.styleFrom(
                foregroundColor: AgrosafeTheme.bottomnav(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: AgrosafeTheme.textMuted()),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              // Texte du bouton
              child: Text(l10n.voirDashboard,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}