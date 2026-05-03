// Importations des bibliothèques
import 'dart:async'; // pour pouvoir utiliser gérer les opérations asynchrones
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/app_notifiers.dart'; // pour pouvoir envoyer ou non des notifications (en fonction des préférences enregistrées)
import 'package:avocadoguard/core/services/realtime_service.dart'; // pour pouvoir accéder à la base de données Firebase Realtime Database
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour pouvoir changer la langue de la page
import 'package:avocadoguard/core/models/connection_status.dart'; // pour pourvoir afficher le statut de connexion au module 2
import 'package:avocadoguard/core/models/lot_config.dart'; // pour pouvoir accéder à la classe de LotConfig
import 'package:avocadoguard/core/services/config_service.dart'; // pour pouvoir accéder aux données sauvegardées de la classe LotConfig
import 'package:avocadoguard/core/services/notification_service.dart'; // pour pouvoir envoyer des notifications en fonction de l'appareil de l'utilisateur
import 'package:avocadoguard/core/services/user_service.dart'; // pour pouvoir enregistrer les alertes
import 'package:avocadoguard/core/theme/app_theme.dart'; // pour pouvoir accéder au thème de l'application
import 'package:avocadoguard/screens/avocado_module/configuration_screen.dart'; // pour accéder à la page de configuration
import 'package:avocadoguard/screens/history/historique_screen.dart'; // pour accéder à la page historique
import 'package:avocadoguard/screens/reports/rapport_lot_screen.dart'; // pour accéder à la page du rapport du lot
import 'package:avocadoguard/widgets/alert_banner.dart';
import 'package:avocadoguard/widgets/gestion_card_bai.dart'; // pour afficher la carte de mesure BAI
import 'package:avocadoguard/widgets/gestion_carte_action_module2.dart'; // pour pouvoir gérer les cartes action
import 'package:avocadoguard/widgets/gestion_carte_mesure_module2.dart'; // pour pouvoir gérer les cartes mesures
import 'package:avocadoguard/widgets/live_indicator.dart'; // pour pouvoir afficher le statut de la connexion de la carte
import 'package:avocadoguard/widgets/module_tag.dart'; // pour pouvoir afficher le tag du module 2
import 'package:avocadoguard/widgets/seuils_dynamiques.dart'; // pour pouvoir afficher les seuils dynamiques

class Module2Screen extends StatefulWidget {
  // Classe permettant de configurer la page générale du module 2
  final Function(int) onNavigate; // fonction permettant de naviguer entre différentes pages
  
  const Module2Screen({
    // Constructeur de la classe
    super.key, 
    required this.onNavigate
  });

  @override
  // Permet d'avoir l'état mutable associé à ce widget
  State<Module2Screen> createState() => _Module2ScreenState();
}

class _Module2ScreenState extends State<Module2Screen> {
  // Classe permettant de gérer l'affiche de la page générale du module 2

  // On récupère la valeur du temps actuel si problème on renvoie le temps actuel
  DateTime? _lastMesure;
  // Valeur de la dernière fois que l'affichage a été mis à jour
  DateTime? _lastDisplay;
  // Variable permettant de recalculer le temps qui se passe
  Timer? _clockTimer;
  // Variable pour écouter Firebase
  StreamSubscription? _subscription; 

  // On récupère la classe LotConfig qu'on remplit avec les données par défaut
  LotConfig _config = LotConfig(
    capteurId: 'ESP32_AVOC_003',
    lotName: 'Lot n°X',
    culture: 'Avocat Hass',
  );

  // ------ DONNÉES SIMULÉES À L'INSTANT T ------
  double _temperature = -999;
  double _humidity = -999;
  int _co2 = -999;
  double _bai = -999;

  ConnectionStatus get _connectionStatus {
    // Fonction permettant de gérer le statut de la connexion à la carte
    if (_lastMesure == null) return ConnectionStatus.offline; // si pas connecté
    final diff = DateTime.now().difference(_lastMesure!); // on récupère le temps passé depuis le dernier changement de donnée
    if (diff.inMinutes < 5)  return ConnectionStatus.live; // si pas de changement de donnée depuis 5 min = en direct
    if (diff.inMinutes < 15) return ConnectionStatus.delayed; // si pas de changement de donnée depuis 15 min = en retard
    return ConnectionStatus.offline; // sinon on affiche le témoin déconnecté
  }

