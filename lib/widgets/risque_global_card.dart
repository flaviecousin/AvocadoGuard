// Importation des bibliothèques
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/models/lot_config.dart'; // pour accéder à LotConfig
import 'package:avocadoguard/core/services/config_service.dart'; // permet de récupérer les données enregistrées de LotConfig dans Firebase
import 'package:avocadoguard/core/services/user_service.dart'; // pour pouvoir accéder aux mesures sauvegardées dans Firestore
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour pouvoir changer la langue de la page

class RiskCard extends StatefulWidget {
  // Classe permettant de configurer la carte de risque de la page de rapport du lot
  final DateTime end;
  final DateTime beginning;
  
  const RiskCard({
    // Constructeur de la classe
    super.key,
    required this.beginning,
    required this.end,
  });

  @override
  // Permet d'avoir l'état mutable associé à ce widget
  State<RiskCard> createState() => _RiskCardState();
}

class _RiskCardState extends State<RiskCard> {
  // Classe permettant de gérer l'affichage de la carte du risque global page de rapport du lot
  
  // On récupère la classe LotConfig qu'on remplit avec les données par défaut
  LotConfig _config = LotConfig(
    capteurId: 'ESP32_AVOC_003',
    lotName: 'Lot n°X',
    culture: 'Avocat Hass',
  );

  List<Map<String, dynamic>> _mesures = []; // Variable permettant de récupérer les mesures sauvegardées dans Firestore
  bool _loading = true; // Variable permettant de connaître si les données sont encore en cours de chargement

  // Objet permettant d'initialiser le chargement des données
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Fonction permettant de charger les données
    final config = await ConfigService.loadConfig(); // permet de récupérer les données de LotConfig
    final mesures = await UserService.getMesuresPeriode( // permet de récupérer les mesures sur la période
        widget.beginning, widget.end);
    if (mounted) {
      setState(() {
        _config = config;
        _mesures = mesures;
        _loading = false;
      });
    }
  }

  double _calculateRiskScore() {
    // Fonction permettant de calculer le risque global
    if (_mesures.isEmpty) return 0.0;
    // On filtre les mesures complètes (pas de -999)
    final valides = _mesures.where((r) =>
        (r['temperature'] as num) != -999 &&
        (r['humidity'] as num) != -999 &&
        (r['co2'] as num) != -999).toList();
    if (valides.isEmpty) return 0.0;

    int alertCount = 0;
    for (final r in valides) {
      // On compte le nombre d'alertes
      if ((r['temperature'] as num) > _config.temperatureMax) alertCount++;
      if ((r['humidity'] as num) > _config.humidityMax) alertCount++;
      if ((r['co2'] as num) > _config.co2Max) alertCount++;
    }
    return alertCount / (valides.length * 3);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // pour changer la langue des textes

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final score = _calculateRiskScore(); // On récupère le score de risque global
    final String riskLabel; // Label de la carte
    final Color riskColor; // Couleur du label
    // On associe au score un label et une couleur
    if (score < 0.2) {
      riskLabel = l10n.faible;
      riskColor = AgrosafeTheme.safe;
    } else if (score < 0.5) {
      riskLabel = l10n.modere;
      riskColor = AgrosafeTheme.warning;
    } else {
      riskLabel = l10n.eleve;
      riskColor = AgrosafeTheme.danger;
    }

    // Configuration de l'affichage de la carte
    return Container(
      padding: const EdgeInsets.all(AgrosafeTheme.cardPadding), // marge interne
      // Style de la carte
      decoration: BoxDecoration(
        color: AgrosafeTheme.cardBg(),
        borderRadius: BorderRadius.circular(AgrosafeTheme.radiusCards),
        border: Border.all(color: AgrosafeTheme.borderColor()),
      ),
      child: Column( // Organisation en colonne de la carte
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Affichage du titre de la carte et de son style
          Text(l10n.scoreRisqueGlobal,
            style: AgrosafeTheme.labelsText.copyWith(color: AgrosafeTheme.textMuted())),
          const SizedBox(height: 10), // Espace entre le titre et le label
          // Affichage du label de la carte et son style
          Text(riskLabel,
            style: AgrosafeTheme.displayTitle.copyWith(color: riskColor)),
          const SizedBox(height: 12), // Espace entre le label et la barre graphique
          // Affichage de la barre
          LayoutBuilder(builder: (context, constraints) {
            final filledWidth = constraints.maxWidth * score;
            return ClipRRect(
              // Coins et bordures droite et gauche arrondis
              borderRadius: BorderRadius.circular(4),
              child: Stack(children: [
                Container(
                  height: 8,
                  // Style de l'intérieur de la barre
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [ // Dégradé de vert à orange à rouge
                      AgrosafeTheme.safe,
                      AgrosafeTheme.warning,
                      AgrosafeTheme.danger
                    ]),
                  ),
                ),
                Positioned(
                  left: filledWidth,
                  top: 0, bottom: 0, right: 0,
                  child: Container(
                    // Couleur de l'intérieur de la barre quand elle n'est pas remplie
                    color: AgrosafeTheme.borderColor().withValues(alpha: 0.85)
                  ),
                ),
              ]),
            );
          }),
        ],
      ),
    );
  }
}