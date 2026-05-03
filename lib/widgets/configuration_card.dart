// Importations des bibliothèques et fichiers nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/models/lot_config.dart'; // pour pouvoir accéder à la classe LotConfig
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour accéder à la traduction des textes
import 'package:avocadoguard/widgets/slider_alertes.dart'; // pour pouvoir créer les sliders des capteurs

class ConfigurationCard extends StatefulWidget {
  // Classe permettant de configurer l'affichage du widget de la page de configuration
  final LotConfig initialConfig; // permet de configurer la page par des valeurs pas défaut
  // Fonction permettant de sauvegarder la configuration enregistrée par l'utilisateur
  final Function(String capteur, String lot, String culture, double tempMax, double humidityMax, double co2Max, String frequency, DateTime? lastModified) onSave;

  const ConfigurationCard({
    // Constructeur de la classe
    super.key,
    required this.initialConfig,
    required this.onSave,
  });

  @override
  State<ConfigurationCard> createState() => _ConfigurationCardState(); // permet de créer l'état mutable de la classe
}

class _ConfigurationCardState extends State<ConfigurationCard> {
  // Classe permettant de gérer l'affichage du widget de la page de configuration
  
  // Valeurs par défaut de la page de configuration
  String _selectedFrequency = '5 min';
  double _temperatureMax = 7.0;
  double _humidityMax = 90.0;
  double _co2Max = 1000.0;
  late TextEditingController _capteurController;
  late TextEditingController _lotController;
  late TextEditingController _cultureController;

  @override
  void initState() {
    // Fonction permettant d'initialiser les valeurs des variables utilisées dans la page de configuration en fonction des données précédemment enregistrées
    // Si les données n'ont pas été modifiées précédemment par l'utilisateur on y met les valeurs par défaut configurés précédemment
    super.initState();
    _capteurController = TextEditingController(text: widget.initialConfig.capteurId);
    _lotController = TextEditingController(text: widget.initialConfig.lotName);
    _cultureController = TextEditingController(text: widget.initialConfig.culture);
    _temperatureMax = widget.initialConfig.temperatureMax;
    _humidityMax = widget.initialConfig.humidityMax;
    _co2Max = widget.initialConfig.co2Max;
    _selectedFrequency = widget.initialConfig.frequency;
  }

