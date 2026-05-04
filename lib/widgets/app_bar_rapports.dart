// Importation des bibliothèques et fichiers nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour accéder à la traduction des textes
import 'package:avocadoguard/widgets/module_tag.dart'; // pour afficher le tag du module 2

class AppBarRapport extends StatelessWidget{
  // Classe permettant de configurer l'en-tête des pages de rapport
  final DateTime beginningDate; // Récupération de la date du début du rapport
  final DateTime endDate; // Récupération de la date de la fin du rapport
  
  const AppBarRapport({
    // Constructeur de la classe
    super.key,
    required this.beginningDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context){
    // Widget gérant l'affichage de l'en-tête
    final l10n = AppLocalizations.of(context)!;
    // Formatage de la date de début du rapport
    final dateDebut = '${beginningDate.year}-${beginningDate.month.toString().padLeft(2, '0')}-${beginningDate.day.toString().padLeft(2, '0')}';
    // Formatage de la date de fin du rapport
    final dateFin = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 6), // Marge de l'en-tête
      child: Row( // utilisation de Row pour pouvoir afficher les éléments les uns à côté des autres
        crossAxisAlignment: CrossAxisAlignment.start, // Alignement
        children: [
          // Action de la flèche de retour
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SizedBox(
              width: 36, height: 36, // Début de la marge
              // Affichage de l'icône avec son style
              child: Icon(Icons.arrow_back, color: AgrosafeTheme.textPrimary()),
            ),
          ),
          const SizedBox(width: 10), // Espace avant de mettre le texte
          Column( // Ajout de 2 éléments l'un en dessous de l'autre
            crossAxisAlignment: CrossAxisAlignment.start, // Alignement
            children: [
            const ModuleTag(type: ModuleTagType.module2), // Affichage du tag du module 2
            const SizedBox(height: 4), // Espace entre les 2 éléments
            // Affichage du texte
            Text(l10n.rapportTitre,
              // Style du titre
              style: AgrosafeTheme.displayTitle.copyWith(
                color: AgrosafeTheme.textPrimary()
              )
            ),
            const SizedBox(height: 10),
            // Texte de la période de temps étudiée pour le rapport
            Text('$dateDebut - $dateFin',
              style: AgrosafeTheme.dataText.copyWith(
                color: AgrosafeTheme.muted)),
          ]),
      ]),
    );
  }

}