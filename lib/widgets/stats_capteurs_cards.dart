// Importation de la bibliothèque et des fichiers nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/constants/stat_data_list.dart'; // pour accéder à une classe (permet de lister des données d'une certaine façon)
import 'package:avocadoguard/core/models/lot_config.dart'; // pour accéder à LotConfig
import 'package:avocadoguard/core/services/config_service.dart'; // permet de récupérer les données enregistrées de LotConfig dans Firebase
import 'package:avocadoguard/core/services/user_service.dart'; // pour pouvoir récupérer les mesures sauvegardées dans Firestore
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour pouvoir changer la langue de la page

class StatsCapteursCards extends StatefulWidget {
  // Classe permettant de configurer la grille des statistiques de la page de rapport du lot
  final DateTime beginning; // Début de la période
  final DateTime end; // Fin de la période
  final bool showDuree; // Pour pouvoir choisir de ne pas afficher la durée de stockage
  
  const StatsCapteursCards({
    // Constructeur de la classe
    super.key,
    required this.beginning,
    required this.end,
    this.showDuree=true, // on l'affiche par défaut
  });

  @override
  // Permet d'avoir l'état mutable associé à ce widget
  State<StatsCapteursCards> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCapteursCards> {
  // Classe permettant de gérer l'affichage de la grille de statistiques de la page de rapport du lot

  // On récupère la classe LotConfig qu'on remplit avec les données par défaut
  LotConfig _config = LotConfig(
    capteurId: 'ESP32_AVOC_003',
    lotName: 'Lot n°X',
    culture: 'Avocat Hass',
  );
  List<Map<String, dynamic>> _mesures = []; // Variable permettant de récupérer les mesures sauvegardées dans Firestore
  bool _loading = true; // Variable permettant de connaître si les données sont encore en cours de chargement

  @override
  // Permet d'appeler et d'initialiser le chargement des données
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Fonction permettant de charger les données
    final config = await ConfigService.loadConfig(); // Récupération des données de LotConfig
    final mesures = await UserService.getMesuresPeriode( // Récupération des mesures sur la période concernée
        widget.beginning, widget.end);
    if (mounted) { // Permet de ne pas récupérer si l'utilisateur a quitté la page
      setState(() {
        _config = config;
        _mesures = mesures;
        _loading = false;
      });
    }
  }

  // Filtre les -999 pour un capteur donné
  List<double> _valeurs(String champ) => _mesures
      .map((r) => (r[champ] as num).toDouble())
      .where((v) => v != -999)
      .toList();

  double _tempMoy() {
    // Fonction permettant de calculer la moyenne des températures sur la période
    final val = _valeurs('temperature');
    if (val.isEmpty) return 0;
    return val.reduce((a, b) => a + b) / val.length;
  }

  double _co2Moy() {
    // Fonction permettant de calculer la moyenne de concentration de CO2 sur la période
    final val = _valeurs('co2');
    if (val.isEmpty) return 0;
    return val.reduce((a, b) => a + b) / val.length;
  }

  double _hrMax() {
    // Fonction permettant de calculer le taux d'humidité maximum sur la période
    final val = _valeurs('humidity');
    if (val.isEmpty) return 0;
    return val.reduce((a, b) => a > b ? a : b);
  }

  // Fonction permettant de récupérer le nombre de mesures totales sur la période
  int _nbMesures() => _mesures
    .where((r) =>
      (r['temperature'] as num) != -999 ||
      (r['humidity'] as num) != -999 ||
      (r['co2'] as num) != -999)
    .length;

  int _nbAlertes() {
    // Fonction permettant de récupérer le nombre d'alertes sur la période
    int count = 0;
    for (final r in _mesures) {
      if ((r['temperature'] as num) != -999 &&
        (r['temperature'] as num) > _config.temperatureMax) {
        count++;
      }
      if ((r['humidity'] as num) != -999 &&
        (r['humidity'] as num) > _config.humidityMax){
        count++;
      }
      if ((r['co2'] as num) != -999 &&
        (r['co2'] as num) > _config.co2Max){ 
        count++;
      }
    }
    return count;
  }

  Color _colorTemp(double temp) {
    // Fonction permettant d'assigner une couleur à la valeur de la température moyenne en fonction du seuil de limite configuré par l'utilisateur
    if (temp > _config.temperatureMax) return AgrosafeTheme.danger;
    if (temp == _config.temperatureMax) return AgrosafeTheme.warning;
    return AgrosafeTheme.safe;
  }

