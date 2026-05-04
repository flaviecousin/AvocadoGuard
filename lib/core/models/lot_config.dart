class LotConfig {
  // Classe permettant de gérer l'écran de configuration (modèle des données de l'écran de configuration)
  final String capteurId; // Nom du capteur entré par l'utilisateur
  final String lotName; // Nom du lot (entré par l'utilisateur)
  final String culture; // Nom de la culture (entrée par l'utilisateur)
  final double temperatureMax; // Valeur de la température max (décidée par l'utilisateur)
  final double humidityMax; // Valeur de l'humidité max (décidée par l'utilisateur)
  final double co2Max; // Valeur de la concentration de CO2 max (décidée par l'utilisateur)
  final String frequency; // Choix de la fréquence (choisir par l'utilisateur)
  final DateTime? lastModified; // Date de la modification du champ lotName ou culture

  LotConfig({
    // Constructeur de LotConfig avec les valeurs FAO par défaut pour l'avocat
    required this.capteurId, // Identifiant unique du capteur
    required this.lotName, // Identifiant du lot de stockage
    required this.culture, // Identifiant de la culture surveillée
    this.temperatureMax = 7.0, // Valeur par défaut de la température max
    this.humidityMax = 90.0, // Valeur par défaut de l'humidité
    this.co2Max = 1000.0, // Valeur par défaut de la concentration de CO2
    this.frequency = '5 min', // Valeur par défaut de la fréquence de mesure du capteur
    this.lastModified, // optionnel et null par défaut
  });
}