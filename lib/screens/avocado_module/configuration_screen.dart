// Importations des bibliothèques nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/core/models/lot_config.dart'; // pour sauvegarder et accéder aux données
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour changer la langue des textes
import 'package:avocadoguard/widgets/bottom_nav.dart'; // pour avoir la barre de navigation
import 'package:avocadoguard/widgets/configuration_card.dart'; // pour afficher la carte de configuration

class ConfigurationScreen extends StatelessWidget {
  // Classe permettant de configurer l'écran de configuration des capteurs utilisés dans le module 2
  final LotConfig initialConfig; // permet de donner une configuration par défaut
  final Function(String capteur, String lot, String culture, double tempMax, double humidityMax, double co2Max, String frequency, DateTime? lastModified) onSave; // permet de sauvegarder les données entrées et choisies
  final Function(int) onNavigate; // permet de naviguer sur les différents écrans

  const ConfigurationScreen({
    // Constructeur de la classe
    super.key,
    required this.initialConfig,
    required this.onSave,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AgrosafeTheme.bg(),
      // Flèche de retour
      appBar: AppBar(
        backgroundColor: AgrosafeTheme.bg(),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AgrosafeTheme.textPrimary()),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        // Possibilité de scroller sur la page
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AgrosafeTheme.screenHorizontalPadding,
            vertical: 20,
          ),
          child: Column(
            // Alignement sur la gauche de la page
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.configuration,
                style: AgrosafeTheme.displayTitle.copyWith(color: AgrosafeTheme.textPrimary()),
              ),
              const SizedBox(height: 20),
              // Affichage du Widget (carte) de configuration
              ConfigurationCard(
                initialConfig: initialConfig,  // remplissage de la configuration avec les données enregistrées ou celles par défaut
                onSave: onSave,
              ),
              const SizedBox(height: 10), // Permet de laisser un espace avant la barre de navigation
            ],
          ),
        ),
      ),
      // Barre de navigation
      bottomNavigationBar: AgrosafeBottomNav(
        selectedIndex: 1, // permet de se localiser sur l'application (module 2)
        // Permet de naviguer sur la barre de navigation et de se localiser
        onDestinationSelected: (index){
          Navigator.pop(context);
          onNavigate(index);
        },
      ),
    );
  }
}