  Color _colorCO2(double co2) {
    // Fonction permettant d'assigner une couleur à la valeur de la concentration de CO2 moyen en fonction du seuil de limite configuré par l'utilisateur
    if (co2 > _config.co2Max) return AgrosafeTheme.danger;
    if (co2 == _config.co2Max) return AgrosafeTheme.warning;
    return AgrosafeTheme.safe;
  }

  Color _colorHR(double humidite) {
    // Fonction permettant d'assigner une couleur à la valeur du taux d'humidité maximal en fonction du seuil de limite configuré par l'utilisateur
    if (humidite > _config.humidityMax) return AgrosafeTheme.danger;
    if (humidite == _config.humidityMax) return AgrosafeTheme.warning;
    return AgrosafeTheme.safe;
  }

  @override
  Widget build(BuildContext context) {
    // Widget gérant l'affichage des différentes cartes des statistiques de la période
    final l10n = AppLocalizations.of(context)!; // pour changer la langue des textes

    // Affiche un loader pendant le chargement
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Récupération des valeurs calculées précédemment
    final moyTemp = _tempMoy(); // Température moyenne de la période
    final maxHR = _hrMax(); // Taux d'humidité maximum
    final co2Moy = _co2Moy(); // Concentration de CO2 moyenne
    // Récupération du temps qu'il s'est passé depuis la dernière modification (= durée de stockage du lot)
    final debutStockage = _config.lastModified;
    final dureeStockage = debutStockage != null
      ? DateTime.now().difference(debutStockage).inDays < 2
        ? '${DateTime.now().difference(debutStockage).inDays} ${l10n.jour}'
        : '${DateTime.now().difference(debutStockage).inDays} ${l10n.jours}'
      : '-';

    // Organisation des données pour pouvoir les afficher ensuite
    final items = <StatData>[
      // On veut afficher cette donnée uniquement sur le rapport actuel, pas sur les 3 autres
      if(widget.showDuree)
        StatData(
          label: l10n.duree,
          value: dureeStockage,
          valueColor: AgrosafeTheme.textPrimary()
        ),
      StatData(
        label: l10n.alertes,
        value: '${_nbAlertes()}',
        valueColor: AgrosafeTheme.warning
      ),
      StatData(
        label: l10n.moyTemp,
        value: _valeurs('temperature').isEmpty
          ? '-'
          : '${moyTemp.toStringAsFixed(1)}°C',
          valueColor: _colorTemp(moyTemp)
        ),
      StatData(
        label: l10n.maxHR,
        value: _valeurs('humidity').isEmpty
          ? '-'
          : '${maxHR.toStringAsFixed(0)}%',
          valueColor: _colorHR(maxHR)
      ),
      StatData(
        label: l10n.co2Moy,
        value: _valeurs('co2').isEmpty
          ? '-'
          : '${co2Moy.toStringAsFixed(0)} ppm',
        valueColor: _colorCO2(co2Moy)
      ),
      StatData(
        label: l10n.totMesure,
        value: '${_nbMesures()}',
        valueColor: AgrosafeTheme.textPrimary()
      ),
    ];

    // Affichage des différentes cartes des statistiques
    return GridView.builder( // Vue en grille
      shrinkWrap: true, // permet de scroller sur la page
      physics: const NeverScrollableScrollPhysics(), // permet de ne pas scroller sur chaque case de la grille
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( // Gère la disposition de la grille
        crossAxisCount: 2, // 2 cartes par ligne
        mainAxisSpacing: 10, // Espace entre les cartes
        crossAxisSpacing: 10,
        // Permet de changer la disposition en fonction de la largeyr de l'écran (ordinateur / smartphones)
        mainAxisExtent: MediaQuery.of(context).size.width > 600 ? 110 : 120,
      ),
      itemCount: items.length, // Nombre de cartes
      itemBuilder: (_, i) => Container(
        padding: const EdgeInsets.all(14), // Marges des cartes
        // Style des cartes
        decoration: BoxDecoration(
          color: AgrosafeTheme.cardBg(),
          borderRadius: BorderRadius.circular(AgrosafeTheme.radiusInputFields), // Coins arrondis
          border: Border.all(color: AgrosafeTheme.borderColor()),
        ),
        // Disposition des cartes sur la page
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center, // Cartes centrées sur la page
          children: [
            //  Titre des cartes et leurs styles
            Text(items[i].label,
              style: AgrosafeTheme.labelsText.copyWith(
                color: AgrosafeTheme.textMuted()),
              maxLines: 2
            ),
            const SizedBox(height: 6), // Espace avant les valeurs
            // Affichage des valeurs avec le style défini précédemment (dans la liste)
            Text(items[i].value,
              style: AgrosafeTheme.bodyText.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: items[i].valueColor)
            ),
          ],
        ),
      ),
    );
  }
}