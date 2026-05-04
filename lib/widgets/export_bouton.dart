// Importation des bibliothèques et des fichiers nécessaires
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // pour pouvoir accéder à Firestore
import 'package:avocadoguard/core/services/export_service.dart'; // pour pouvoir exporter le fichier selon son appareil
import 'package:avocadoguard/core/services/user_service.dart'; // pour pouvoir accéder aux mesures enregistrées sur Firestore
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour pouvoir changer la langue des textes

class ExportButton extends StatefulWidget {
  // Classe permettant de gérer le bouton d'exporter un fichier CSV
  final DateTime beginningDate; // Date de début du rapport
  final DateTime endDate; // Fin de début du rapport

  const ExportButton({
    // Constructeur de la classe
    super.key,
    required this.beginningDate,
    required this.endDate,
  });

  @override
  State<ExportButton> createState() => _ExportButtonState();
}

class _ExportButtonState extends State<ExportButton> {
  bool _loading = false; // pour montrer un loader pendant l'export

  Future<void> _export() async {
    // Fonction déclenchée au clic sur le bouton d'export
    // Récupère les mesures Firestore et les exporte en fichier CSV
    setState(() => _loading = true); // Active le loader et désactive le bouton
    try {
      // Récupère toutes les mesures de la période sélectionnée depuis Firestore
      final mesures = await UserService.getMesuresPeriode(
          widget.beginningDate, widget.endDate);

      final buffer = StringBuffer(); // StringBuffer est plus performant que String pour construire un long texte par concaténations successives
      buffer.write('\uFEFF'); // permet d'afficher correctement les caractères spéciaux
      buffer.writeln('Date,Température (°C),Humidité (%),CO₂ (ppm)'); // permet d'écrire la ligne d'en-tête du fichier

      for (final row in mesures) {
        // Parcourt chaque mesure pour construire une ligne du CSV
        
        final date = (row['date'] as Timestamp).toDate();// Conversion du Timestamp en date lisible
        // Formate la date en DD/MM/YYYY
        final dateStr =
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} '//.padLeft permet d'ajouter un 0 devant les chiffres afin d'avoir un nombre à 2 chiffres
          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
        // On vérifie que chaque valeur est valide (différente de -9999) sinon on affiche '-'
        final temp = (row['temperature'] as num) != -999
          ? '${row['temperature']}' : '-';
        final hum = (row['humidity'] as num) != -999
          ? '${row['humidity']}' : '-';
        final co2 = (row['co2'] as num) != -999
          ? '${row['co2']}' : '-';

        // Ecrit une ligne du CSV avec les valeurs séparées par des virgules 
        buffer.writeln('$dateStr,$temp,$hum,$co2');
      }

      exportCsv(buffer.toString(), 'rapport_lot.csv');
      // Déclenche le télécharge du fichier CSV
    } catch (e) {
      // Erreur silencieuse
      //print('[ExportButton] Erreur : $e');
    } finally {
      // Désactive le loader et réactive le bouton si l'utilisateur est toujours sur la page
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // pour changer la langue du texte
    return SizedBox(
      width: double.infinity, // prend toute la largeur disponible
      child: ElevatedButton.icon(
        onPressed: _loading ? null : _export, // bouton désactivé pendant le chargement
        icon: _loading
            ? const SizedBox( // loader à la place de l'icône
                width: 18, height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            // Pendant l'export : affiche un spinner circulaire à la place de l'icône
            : const Icon(Icons.download_rounded, size: 20), // Sinon affiche l'icône de téléchargement
        // Affichage du texte du bouton
        label: Text(
            _loading ? '...' : l10n.exportCSV,
            style: AgrosafeTheme.bodyText.copyWith(fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AgrosafeTheme.iconeColor(), // Couleur du fond du bouton
          foregroundColor: AgrosafeTheme.cardBg(), // Couleur du texte et de l'icône
          minimumSize: const Size(double.infinity, 48), // Hauteur minimale du bouton
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AgrosafeTheme.radiusButtons)),
          elevation: 0, // pas d'ombre sous le bouton
        ),
      ),
    );
  }
}