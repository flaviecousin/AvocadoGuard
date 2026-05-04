import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @bonjour.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour 👋'**
  String get bonjour;

  /// No description provided for @vueEnsemble.
  ///
  /// In fr, this message translates to:
  /// **'Vue d\'ensemble de vos activités'**
  String get vueEnsemble;

  /// No description provided for @voirDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Voir le dashboard'**
  String get voirDashboard;

  /// No description provided for @home.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get home;

  /// No description provided for @module2.
  ///
  /// In fr, this message translates to:
  /// **'Module 2'**
  String get module2;

  /// No description provided for @profil.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profil;

  /// No description provided for @sauvegarder.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder'**
  String get sauvegarder;

  /// No description provided for @valider.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get valider;

  /// No description provided for @annuler.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get annuler;

  /// No description provided for @envoyer.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get envoyer;

  /// No description provided for @scanner.
  ///
  /// In fr, this message translates to:
  /// **'Scanner'**
  String get scanner;

  /// No description provided for @deconnexion.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get deconnexion;

  /// No description provided for @modifier.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get modifier;

  /// No description provided for @reinitialiserMdp.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser le mot de passe'**
  String get reinitialiserMdp;

  /// No description provided for @connexion.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get connexion;

  /// No description provided for @motDePasse.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe :'**
  String get motDePasse;

  /// No description provided for @motDePasse2.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get motDePasse2;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Email :'**
  String get email;

  /// No description provided for @email2.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email2;

  /// No description provided for @creerCompte.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte AgroSafe'**
  String get creerCompte;

  /// No description provided for @motDePasseOublie.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get motDePasseOublie;

  /// No description provided for @emailReinitialisation.
  ///
  /// In fr, this message translates to:
  /// **'Email de réinitialisation envoyé !'**
  String get emailReinitialisation;

  /// No description provided for @mdpEntre.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre mot de passe'**
  String get mdpEntre;

  /// No description provided for @emailEntre.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre addresse mail'**
  String get emailEntre;

  /// No description provided for @confirmation.
  ///
  /// In fr, this message translates to:
  /// **'Confirmation :'**
  String get confirmation;

  /// No description provided for @confirmationMdp.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez confirmer votre mot de passe'**
  String get confirmationMdp;

  /// No description provided for @profilPref.
  ///
  /// In fr, this message translates to:
  /// **'Profil préféré :'**
  String get profilPref;

  /// No description provided for @profilChoix.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez choisir votre profil préféré'**
  String get profilChoix;

  /// No description provided for @agriculteur.
  ///
  /// In fr, this message translates to:
  /// **'🌿 Agriculteur'**
  String get agriculteur;

  /// No description provided for @gestionnaire.
  ///
  /// In fr, this message translates to:
  /// **'📦 Gestionnaire de stockage'**
  String get gestionnaire;

  /// No description provided for @needEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email requis'**
  String get needEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Format email invalide'**
  String get invalidEmail;

  /// No description provided for @needMdp.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe requis'**
  String get needMdp;

  /// No description provided for @mdpTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Minimum 6 caractères'**
  String get mdpTooShort;

  /// No description provided for @needConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmation requise'**
  String get needConfirm;

  /// No description provided for @mdpMismatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe doivent être identiques'**
  String get mdpMismatch;

  /// No description provided for @stockageAvocat.
  ///
  /// In fr, this message translates to:
  /// **'Stockage Avocat'**
  String get stockageAvocat;

  /// No description provided for @alerteRisque.
  ///
  /// In fr, this message translates to:
  /// **'Alerte Risque !'**
  String get alerteRisque;

  /// No description provided for @accuse.
  ///
  /// In fr, this message translates to:
  /// **'Accusé de réception'**
  String get accuse;

  /// No description provided for @alertesActives.
  ///
  /// In fr, this message translates to:
  /// **'Alertes Actives'**
  String get alertesActives;

  /// No description provided for @seuilsFAO.
  ///
  /// In fr, this message translates to:
  /// **'SEUILS FAO AVOCAT'**
  String get seuilsFAO;

  /// No description provided for @lastMesure.
  ///
  /// In fr, this message translates to:
  /// **'Dernière mesure : '**
  String get lastMesure;

  /// No description provided for @combien.
  ///
  /// In fr, this message translates to:
  /// **'il y a '**
  String get combien;

  /// No description provided for @combien2.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get combien2;

  /// No description provided for @now.
  ///
  /// In fr, this message translates to:
  /// **'à l\'instant'**
  String get now;

  /// No description provided for @ventilationChambreFroide.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez la ventilation de la chambre froide.'**
  String get ventilationChambreFroide;

  /// No description provided for @display.
  ///
  /// In fr, this message translates to:
  /// **'affichage toutes les'**
  String get display;

  /// No description provided for @stable.
  ///
  /// In fr, this message translates to:
  /// **'Stable'**
  String get stable;

  /// No description provided for @maturation.
  ///
  /// In fr, this message translates to:
  /// **'Maturation'**
  String get maturation;

  /// No description provided for @alerteFermentation.
  ///
  /// In fr, this message translates to:
  /// **'Alerte fermentation'**
  String get alerteFermentation;

  /// No description provided for @configuration.
  ///
  /// In fr, this message translates to:
  /// **'Configuration'**
  String get configuration;

  /// No description provided for @temperature.
  ///
  /// In fr, this message translates to:
  /// **'TEMPÉRATURE'**
  String get temperature;

  /// No description provided for @humidite.
  ///
  /// In fr, this message translates to:
  /// **'HUMIDITÉ'**
  String get humidite;

  /// No description provided for @frequenceMesure.
  ///
  /// In fr, this message translates to:
  /// **'FRÉQUENCE DE MESURE'**
  String get frequenceMesure;

  /// No description provided for @seuilsAlerte.
  ///
  /// In fr, this message translates to:
  /// **'Seuils d\'alerte'**
  String get seuilsAlerte;

  /// No description provided for @capteurID.
  ///
  /// In fr, this message translates to:
  /// **'IDENTIFIANT CAPTEUR'**
  String get capteurID;

  /// No description provided for @lotID.
  ///
  /// In fr, this message translates to:
  /// **'NOM DU LOT'**
  String get lotID;

  /// No description provided for @cultureID.
  ///
  /// In fr, this message translates to:
  /// **'CULTURE SURVEILLÉE'**
  String get cultureID;

  /// No description provided for @faoVal.
  ///
  /// In fr, this message translates to:
  /// **'Valeurs FAO recommandées'**
  String get faoVal;

  /// No description provided for @temperatureMax.
  ///
  /// In fr, this message translates to:
  /// **'Température max'**
  String get temperatureMax;

  /// No description provided for @humidityMax.
  ///
  /// In fr, this message translates to:
  /// **'Humidité max'**
  String get humidityMax;

  /// No description provided for @co2Max.
  ///
  /// In fr, this message translates to:
  /// **'CO₂ max'**
  String get co2Max;

  /// No description provided for @seuilsParDefaut.
  ///
  /// In fr, this message translates to:
  /// **'Seuils par défaut'**
  String get seuilsParDefaut;

  /// No description provided for @historique.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get historique;

  /// No description provided for @uneHeure.
  ///
  /// In fr, this message translates to:
  /// **'1h'**
  String get uneHeure;

  /// No description provided for @septJours.
  ///
  /// In fr, this message translates to:
  /// **'7 jours'**
  String get septJours;

  /// No description provided for @trenteJours.
  ///
  /// In fr, this message translates to:
  /// **'30 jours'**
  String get trenteJours;

  /// No description provided for @jour.
  ///
  /// In fr, this message translates to:
  /// **'jour'**
  String get jour;

  /// No description provided for @temp.
  ///
  /// In fr, this message translates to:
  /// **'Température'**
  String get temp;

  /// No description provided for @hr.
  ///
  /// In fr, this message translates to:
  /// **'Humidité'**
  String get hr;

  /// No description provided for @co2.
  ///
  /// In fr, this message translates to:
  /// **'CO₂'**
  String get co2;

  /// No description provided for @seuil.
  ///
  /// In fr, this message translates to:
  /// **'Seuils'**
  String get seuil;

  /// No description provided for @journalAlerte.
  ///
  /// In fr, this message translates to:
  /// **'JOURNAL DES ALERTES'**
  String get journalAlerte;

  /// No description provided for @min41.
  ///
  /// In fr, this message translates to:
  /// **'il y a 41 min'**
  String get min41;

  /// No description provided for @h3.
  ///
  /// In fr, this message translates to:
  /// **'il y a 3 heures'**
  String get h3;

  /// No description provided for @j1.
  ///
  /// In fr, this message translates to:
  /// **'il y a 1 jour'**
  String get j1;

  /// No description provided for @hrMsg.
  ///
  /// In fr, this message translates to:
  /// **'Humidité relative élevée — HR 91%'**
  String get hrMsg;

  /// No description provided for @tempMsg.
  ///
  /// In fr, this message translates to:
  /// **'Température proche du seuil — T° 6.9°C'**
  String get tempMsg;

  /// No description provided for @hrMsg2.
  ///
  /// In fr, this message translates to:
  /// **'Humidité relative élevée — HR 90.5%'**
  String get hrMsg2;

  /// No description provided for @pasDeDonnees.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée sur cette période'**
  String get pasDeDonnees;

  /// No description provided for @rapportLot.
  ///
  /// In fr, this message translates to:
  /// **'Rapport Lot'**
  String get rapportLot;

  /// No description provided for @rapportTitre.
  ///
  /// In fr, this message translates to:
  /// **'Rapport Lot 03'**
  String get rapportTitre;

  /// No description provided for @scoreRisqueGlobal.
  ///
  /// In fr, this message translates to:
  /// **'SCORE DE RISQUE GLOBAL'**
  String get scoreRisqueGlobal;

  /// No description provided for @faible.
  ///
  /// In fr, this message translates to:
  /// **'Faible'**
  String get faible;

  /// No description provided for @modere.
  ///
  /// In fr, this message translates to:
  /// **'Modéré'**
  String get modere;

  /// No description provided for @eleve.
  ///
  /// In fr, this message translates to:
  /// **'Elevé'**
  String get eleve;

  /// No description provided for @duree.
  ///
  /// In fr, this message translates to:
  /// **'DURÉE STOCKAGE'**
  String get duree;

  /// No description provided for @jours.
  ///
  /// In fr, this message translates to:
  /// **'jours'**
  String get jours;

  /// No description provided for @alertes.
  ///
  /// In fr, this message translates to:
  /// **'ALERTES\nDÉCLENCHÉES'**
  String get alertes;

  /// No description provided for @moyTemp.
  ///
  /// In fr, this message translates to:
  /// **'T° MOYENNE'**
  String get moyTemp;

  /// No description provided for @maxHR.
  ///
  /// In fr, this message translates to:
  /// **'HR MAX ATTEINTE'**
  String get maxHR;

  /// No description provided for @co2Moy.
  ///
  /// In fr, this message translates to:
  /// **'CO₂ MOYEN'**
  String get co2Moy;

  /// No description provided for @totMesure.
  ///
  /// In fr, this message translates to:
  /// **'MESURES TOTALES'**
  String get totMesure;

  /// No description provided for @visuel.
  ///
  /// In fr, this message translates to:
  /// **'SUIVI VISUEL'**
  String get visuel;

  /// No description provided for @exportCSV.
  ///
  /// In fr, this message translates to:
  /// **'Exporter CSV'**
  String get exportCSV;

  /// No description provided for @langue.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get langue;

  /// No description provided for @notifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @darkMode.
  ///
  /// In fr, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @quickAccess.
  ///
  /// In fr, this message translates to:
  /// **'QUICK ACCESS'**
  String get quickAccess;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'SETTINGS'**
  String get settings;

  /// No description provided for @module2TitleProfil.
  ///
  /// In fr, this message translates to:
  /// **'📦 Module 2 - IoT'**
  String get module2TitleProfil;

  /// No description provided for @voirProfil.
  ///
  /// In fr, this message translates to:
  /// **'Voir mon profil →'**
  String get voirProfil;

  /// No description provided for @french.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @anglais.
  ///
  /// In fr, this message translates to:
  /// **'Anglais'**
  String get anglais;

  /// No description provided for @userScreenTitle.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get userScreenTitle;

  /// No description provided for @nonDefini.
  ///
  /// In fr, this message translates to:
  /// **'Non défini'**
  String get nonDefini;

  /// No description provided for @agri.
  ///
  /// In fr, this message translates to:
  /// **'Agriculteur'**
  String get agri;

  /// No description provided for @gestionn.
  ///
  /// In fr, this message translates to:
  /// **'Gestionnaire de stockage'**
  String get gestionn;

  /// No description provided for @pbProfil.
  ///
  /// In fr, this message translates to:
  /// **'Profil non défini'**
  String get pbProfil;

  /// No description provided for @emailVerification.
  ///
  /// In fr, this message translates to:
  /// **'Email de vérification envoyé'**
  String get emailVerification;

  /// No description provided for @profilSauvegarde.
  ///
  /// In fr, this message translates to:
  /// **'Profil sauvegardé!'**
  String get profilSauvegarde;

  /// No description provided for @sain.
  ///
  /// In fr, this message translates to:
  /// **'Sain'**
  String get sain;

  /// No description provided for @douteux.
  ///
  /// In fr, this message translates to:
  /// **'Douteux'**
  String get douteux;

  /// No description provided for @danger.
  ///
  /// In fr, this message translates to:
  /// **'Danger'**
  String get danger;

  /// No description provided for @live.
  ///
  /// In fr, this message translates to:
  /// **'En direct'**
  String get live;

  /// No description provided for @delayed.
  ///
  /// In fr, this message translates to:
  /// **'Retard signal'**
  String get delayed;

  /// No description provided for @offline.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne'**
  String get offline;

  /// No description provided for @alerteTemp.
  ///
  /// In fr, this message translates to:
  /// **'Température élevée'**
  String get alerteTemp;

  /// No description provided for @alerteHumid.
  ///
  /// In fr, this message translates to:
  /// **'Humidité élevée'**
  String get alerteHumid;

  /// No description provided for @alerteco2.
  ///
  /// In fr, this message translates to:
  /// **'CO₂ élevé'**
  String get alerteco2;

  /// No description provided for @capteurOff.
  ///
  /// In fr, this message translates to:
  /// **'Capteur hors ligne'**
  String get capteurOff;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
