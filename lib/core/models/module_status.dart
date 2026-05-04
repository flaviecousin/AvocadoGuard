// Importations des fichiers nécessaires
import 'package:avocadoguard/core/models/scan_risk.dart'; // pour pouvoir accéder à la liste des valeurs des résultats du module 1
import 'package:avocadoguard/core/models/connection_status.dart'; // pour pouvoir accéder à la liste des valeurs de la connexion à la carte du module 2

class ModuleStatus {
  // Classe représentant l'état complet d'un module (scan IA + connexion IoT)
  final ScanRisk lastScanRisk; // Résultat du dernier scan
  final DateTime? lastScanTime; // Date/Heure du dernier scan (optionnel)
  final ConnectionStatus connectionStatus; // Etat de la connexion du capteur
  final DateTime? lastDataReceived; // Date/Heure de la dernière donnée reçue

  const ModuleStatus({
    // Constructeur de la classe
    required this.lastScanRisk,
    this.lastScanTime,
    required this.connectionStatus,
    this.lastDataReceived,
  });

  // Calcule automatiquement le statut de connexion selon le temps
  factory ModuleStatus.fromLastReceived({required ScanRisk lastScanRisk, required DateTime lastDataReceived}){
    // Calcule la différence entre maintenant et la dernière donnée donnée reçue
    final diff = DateTime.now().difference(lastDataReceived);
    ConnectionStatus status;

    // Si le temps < 5 min => live
    if (diff.inMinutes < 5) {
      status = ConnectionStatus.live; // Données récentes
    }
    // Si le temps entre 5 et 15 min => delayed
    else if (diff.inMinutes < 15) {
      status = ConnectionStatus.delayed; // Données en retard
    }
    // Si le temps > 15 min => offline
    else {
      status = ConnectionStatus.offline; // Capteur déconnecté
    }

    return ModuleStatus(
      lastScanRisk: lastScanRisk,
      connectionStatus: status,
      lastDataReceived: lastDataReceived,
    );
  }
}