// Liste des valeurs possibles des résultats de connection à la carte du module 2

enum ConnectionStatus {
   // Valeur possible des bilans du statut de connexion d'un capteur IoT
  live, // Capteur connecté, données en temps réel (< 5 min)
  delayed, // Capteur connecté mais données en retard (5-15 min)
  offline, // Capteur hors ligne (> 15 min = sans données)
}