  // Object permettant d'appeler et d'initialiser _loadConfig
  @override
  void initState() {
    super.initState();
    _loadConfig().then((_) => _checkAlerts());
    _listenToRealtime(); // pour écouter Firebase Realtime
    // Permet de rafraîchir l'affichage du temps de la dernière mesure affichée toutes les 30 secondes
    _clockTimer=Timer.periodic(const Duration(seconds:30),(_){
      if (mounted) setState((){});
    });
  }
  // Permet de remplir les valeur de LotConfig avec les valeurs de configuration enregistrées précédemment
  Future<void> _loadConfig() async {
    final config = await ConfigService.loadConfig();
    final lastDate = await UserService.getLastMesureDate();
    setState(() {
      _config = config;
      _lastMesure=lastDate; // permet de récupérer la valeur de la dernière modification
    });
    _checkAlerts(); // vérifie s'il y a des alertes
  }

  // Permet de récupérer la valeur de fréquence choisie par l'utilisateur et enregistrée dans Firestore et d'afficher les valeurs de mesures selon cette fréquence
  int get _frequenceMinutes{
    final freq = _config.frequency;
    final parsed = int.tryParse(freq.replaceAll(RegExp(r'[^0-9]'), ''));
    // int.tryParse() permet de transformer le String en int
    // RegExp(r'[^0-9]') permet de trouver tout ce qui n'est pas un chiffre
    // .replaceAll(RegExp(r'[^0-9]'), '') permet de remplacer tous les caractères qui ne sont pas des chiffres par rien
    return parsed ?? 5; // on retourne par défaut une fréquence de 5 minutes s'il y a un problème de parsing
  }

  void _listenToRealtime() {
    // Fonction permettant d'écouter en continu les données de la base de données Firebase Realtime Database
    // Le stream se déclenche à chaque nouvelle donnée envoyée par la carte
    _subscription = RealtimeService.watchData().listen(
      // .listen() s'abonne au stream, chaque donnée déclenche ce bloc
      // _subscription permet d'annler l'écoute dans dispose() pour éviter les fuites mémoire
      (data) async {
        // 'data' contient les nouvelles valeurs reçues de la carte
        final now = DateTime.now(); // récupère le temps actuel
        final shouldDisplay = _lastDisplay == null ||
          now.difference(_lastDisplay!).inMinutes >= _frequenceMinutes;
        // Calcule si on doit rafraîchir l'affichage selon la fréquence configurée par l'utilisateur
        //_lastDisplay== null => premier affichage, on affiche toujours
        // sinon on vérifie si assez de temps s'est écoulé depuis le dernier affichage
        
        // ------ SAUVEGARDE FIRESTORE ------
        if (RealtimeService.isValid(data['temperature']) ||
            RealtimeService.isValid(data['humidity']) ||
            RealtimeService.isValid(data['co2'].toDouble()) ||
            RealtimeService.isValid(data['bai'])) {
          // On sauvegarde uniquement si au moins une valeur est valide (différente de -999)
          // La sauvegarde se fait à chaque donnée reçue, indépendamment de la fréquence
          await UserService.saveMesure(
            temperature: data['temperature'],
            humidity: data['humidity'],
            co2: data['co2'],
            bai: data['bai'],
          );
          setState(() {
            _lastMesure=now; // Met à jour le timestamp de la dernière mesure sauvegardée
          });
        }
        else{
          // Toutes les valeurs sont invalides, on ne sauvegarde rien dans Firestore
          //print('[Realtime] Mesure non sauvegardée car valeurs invalides');
        }

        // ------ RAFRAÎCHISSEMENT DE L'AFFICHAGE ------
        if (shouldDisplay){
          // La fréquence configurée est atteinte on met à jour l'affichage
          setState(() {
            _temperature=(data['temperature'] as num).toDouble();
            _humidity=(data['humidity'] as num).toDouble();
            _co2=(data['co2'] as num).toInt();
            _bai=(data['bai'] as num).toDouble();
            _lastMesure = DateTime.now();
            _lastDisplay = now; // on mémorise le moment du dernier affichage
            // pour calculer le prochain rafraîchissement
          });
          _checkAlerts(); // Nouvelle vérification pour les alertes avec les nouvelles valeurs affichées
        }
        else{
          //Fréquence non atteinte : on ne met pas à jour les valeurs affichées
          // On met quand même à jour _lastMesure pour que le label "dernière mesure il y a X min" reste correct
          setState(() {
            _lastMesure = DateTime.now();
          });
        }
      },
      onError: (e) {
        // En cas d'erreur du stream (perte de connexion, erreur Firebase, ...)
        // Le setState vide force un rebuild pour que _connectionStatus recalcule automatiquement le statut via le getter qui se base sur _lastMesure
        setState((){});
      },
    );
  }

