// Importation des bibliothèques
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Pour les polices d'écritures
import 'package:avocadoguard/core/app_notifiers.dart'; // Pour les préférences de thème

class AgrosafeTheme{
  // ---- COULEURS ----
  // Palette de couleurs principales
  static const Color soil = Color(0xFF1C1A14); // fond de la page de chargement
  static const Color bark = Color(0xFF2E2B22); // fond de la barre de chargement
  static const Color moss = Color(0xFF3D5A3E); // pour les badges
  static const Color leaf = Color(0xFF5C8B3F);
  static const Color lime = Color(0xFFA8CC6C); // onglet actif de la barre de navigation, badge du module 1 et animation de la barre de chargement
  static const Color straw = Color(0xFFE8D99A);
  static const Color cream = Color(0xFFF5F0E4); // fond des différentes pages en mode clair
  static const Color white = Color(0xFFFDFCF8); // thème de l'application et texte du bouton d'accusé de réception
  static const Color border = Color(0xFFD4CBAE); // bordures des champs des pages de connexion et de création de compte
  static const Color muted = Color(0xFF8A8472); // label des champs, textes des périodes des rapports et des onglets non actifs dans la barre de navigation
  static const Color greyCard = Color(0xFF6B6B6B); // titres des cartes du module
  static const Color seperation = Color(0xFFEEEEEE);

  // Couleurs des statuts
  static const Color safe = Color(0xFF27AE60);
  static const Color safePastel = Color(0xFFD4EDDA);
  static const Color safeText = Color(0xFF2E7D32);
  static const Color warningPastel= Color(0xFFFDEBD0);
  static const Color warning = Color(0xFFE67E22);
  static const Color danger = Color(0xFFC0392B);
  static const Color dangerPastel = Color(0xFFFDE8E8);
  static const Color iot = Color(0xFF2980B9);

  // Couleurs spécifiques aux dark mode
  static const Color darkGreen = Color (0xFF14452F);
  static const Color darkMuted = Color (0xFF9A9480);
  static const Color darkWhite = Color (0xFF2A2A2A);
  static const Color darkSeperation = Color (0xFF515151);
  static const Color darkBorder= Color (0xFF3A3730);

  // Couleurs dynamiques selon le mode (Dark/Light)
  static Color bg() => darkModeNotifier.value ? darkGreen : cream;
  static Color cardBg() => darkModeNotifier.value ? darkWhite : white;
  static Color textPrimary() => darkModeNotifier.value ? cream : soil;
  static Color textMuted() => darkModeNotifier.value ? darkMuted : muted;
  static Color borderColor() => darkModeNotifier.value ? darkBorder : border;
  static Color separationColor() => darkModeNotifier.value ? darkSeperation : seperation;
  static Color iconeColor() => darkModeNotifier.value ? safePastel : leaf;
  static Color bottomnav() => darkModeNotifier.value ? darkWhite : bark;
  static Color mossPolice() => darkModeNotifier.value ? safePastel : moss;
  //static Color greyText() => darkModeNotifier.value ? cream : greyCard;
  static Color logoutColor() => darkModeNotifier.value ? white : moss;
  static Color logoutText() => darkModeNotifier.value ? danger : const Color(0xFFFF9999);

  // ---- TEXTES ----
  // Titre de Agrosafe dans Splash
  static TextStyle splashTitle = GoogleFonts.dmSerifDisplay(
    fontSize: 40,
    fontStyle: FontStyle.italic,
    color: AgrosafeTheme.lime,
  );
  // 2e partie du titre de Agrosafe dans Splash
  static TextStyle splashSubtitle = GoogleFonts.dmSerifDisplay(
    fontSize: 40,
    color: AgrosafeTheme.straw,
  );
  // Slogan de Agrosafe dans Splash
  static TextStyle splashSlogan = GoogleFonts.instrumentSans(
  fontSize: 13,
  color: AgrosafeTheme.muted,
  letterSpacing: 1.3, //0.1*taille_police
);
  // Titres
  static TextStyle displayTitle = GoogleFonts.dmSerifDisplay(
    fontSize:32,
    fontWeight:FontWeight.w400,
  );
  // Corps de texte
  static TextStyle bodyText = GoogleFonts.instrumentSans(
    fontSize:15,
    fontWeight:FontWeight.w400,
    height:1.6 // pour améliorer la lisibilité du texte
  );
  // Légendes
  static TextStyle labelsText = GoogleFonts.instrumentSans(
    fontSize:11,
    fontWeight:FontWeight.w700,
    letterSpacing:0.88, // 0.08*taille_police
  );
  // Données
  static TextStyle dataText = GoogleFonts.dmMono(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  // Accès rapide
  static TextStyle quickAccess = GoogleFonts.instrumentSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AgrosafeTheme.textMuted(),
  );

  // ---- ESPACES ----
  static const double cardPadding=16;
  static const double screenHorizontalPadding=20;

  // ---- RAYONS DES COINS ----
  static const double radiusCards=12; // pour les cartes
  static const double radiusButtons=6; // pour les boutons
  static const double radiusInputFields=8; // pour les champs

  // ---- COMPOSANTS SPÉCIFIQUES ----
  // BOUTONS
  // 1. Boutons Primaires
  static ButtonStyle get primaryButtonStyle=>ElevatedButton.styleFrom(
    backgroundColor:iconeColor(),
    foregroundColor:cardBg(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusButtons),
    ),
    minimumSize:const Size(double.infinity,48),
    textStyle:GoogleFonts.instrumentSans(
      fontSize: 14,
      fontWeight:FontWeight.w700,
    ), 
  );
  // 2. Boutons Secondaires
  static ButtonStyle get secondaryButtonStyle=>OutlinedButton.styleFrom(
    foregroundColor:mossPolice(),
    backgroundColor:bg(),
    side:BorderSide(color:mossPolice(),width:1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusButtons),
    ),
    minimumSize:const Size(double.infinity,48),
    textStyle:GoogleFonts.instrumentSans(
      fontSize: 14,
      fontWeight:FontWeight.w700,
    ), 
  );
  
  // 3. Boutons Primaires qui ne change pas avec thème (clair/sombre)
  static ButtonStyle get primaryLightButtonStyle=>ElevatedButton.styleFrom(
    backgroundColor:leaf,
    foregroundColor:white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusButtons),
    ),
    minimumSize:const Size(double.infinity,48),
    textStyle:GoogleFonts.instrumentSans(
      fontSize: 14,
      fontWeight:FontWeight.w700,
    ), 
  );
  // 4. Bouton de déconnexion
  static ButtonStyle get logoutButtonStyle=>OutlinedButton.styleFrom(
    foregroundColor:logoutText(),
    backgroundColor:logoutColor(),
    side:BorderSide(color:mossPolice(),width:1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusButtons),
    ),
    minimumSize:const Size(double.infinity,48),
    textStyle:GoogleFonts.instrumentSans(
      fontSize: 14,
      fontWeight:FontWeight.w700,
    ), 
  );
}