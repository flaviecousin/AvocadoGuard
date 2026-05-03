// Importation des bibliothèques nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/models/connection_status.dart';
import 'package:avocadoguard/core/models/lot_config.dart'; // pour accéder à la configuration du lot
import 'package:avocadoguard/core/services/config_service.dart'; // pour charger la configuration du lot
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/core/services/user_service.dart'; // pour pouvoir connaître le statut de connexion
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour la traduction des textes
import 'package:avocadoguard/screens/history/historique_screen.dart'; // pour pouvoir accéder à l'historique
import 'package:avocadoguard/screens/reports/rapport_lot_screen.dart'; // pour pouvoir accéder au rapport du mois actuel
import 'package:avocadoguard/widgets/alert_banner.dart';
import 'package:avocadoguard/widgets/live_indicator.dart'; // pour afficher le statut de connexion en temps réel
import 'package:avocadoguard/widgets/module_tag.dart'; // pour afficher les tags des modules
import 'package:avocadoguard/widgets/risque_global_card.dart'; // pour afficher la carte du risque de la dernière heure
import 'package:avocadoguard/widgets/summary_cards.dart'; // pour afficher les cartes de résumé des modules

class HomeScreen extends StatefulWidget {
  // Classe permettant de configurer l'affichage de la page d'accueil
  final Function(int) onNavigate; // permet de naviguer vers les différentes pages
  
  const HomeScreen({
    // Constructeur de la classe
    super.key,
    required this.onNavigate,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState(); // Création de l'état de la classe HomeScreen
}

class _HomeScreenState extends State<HomeScreen> {
  // Classe permettant de gérer l'affichage de la page d'accueil

  // On récupère la classe LotConfig qu'on remplit avec les données par défaut
  LotConfig _config = LotConfig(
    capteurId: 'ESP32_AVOC003',
    lotName: 'Lot n°X',
    culture: 'Avocat Hass',
  );
  bool _capteurConnecte = false;

  @override
  // Object permettant d'appeler et d'initialiser _loadConfig au lancement de la page d'accueil pour charger la configuration du lot
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    // Un seul passage Firestore pour tout charger
    final results = await Future.wait([
      ConfigService.loadConfig(),
      UserService.getLastMesureDate(),
      UserService.getLastMesure(),
    ]);

    final config   = results[0] as LotConfig;
    final lastDate = results[1] as DateTime?;
    final mesure   = results[2] as Map<String, dynamic>?;

    setState(() {
      _config     = config;
      _lastMesure = lastDate;
      _capteurConnecte = lastDate != null &&
          DateTime.now().difference(lastDate).inMinutes <= 5;

      if (mesure != null) {
        _temperature = (mesure['temperature'] as num?)?.toDouble() ?? -999;
        _humidity    = (mesure['humidity']    as num?)?.toDouble() ?? -999;
        _co2         = (mesure['co2']         as num?)?.toInt()    ?? -999;
      }
    });
  }

  // Variables des mesures
  double _temperature = -999;
  double _humidity = -999;
  int _co2 = -999;
  DateTime? _lastMesure;

  ConnectionStatus get _connectionStatus {
    // Fonction permettant de gérer le statut de la connexion à la carte
    if (_lastMesure == null) return ConnectionStatus.offline; // si pas connecté
    final diff = DateTime.now().difference(_lastMesure!); // on récupère le temps passé depuis le dernier changement de donnée
    if (diff.inMinutes < 5)  return ConnectionStatus.live; // si pas de changement de donnée depuis 5 min = en direct
    if (diff.inMinutes < 15) return ConnectionStatus.delayed; // si pas de changement de donnée depuis 15 min = en retard
    return ConnectionStatus.offline; // sinon on affiche le témoin déconnecté
  }

  @override
  Widget build(BuildContext context) {
    // Widget permettant de configurer l'affichage de la page d'accueil
    final l10n = AppLocalizations.of(context)!; // permet de changer la langue des textes
    final now = DateTime.now(); // Récupération de la date d'aujourd'hui
    final heure = now.subtract(const Duration(hours: 1)); // Récupération de la date d'il y a 30 jours
    return SafeArea(
      child: SingleChildScrollView( // permet de scroller sur la page d'accueil si le contenu dépasse la taille de l'écran
        padding: const EdgeInsets.symmetric( // Marge interne de la page d'accueil
          horizontal: AgrosafeTheme.screenHorizontalPadding,
          vertical: 20,
        ),
        child: Column( // Alignement vertical des éléments de la page d'accueil
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Affichage du message de la page d'accueil et son style
            Text(
              l10n.bonjour,
              style: AgrosafeTheme.displayTitle.copyWith(color: AgrosafeTheme.textPrimary()),
            ),
            const SizedBox(height: 10), // Espace entre le message de bienvenue et le sous-titre de la page
            // Affichage du sous-titre de la page d'accueil et son style
            Text(
              l10n.vueEnsemble,
              style: AgrosafeTheme.bodyText.copyWith(color: AgrosafeTheme.textMuted()),
            ),
            const SizedBox(height: 30), // Espace entre le sous-titre et la carte de résumé du module 1
            // ------- AFFICHAGE MODULE 2 -------
            ModuleSummaryCard(
              tagType: ModuleTagType.module2, // tag du module 2
              title: l10n.stockageAvocat, // titre de la carte du module 2
              subtitle: '${_config.lotName} — ${_config.capteurId}',  //texte du lot et du capteur configurés dans le module 2
              trailing: LiveIndicator(status: _capteurConnecte
                ? ConnectionStatus.live
                : ConnectionStatus.offline,
              ), // Statut de la connexion à la carte
              ctaLabel: l10n.voirDashboard, // Texte du bouton de la carte du module 2
              onCtaTap: () => widget.onNavigate(1),  // Action du bouton de la carte du module 2 pour naviguer vers sa page
            ),

            const SizedBox(height: 15), // Espace entre la carte de résumé du module 2 et les boutons d'accès aux modules
            // ------- AFFICHAGE DES 2 MODULES -------
            Row( // Organisation horizontale des boutons d'accès aux modules
              children: [
                // Bouton d'accès au module 1 avec une icône
                Expanded(
                  child: ElevatedButton.icon(
                    style: AgrosafeTheme.primaryButtonStyle, // Style du bouton
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoriqueScreen(onNavigate: widget.onNavigate),
                        ),
                      );
                    },
                    icon: const Icon(Icons.bar_chart), // Icône du bouton
                    label: Text(l10n.historique), // Texte du bouton
                  ),
                ),
                const SizedBox(width: 15), // Espace entre les 2 boutons
                // Bouton d'accès au module 2 avec une icône
                Expanded(
                  child: ElevatedButton.icon(
                    style: AgrosafeTheme.secondaryButtonStyle, // Style du bouton
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RapportLotScreen(onNavigate: widget.onNavigate),
                        ),
                      );
                    },
                    icon: const Icon(Icons.assignment_outlined), // Icône du bouton
                    label: Text(l10n.rapportLot), // Texte du bouton
                  ),
                ),
              ],
            ),
            const SizedBox(height:15),
            // ------ AFFICHAGE SCORE GLOBAL ------
            RiskCard(
              beginning: heure,
              end: now
            ),
            const SizedBox(height: 15),
            // ------ AFFICHAGE ALERTES ------
            if (true) ...[
              // Affichage de la bannière d'alerte
              AlertBanner(
                temperature: _temperature,
                humidity: _humidity,
                co2: _co2,
                config: _config,
                connectionStatus: _connectionStatus
              ),
            ],
          ]
        ),
      ),
    );
  }
}