  @override
  void dispose() {
    // Fonction permettant de nettoyer les ressources utilisées par les contrôleurs de saisie de capteur, de noms de lot et de culture lorsque le widget de l'écrand de configuration est supprimé de l'arbre de widget pour éviter les fuites de mémoire
    _capteurController.dispose();
    _lotController.dispose();
    _cultureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Widget permettant d'afficher la carte de configuration sur la page de configuration du module 2
    final l10n = AppLocalizations.of(context)!; // permet de changer la langue des textes
    final isDesktop = MediaQuery.of(context).size.width > 600; // permet de modifier certains éléments en fonction de la taille de son écran (>600 pixels = écran d'ordinateur)

    return Container(
      width: double.infinity, // permet d'utiliser toute la largeur disponible
      padding: const EdgeInsets.all(AgrosafeTheme.cardPadding), // Marge interne de la carte
      // Style de la carte
      decoration: BoxDecoration(
        color: AgrosafeTheme.cardBg(),
        borderRadius: BorderRadius.circular(AgrosafeTheme.radiusCards),
        border: Border.all(color: AgrosafeTheme.borderColor()),
      ),
      child: Column( // Alignement vertical des éléments
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10), // Espace entre le haut de la carte et le titre de la première section

          // ------ IDENTIFIANT CAPTEUR ------
          // Titre de l'identification de capteur avec son style
          Text(l10n.capteurID,
            style: AgrosafeTheme.bodyText.copyWith(
              fontWeight: FontWeight.w600,
              color: AgrosafeTheme.textMuted()
            )  
          ),
          const SizedBox(height: 4), // Espace entre le titre et le champ de saisie
          // Champ de saisie du nom du capteur avec son style
          TextFormField(
            controller: _capteurController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10), // Espace entre le champ de saisie et le titre de la section suivante

          // ------ NOM DU LOT ------
          // Titre du nom du lot avec son style
          Text(l10n.lotID,
            style: AgrosafeTheme.bodyText.copyWith(
              fontWeight: FontWeight.w600,
              color: AgrosafeTheme.textMuted()
            )
          ),
          const SizedBox(height: 4), // Espace entre le titre et le champ de saisie
          // Champ de saisie et son style
          TextFormField(
            controller: _lotController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10), // Espace entre le champ de saisie et la section suivante

          // ------ CULTURE SURVEILLÉE ------
          // Titre de nom de la culture surveillée et son style
          Text(l10n.cultureID,
            style: AgrosafeTheme.bodyText.copyWith(
              fontWeight: FontWeight.w600,
              color: AgrosafeTheme.textMuted()
            )
          ),
          const SizedBox(height: 4), // Espace entre le titre et le champ de saisie
          // Champ de saisie et son style
          TextFormField(
            controller: _cultureController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10), // Espace entre le champ de saisie et le titre de la section suivante

          // ------ FRÉQUENCE DE MESURE ------
          // Titre de la fréquence entre chaque mise à jour des mesures
          Text(l10n.frequenceMesure,
            style: AgrosafeTheme.bodyText.copyWith(
              fontWeight: FontWeight.w600,
              color: AgrosafeTheme.textMuted()
            )
          ),
          const SizedBox(height: 8), // Espace entre le titre et les boutons de fréquences
          SizedBox( // Organisation des boutons sur une ligne
            width: double.infinity, // prend toute la largeur disponible
            child: Wrap( // Permet de modifier l'organisation du bloc en fonction de la taille de l'écran
              spacing: 8,
              runSpacing: 8,
              alignment: isDesktop
                  ? WrapAlignment.spaceBetween // si c'est un écran d'ordinateur, on les dispose sur une seule ligne, où les boutons sont bien séparés entre eux
                  : WrapAlignment.center, // si ce n'est pas un écran d'ordinateur, on les centre sur la carte avec possibilités de les placer sur 2 lignes
              children: [
                // Affichage des différentes boutons
                _frequencyButton('1 min'),
                _frequencyButton('5 min'),
                _frequencyButton('15 min'),
              ],
            ),
          ),
          const SizedBox(height: 30), // Espace entre la dernière ligne de bouton et la ligne séparatrice
          Divider(height: 1, color: AgrosafeTheme.borderColor()), // Ligne séparatrice et son style
          const SizedBox(height: 10), // Espace entre la ligne séparatrice et la section suivante (seuils FAO)

          // ------ SEUILS D'ALERTE ------
          // Organisation de la section différente en fonction de l'écran
          isDesktop
              // Cas écran d'ordinateur : organisation en ligne
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Titre de la section et son style
                    Text(l10n.seuilsAlerte,
                      style: AgrosafeTheme.displayTitle.copyWith(
                        fontSize: 25,
                        color: AgrosafeTheme.textPrimary()
                      )
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sous-titre de la section avec son style
                        Text(l10n.seuilsFAO,
                          style: AgrosafeTheme.bodyText.copyWith(color: AgrosafeTheme.textMuted())
                        ),
                        const SizedBox(height: 8), // Espace entre le sous-titre et le bouton de réinitialisation des valeurs des seuils d'alerte
                        // Bouton avec icône de réinitialisation des valeurs des seuils d'alerte
                        TextButton.icon(
                          onPressed: _resetToDefaults, // Action du bouton
                          icon: Icon(Icons.restart_alt, size: 22, color: AgrosafeTheme.textMuted()), // Affichage de l'icône avec son style
                          // Texte du bouton avec son style
                          label: Text(
                            l10n.seuilsParDefaut,
                            style: AgrosafeTheme.bodyText.copyWith(
                              fontSize: 16,
                              color: AgrosafeTheme.textMuted(),
                            ),
                          ),
                        ),
                      ],
                      ),
                  ],
                )
              // Cas écran mobile : organisation en colonne
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre de la section avec son style
                    Text(l10n.seuilsAlerte,
                      style: AgrosafeTheme.displayTitle.copyWith(
                        fontSize: 25,
                        color: AgrosafeTheme.textPrimary()
                      )
                    ),
                    const SizedBox(height: 4), // Espace entre le titre et le sous-titre de la section
                    // Sous-titre de la section
                    Text(l10n.seuilsFAO,
                      style: AgrosafeTheme.bodyText.copyWith(color: AgrosafeTheme.textMuted())
                    ),
                    const SizedBox(height: 8), // Espace entre le sous-titre et le bouton de réinitialisation des valeurs des seuils d'alerte
                    // Affichage du bouton de réinitialisation des valeurs des seuils d'alerte
                    TextButton.icon(
                      onPressed: _resetToDefaults, // Action du bouton
                      icon: Icon(Icons.restart_alt, size: 22, color: AgrosafeTheme.textMuted()), // Affichage de l'icône avec son style
                      // Texte du bouton avec son style
                      label: Text(
                        l10n.seuilsParDefaut,
                        style: AgrosafeTheme.bodyText.copyWith(
                          fontSize: 16,
                          color: AgrosafeTheme.textMuted(),
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 30), // Espace entre le bouton de réinitialisation des valeurs des seuils d'alerte et le seuil d'alerte de la température
          SliderAlertes(
            // Affichage du widget permettant de changer la valeur du seuil d'alerte de la température
            icon: '🌡️',
            label: l10n.temperatureMax,
            value: _temperatureMax, min: 0, max: 12, unit: '°C',
            onChanged: (v) => setState(() => _temperatureMax = v),
          ),
          const SizedBox(height: 20), // Espace entre le seuil d'alerte de la température et celui de l'humidité
          SliderAlertes(
            // Affichage du widget permettant de changer la valeur du seuil d'alerte de l'humidité
            icon: '💧',
            label: l10n.humidityMax,
            value: _humidityMax, min: 80, max: 100, unit: '%',
            onChanged: (v) => setState(() => _humidityMax = v),
          ),
          const SizedBox(height: 30), // Espace entre le seuil d'alerte de l'humidité et celui de la concentration de CO2
          SliderAlertes(
            // Affichage du widget permettant de changer la valeur du seuil d'alerte de la concentration de CO2
            icon: '🫧',
            label: l10n.co2Max,
            value: _co2Max, min: 800, max: 1200, unit: ' ppm',
            onChanged: (v) => setState(() => _co2Max = v),
          ),
          const SizedBox(height: 20), // Espace entre le slider et le bouton de validation et sauvegarde de la configuration
          // ------ BOUTON SAUVEGARDE ------
          ElevatedButton(
            style: AgrosafeTheme.primaryButtonStyle, // Style du bouton de sauvegarde
            // Action du bouton de sauvegarde : sauvegarde toutes les données dans des variables ensuite modifiées dans Firebase
            onPressed: () {
              final lotChanged = _lotController.text != widget.initialConfig.lotName;
              final cultureChanged = _cultureController.text != widget.initialConfig.culture;
              final newDate = (lotChanged || cultureChanged)
                ? DateTime.now()
                : widget.initialConfig.lastModified;
              widget.onSave(
                _capteurController.text,
                _lotController.text,
                _cultureController.text,
                _temperatureMax,
                _humidityMax,
                _co2Max,
                _selectedFrequency,
                newDate,
              );
              Navigator.pop(context);
            },
            child: Text(l10n.sauvegarder),
          ),
        ],
      ),
    );
  }

  // ========================================================================
  //                           MÉTHODES
  // ========================================================================
  void _resetToDefaults() {
    // Permet de remettre les paramètres par défaut pour les seuils d'alertes maximaux de température, d'humidité et de concentration de CO2
    setState(() {
      _temperatureMax = 7.0;
      _humidityMax = 90.0;
      _co2Max = 1000.0;
    });
  }

  Widget _frequencyButton(String label) {
    // Widget permettant d'afficher un bouton de fréquence en fonction du label mis en argument
    final isSelected = _selectedFrequency == label; // Variable permettant de connaître si le bouton est sélectionné
    // Action du bouton
    return GestureDetector(
      onTap: () => setState(() => _selectedFrequency = label), // permet de modifier le bouton si le bouton change d'état (sélectionné, non sélectionné)
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Taille du bouton
        // Style du bouton
        decoration: BoxDecoration(
          color: isSelected ? AgrosafeTheme.iconeColor() : AgrosafeTheme.bg(), // Changement de couleur si le bouton est sélectionné
          borderRadius: BorderRadius.circular(AgrosafeTheme.radiusCards),
          border: Border.all(
            color: isSelected ? AgrosafeTheme.iconeColor() : AgrosafeTheme.iconeColor().withValues(alpha: 0.75),
            width: 1.5,
          ),
        ),
        // Affichage du texte du bouton avec son style
        child: Text(
          label,
          style: AgrosafeTheme.bodyText.copyWith(
            color: isSelected ? AgrosafeTheme.cardBg() : AgrosafeTheme.mossPolice(),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}