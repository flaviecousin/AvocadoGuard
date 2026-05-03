// Liste des valeurs possibles des résultats des scans du module 1

enum ScanRisk {
  // Valeur possible des bilans des scans de plante (module 1)
  safe, // Pour la plante saine
  warning, // Pour la plante douteuse (risque modéré)
  danger, // Pour la plante infectée (risque élevé)
}