  @override
  void dispose(){
    _subscription?.cancel(); // pour éviter les fuites de mémoire
    _clockTimer?.cancel(); // pour arrêter le timer périodique proprement afin d'éviter les fuites de mémoire
    super.dispose();
  }

  // Permet d'envoyer des alertes quand l'application est ouverte et si les notifications sont autorisées si besoin est
  Future<void> _checkAlerts() async {
    final locale = localeNotifier.value.languageCode;
    final l10n = AppLocalizations.of(context)!;
    // ------ TEMPÉRATURE ------
    if (_temperature > _config.temperatureMax) {
      final message = '${l10n.alerteTemp} - $_temperature °C > ${_config.temperatureMax}°C'; // Message de l'alerte sauvegardée
      await UserService.saveAlerte(nom: 'alerte_temperature', message: message); // Sauvegarde de l'alerte
      // Notification envoyée si elles sont activées
      if (notificationsNotifier.value) {
        await NotificationService.sendAlert(
          type: 'alerte_temperature',
          valeur: _temperature,
          seuil: _config.temperatureMax,
          locale: locale,
        );
      }
    }
    // ------ ALERTE HUMIDITÉ ------
    if (_humidity > _config.humidityMax) {
      final message = '${l10n.alerteHumid} - $_humidity% > ${_config.humidityMax}%'; // Message de l'alerte sauvegardée
      await UserService.saveAlerte(nom: 'alerte_humidite', message: message); // Sauvegarde de l'alerte
      // Notification envoyée si elles sont activées
      if (notificationsNotifier.value) {
        await NotificationService.sendAlert(
          type: 'alerte_humidite',
          valeur: _humidity,
          seuil: _config.humidityMax,
          locale: locale,
        );
      }
    }
    // ------ ALERTE CO2 ------
    if (_co2 > _config.co2Max) {
      final message = '${l10n.alerteco2} - $_co2 ppm > ${_config.co2Max} ppm'; // Message de l'alerte sauvegardée
      await UserService.saveAlerte(nom: 'alerte_co2', message: message); // Sauvegarde de l'alerte
      // Notification envoyée si elles sont activées
      if (notificationsNotifier.value) {
        await NotificationService.sendAlert(
          type: 'alerte_co2',
          valeur: _co2.toDouble(),
          seuil: _config.co2Max,
          locale: locale,
        );
      }
    }
  }

  // ------ ALERTES ACTIVES ------
  List<String> _activeAlerts(BuildContext context) {
    // Liste contenant les chaînes de caractères des alertes actives à l'instant t
    final l10n = AppLocalizations.of(context)!; // pour changer la langue des textes
    final alerts = <String>[];

    // On revérifie la température avec le seuil configuré
    if (_temperature > _config.temperatureMax) {
      // On ajoute à la liste le texte indiquant la température mesurée à celle du seuil configuré
      alerts.add('${l10n.alerteTemp} ($_temperature°C > ${_config.temperatureMax.toStringAsFixed(0)}°C)');
    }
    // On revérifie le taux d'humidité avec le seuil configuré
    if (_humidity > _config.humidityMax) {
      // On ajoute à la liste le texte indiquant le taux d'humidité mesuré à celui du seuil configuré
      alerts.add('${l10n.alerteHumid} (${_humidity.toInt()}% > ${_config.humidityMax.toStringAsFixed(0)}%)');
    }
    // On revérifie la concentration de CO2 avec le seuil configuré
    if (_co2 > _config.co2Max) {
      // On ajoute à la liste le texte indiquant la concentration de CO2 mesurée à celle du seuil configuré
      alerts.add('${l10n.alerteco2} ($_co2 ppm > ${_config.co2Max.toStringAsFixed(0)} ppm)');
    }
    // On teste la connexion de la carte
    if (_connectionStatus == ConnectionStatus.offline) {
      // Si elle n'est pas en quasi directe, on envoie une notification contenant l'alerte du capteur
      alerts.add(l10n.capteurOff);
    }
    // On renvoie la liste contenant la ou les chaîne(s) de caractère contenant toutes les alertes actives à la fin
    return alerts;
  }

