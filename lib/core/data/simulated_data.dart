import 'package:avocadoguard/core/models/module_status.dart'; // Permet d'accéder à la classe gérant la représentation de l'état d'un module
import 'package:avocadoguard/core/models/connection_status.dart'; // pour pouvoir accéder au statut de connexion du module 2
import 'package:avocadoguard/core/models/scan_risk.dart'; // pour pouvoir accéder au statut des derniers résultats des scans du module 1

class SimulatedData {
  // Classe permettant de gérer les données simulées
  static const ModuleStatus module1Status = ModuleStatus(
    // Données simulées du module 1
    lastScanRisk: ScanRisk.safe, // Dernier scan
    connectionStatus: ConnectionStatus.live, // Statut de la connexion
  );
  static final ModuleStatus module2Status = ModuleStatus.fromLastReceived(
    // Données simulées du module 2 (home page)
    lastScanRisk: ScanRisk.safe, // Bilan du dernier scan
    lastDataReceived: DateTime.now().subtract(const Duration(minutes: 2)), // Statut de la connexion
  );

  // Données simulées pour le module 2 (écran de l'historique des mesures + fusion), utilisées en attente des données de Firebase Realtime Database
  static final List<Map<String, dynamic>> module2History = [
    {'date': '2025-12-15', 'temperature': 6.4, 'humidity': 88, 'co2': 820},
    {'date': '2025-12-16', 'temperature': 6.2, 'humidity': 87, 'co2': 810},
    {'date': '2025-12-17', 'temperature': 6.5, 'humidity': 91, 'co2': 835},
    {'date': '2026-04-18', 'temperature': 6.1, 'humidity': 86, 'co2': 795},
    {'date': '2026-04-19', 'temperature': 6.3, 'humidity': 89, 'co2': 815},
    {'date': '2026-04-20', 'temperature': 6.6, 'humidity': 90, 'co2': 840},
    {'date': '2026-04-21', 'temperature': 6.4, 'humidity': 88, 'co2': 820},
  ];

  // Données simulées pour le module 1 (écran de fusion)
  static final List<Map<String, dynamic>> module1History = [
    {'date': '2025-02-15', 'risk': ScanRisk.safe,    'plant': 'Plant #1'},
    {'date': '2025-02-16', 'risk': ScanRisk.safe,    'plant': 'Plant #2'},
    {'date': '2025-02-17', 'risk': ScanRisk.warning, 'plant': 'Plant #3'},
    {'date': '2025-02-18', 'risk': ScanRisk.safe,    'plant': 'Plant #4'},
    {'date': '2025-02-19', 'risk': ScanRisk.warning, 'plant': 'Plant #5'},
    {'date': '2025-02-20', 'risk': ScanRisk.danger,  'plant': 'Plant #6'},
    {'date': '2025-02-21', 'risk': ScanRisk.safe,    'plant': 'Plant #7'},
  ];
}