  // ---------------------------------- AFFICHAGE MODULE 2 ----------------------------------
  @override
  Widget build(BuildContext context) {
    // Widget permettant de gérer l'affichage la page du module 2
    return Scaffold(
      // Aspect général de la page
      backgroundColor: AgrosafeTheme.bg(),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100), // Configuration des marges de la page
              children: [
                // Affichage de l'en-tête de la page
                _buildTopBar(),
                const SizedBox(height: 16),
                // Affichage du titre de la page et lot surveillé + identifiant du capteur utilisé (entrés par l'utilisateur)
                _buildTitle(),
                const SizedBox(height: 14),
                // Affichage des alertes si l'un des seuils est dépassé ou qu'il y ait un problème de connexion à la carte
                if (_activeAlerts(context).isNotEmpty) ...[
                  // Affichage de la bannière d'alerte
                  AlertBanner(
                    temperature: _temperature,
                    humidity: _humidity,
                    co2: _co2,
                    config: _config,
                    connectionStatus: _connectionStatus,
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    // Affichage de la carte température à l'instant t
                    Expanded(child: _buildTempCard()),
                    const SizedBox(width: 12), // Espace entre les 2 cartes
                    // Affichage de la carte du taux d'humidité mesurée à l'instant t
                    Expanded(child: _buildHumidityCard()),
                  ],
                ),
                const SizedBox(height: 12), // Espace avant d'ajouter la carte suivante
                Row(
                  children: [
                  // Affichage de la carte de la mesure de la concentration de CO2 mesurée à l'instant t
                  Expanded(child: _buildCO2Card()),
                  const SizedBox(width: 12), // Espace avant d'ajouter la carte suivante
                  // Affichage de l'analyse du taux de BAI
                  Expanded(child: _buildBaiCard()),
                  ],
                ),
                const SizedBox(height: 12), // Espace avant d'ajouter la carte suivante
                // Affichage des limites max configurées par l'utilisateur et enregistrées dans Firebase
                _buildThresholdCard(),
                const SizedBox(height: 16), // Espace avant d'ajouter les cartes d'accès aux pages d'historique et de rapport du lot
                Row( // pour les mettre côté à côté
                  children: [
                    // Affichage de la carte pour accéder à la page historique
                    Expanded(child: _buildActionCardHist(),
                    ),
                    const SizedBox(width: 12), // Espace entre les 2 cartes
                    // Affichage de la carte pour accéder à la page du rapport du lot
                    Expanded(child: _buildActionCardRapport(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ------ EN-TÊTE ------
  Widget _buildTopBar() {
    // Widget gérant l'affichage de l'en-tête de la page
    return Row(
      // Alignement sur des espaces opposés (aligné à gauche et aligné à droite)
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const ModuleTag(type: ModuleTagType.module2), // Affichage du badge du module 2
        LiveIndicator(status: _connectionStatus), // Affiche de l'indicateur de connexion à la carte
      ],
    );
  }

  // ------ TITRE PAGE ------
  Widget _buildTitle() {
    // Widget gérant l'affichage du titre de la page et lot surveillé + identifiant du capteur utilisé (entrés par l'utilisateur)
    final l10n = AppLocalizations.of(context)!; // pour changer la langue des textes
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // possibilité de mettre les éléments aux opposés de la page sur une même ligne
      crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
          children: [
            // Texte du titre de la page
            Text(
              l10n.stockageAvocat,
              style: AgrosafeTheme.displayTitle.copyWith(color: AgrosafeTheme.textPrimary()), // Style du titre
            ),
            // Espace entre le titre et le lot surveillé
            const SizedBox(height: 2),
            // Texte du lot surveillé et de l'identifiant du capteur en fonction des données enregistrées dans la page de configuration
            Text(
              '${_config.lotName} — ${_config.capteurId}',
              style: AgrosafeTheme.bodyText.copyWith(color: AgrosafeTheme.textMuted()), // Style du texte
            ),
          ],
        ),
        // Action du bouton pour accéder à la page de configuration
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConfigurationScreen(
                  initialConfig: _config, // configuration par défaut de la page de configuration
                  // Valeurs sauvegardées dans la page de configuration
                  onSave: (capteur, lot, culture, tempMax, humidityMax, co2Max, frequency,lastModified) async {
                    final newConfig = LotConfig(
                      capteurId: capteur,
                      lotName: lot,
                      culture: culture,
                      temperatureMax: tempMax,
                      humidityMax: humidityMax,
                      co2Max: co2Max,
                      frequency: frequency,
                      lastModified: lastModified,
                    );
                    await ConfigService.saveConfig(newConfig); // sauvegarde de la configuration entrée par l'utilisateur
                    setState(() => _config = newConfig); // intègre les nouvelles données à la page générale du module 2
                  },
                  onNavigate: widget.onNavigate, // Permet d'accéder à la page de configuration
                ),
              ),
            );
          },
          // Aspect visuel du bouton permettant d'accéder à la page de configuration
          child: Container(
            width: 40, height: 40, // Taille du bouton
            // Style du bouton
            decoration: BoxDecoration(
              color: AgrosafeTheme.cardBg(),
              shape: BoxShape.circle, // permet de l'entourer d'un cercle
              border: Border.all(color: AgrosafeTheme.cardBg()),
            ),
            child: Icon(Icons.settings_outlined, size: 20, color: AgrosafeTheme.textMuted()), // Ajout de l'icône à l'intérieur du cercle avec son propre style
          ),
        ),
      ],
    );
  }

  // ------ CARTE TEMPÉRATURE ------
  Widget _buildTempCard() {
    // Widget permettant d'afficher la carte de la mesure de la température à l'instant t
    final l10n = AppLocalizations.of(context)!; // pour changer la langue du texte
    return SensorCard(
      icon: '🌡️',
      label: l10n.temperature,
      type:'temperature',
      numericValue: _temperature,
      seuilFao: _config.temperatureMax,
      value: '$_temperature°C',
      invalid: !RealtimeService.isValid(_temperature),
    );
  }

  // ------ CARTE TAUX D'HUMIDITÉ ------
  Widget _buildHumidityCard() {
    // Widget permettant d'afficher la carte de la mesure du taux d'humidité à l'instant t
    final l10n = AppLocalizations.of(context)!; // pour changer la langue du texte
    return SensorCard(
      icon: '💧',
      label: l10n.humidite,
      type:'humidity',
      numericValue: _humidity,
      seuilFao: _config.humidityMax,
      value: '${_humidity.toInt()}%',
      invalid: !RealtimeService.isValid(_humidity),
    );
  }

  // ------ CARTE CO₂ ------
  Widget _buildCO2Card() {
    // Widget permettant d'afficher la carte de la mesure de la concentration de CO2 mesurée à l'instant t
    final l10n = AppLocalizations.of(context)!; // permet de changer de langue le texte
    return SensorCard(
      icon: '⚛️',
      label:l10n.co2,
      type:'CO2',
      numericValue: _co2.toDouble(),
      seuilFao: _config.co2Max,
      value: '${_co2.toInt()} ppm',
      invalid: !RealtimeService.isValid(_co2.toDouble()),
      );
  }

  // ------ CARTE BAI ------
  Widget _buildBaiCard() {
    // Widget permettant d'afficher la carte de la mesure de la concentration de CO2 mesurée à l'instant t
    //final l10n = AppLocalizations.of(context)!; // permet de changer de langue le texte
    return BaiCard(
      type:'bai',
      numericValue: _bai,
      value: '$_bai ppm',
      invalid: !RealtimeService.isValid(_bai),
      );
  }

  // ------ CALCUL TEMPS DERNIÈRE MESURE ------
  String _formatLastMesure() {
    // Fonction permettant de calculer le temps qui s'est écoulé depuis la dernière mesure reçue
    final l10n = AppLocalizations.of(context)!; // permet de changer la langue des textes
    if(_lastMesure == null) return l10n.pasDeDonnees; // s'il n'y a pas de données, on l'écrit
    final diff = DateTime.now().difference(_lastMesure!); // Calcule le temps écoulé depuis la dernière mesure et maintenant
    String quand;
    if (diff.inMinutes < 1) {
      quand = l10n.now; // Si moins d'une minute c'est écoulée on renvoie "now" ou "à l'instant"
    }
    else if (diff.inMinutes < 60) {
      quand = '${l10n.combien}${diff.inMinutes} min ${l10n.combien2}'; // Si c'est entre 1 min et 1h, le nombre de minutes
    }
    else if (diff.inHours < 24) {
      quand = '${l10n.combien}${diff.inHours}h ${l10n.combien2}'; // Si c'est entre 1h et 23h, on renvoie le nombre d'heures (cas problème de connexion)
    }
    else {
      quand = '${l10n.combien}${diff.inDays}j ${l10n.combien2}'; // Sinon on renvoie le nombre de jours (cas si problème de connexion)
    }
    // On formate l'affichage avant de le retourner
    return '$quand (${l10n.display} $_frequenceMinutes min)';
  }
  
  // ------ CARTE SEUILS FAO ------
  Widget _buildThresholdCard() {
    // Widget permettant d'afficher les seuils FAO enregistrés dans la page de configuration
    final l10n = AppLocalizations.of(context)!; // permet de changer de langue les textes
    return Container(
      padding: const EdgeInsets.all(16), // marge de l'intérieur de la carte
      // Style de la carte
      decoration: BoxDecoration(
        color: AgrosafeTheme.cardBg(),
        borderRadius: BorderRadius.circular(16), // coins arrondis
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alignement
        children: [
          // Texte du titre de la carte
          Text(l10n.seuilsFAO,
            // Style du texte
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AgrosafeTheme.greyCard,
              letterSpacing: 0.8
            )
          ),
          const SizedBox(height: 10), // Ajout d'un espace avant les données
          Row( // Permet de les noter les unes à côté des autres
            children: [
              // Affichage du seuil FAO configuré de la température
              ThresholdItem(
                color: _temperature > _config.temperatureMax ? AgrosafeTheme.danger : AgrosafeTheme.safe, // Couleur de la pastille dynamique en fonction des données recueillies par les capteurs
                text: 'T° < ${_config.temperatureMax.toStringAsFixed(0)}°C',  // Affichage dynamique en fonction des données de LotConfig enregistrées
              ),
              const SizedBox(width: 16), // Ajout d'un espace avant d'ajouter le seuil du taux d'humidité configuré
              // Affichage du seuil FAO du taux d'humidité configuré
              ThresholdItem(
                color: _humidity > _config.humidityMax ? AgrosafeTheme.danger : AgrosafeTheme.safe, // Couleur de la pastille dynamique en fonction des données recueillies par les capteurs
                text: 'HR < ${_config.humidityMax.toStringAsFixed(0)}%',  // Affichage dynamique en fonction des données de LotConfig enregistrées
              ),
              const SizedBox(width: 16), // Ajout d'un espace avant d'ajouter le seuil de la concentration de CO2 configuré
              // Affichage du seuil FAO de la concentration de CO2 configuré
              ThresholdItem(
                color: _co2 > _config.co2Max ? AgrosafeTheme.danger : AgrosafeTheme.safe, // Couleur de la pastille dynamique en fonction des données recueillies par les capteurs
                text: 'CO₂ < ${_config.co2Max.toStringAsFixed(0)}ppm',  // Affichage dynamique en fonction des données de LotConfig enregistrées
              ),
            ],
          ),
          const SizedBox(height: 12), // Ajout d'un espace
          Divider(height: 1, color: AgrosafeTheme.separationColor()), // Ajout d'une ligne séparatrice
          const SizedBox(height: 13), // Ajout d'un espace
          Center( // On centre le titre au milieu de la dernière ligne de la carte
            child: Text( // Affichage du texte de la dernière mesure
              '${l10n.lastMesure} ${_formatLastMesure()}', // Affichage dynamique
              // Style du texte
              style: const TextStyle(
                fontSize: 12,
                color: AgrosafeTheme.greyCard,
                fontStyle: FontStyle.italic
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------ CARTE ACTION HISTORIQUE ------
  Widget _buildActionCardHist() {
    // Widget permettant d'accéder à la page historique
    final l10n = AppLocalizations.of(context)!; // pour changer la langue du texte
    return ActionCard(
      icon: Icons.stacked_bar_chart, // Icône de graphe
      iconColor: AgrosafeTheme.danger, // Couleur de l'icône
      label: l10n.historique, // Sous-titre de l'icône (nom de la page)
      // Action permettant d'accéder à la page historique quand on clique sur l'icône
      onCtaTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoriqueScreen(onNavigate: widget.onNavigate),
          ),
        );
      },
    );
  }

  // ------ CARTE ACTION RAPPORT LOT ------
  Widget _buildActionCardRapport() {
    // Widget permettant d'accéder à la page du rapport du lot
    final l10n = AppLocalizations.of(context)!; // pour changer la langue du texte
    return ActionCard(
      icon: Icons.assignment_outlined, // Icône de rapport
      iconColor: AgrosafeTheme.iot, // Couleur de l'icône
      label: l10n.rapportLot, // Sous-titre de l'icône (nom de la page)
      // Action permettant d'accéder à la page du rapport
      onCtaTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RapportLotScreen(onNavigate: widget.onNavigate),
          ),
        );
      },
    );
  }
}