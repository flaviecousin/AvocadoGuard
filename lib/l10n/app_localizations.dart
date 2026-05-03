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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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
  /// In en, this message translates to:
  /// **'Hello 👋'**
  String get bonjour;

  /// No description provided for @vueEnsemble.
  ///
  /// In en, this message translates to:
  /// **'Overview of your activities'**
  String get vueEnsemble;

  /// No description provided for @voirDashboard.
  ///
  /// In en, this message translates to:
  /// **'View dashboard'**
  String get voirDashboard;

  /// No description provided for @dashboardIot.
  ///
  /// In en, this message translates to:
  /// **'Dashboard IoT'**
  String get dashboardIot;

  /// No description provided for @voirScan.
  ///
  /// In en, this message translates to:
  /// **'View the scans →'**
  String get voirScan;

  /// No description provided for @lastScan.
  ///
  /// In en, this message translates to:
  /// **'Last Scan: '**
  String get lastScan;

  /// No description provided for @detectionMaladie.
  ///
  /// In en, this message translates to:
  /// **'Alternaria Detection'**
  String get detectionMaladie;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @module1.
  ///
  /// In en, this message translates to:
  /// **'Module 1'**
  String get module1;

  /// No description provided for @module2.
  ///
  /// In en, this message translates to:
  /// **'Module 2'**
  String get module2;

  /// No description provided for @profil.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profil;

  /// No description provided for @sauvegarder.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get sauvegarder;

  /// No description provided for @valider.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get valider;

  /// No description provided for @annuler.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get annuler;

  /// No description provided for @envoyer.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get envoyer;

  /// No description provided for @scanner.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanner;

  /// No description provided for @deconnexion.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get deconnexion;

  /// No description provided for @modifier.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get modifier;

  /// No description provided for @reinitialiserMdp.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get reinitialiserMdp;

  /// No description provided for @connexion.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get connexion;

  /// No description provided for @motDePasse.
  ///
  /// In en, this message translates to:
  /// **'Password:'**
  String get motDePasse;

  /// No description provided for @motDePasse2.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get motDePasse2;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email:'**
  String get email;

  /// No description provided for @email2.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email2;

  /// No description provided for @creerCompte.
  ///
  /// In en, this message translates to:
  /// **'Create an AgroSafe account'**
  String get creerCompte;

  /// No description provided for @motDePasseOublie.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get motDePasseOublie;

  /// No description provided for @emailReinitialisation.
  ///
  /// In en, this message translates to:
  /// **'Reset email sent!'**
  String get emailReinitialisation;

  /// No description provided for @mdpEntre.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get mdpEntre;

  /// No description provided for @emailEntre.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email adress'**
  String get emailEntre;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirm:'**
  String get confirmation;

  /// No description provided for @confirmationMdp.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmationMdp;

  /// No description provided for @profilPref.
  ///
  /// In en, this message translates to:
  /// **'Favorite profile:'**
  String get profilPref;

  /// No description provided for @profilChoix.
  ///
  /// In en, this message translates to:
  /// **'Please, choose your favorite profile'**
  String get profilChoix;

  /// No description provided for @agriculteur.
  ///
  /// In en, this message translates to:
  /// **'🌿 Farmer'**
  String get agriculteur;

  /// No description provided for @gestionnaire.
  ///
  /// In en, this message translates to:
  /// **'📦 Stock manager'**
  String get gestionnaire;

  /// No description provided for @needEmail.
  ///
  /// In en, this message translates to:
  /// **'Email needed'**
  String get needEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Format of the email invalid'**
  String get invalidEmail;

  /// No description provided for @needMdp.
  ///
  /// In en, this message translates to:
  /// **'Password needed'**
  String get needMdp;

  /// No description provided for @mdpTooShort.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get mdpTooShort;

  /// No description provided for @needConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirmation needed'**
  String get needConfirm;

  /// No description provided for @mdpMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords have to be identical'**
  String get mdpMismatch;

  /// No description provided for @stockageAvocat.
  ///
  /// In en, this message translates to:
  /// **'Avocado Storage'**
  String get stockageAvocat;

  /// No description provided for @alerteRisque.
  ///
  /// In en, this message translates to:
  /// **'Risk Alert!'**
  String get alerteRisque;

  /// No description provided for @accuse.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge'**
  String get accuse;

  /// No description provided for @alertesActives.
  ///
  /// In en, this message translates to:
  /// **'Active Alerts'**
  String get alertesActives;

  /// No description provided for @seuilsFAO.
  ///
  /// In en, this message translates to:
  /// **'AVOCADO FAO THRESHOLDS'**
  String get seuilsFAO;

  /// No description provided for @lastMesure.
  ///
  /// In en, this message translates to:
  /// **'Last mesure: '**
  String get lastMesure;

  /// No description provided for @combien.
  ///
  /// In en, this message translates to:
  /// **''**
  String get combien;

  /// No description provided for @combien2.
  ///
  /// In en, this message translates to:
  /// **'ago'**
  String get combien2;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get now;

  /// No description provided for @ventilationChambreFroide.
  ///
  /// In en, this message translates to:
  /// **'Check the ventilation of the cold room.'**
  String get ventilationChambreFroide;

  /// No description provided for @display.
  ///
  /// In en, this message translates to:
  /// **'display every'**
  String get display;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// No description provided for @maturation.
  ///
  /// In en, this message translates to:
  /// **'Maturation'**
  String get maturation;

  /// No description provided for @alerteFermentation.
  ///
  /// In en, this message translates to:
  /// **'Fermentation alert'**
  String get alerteFermentation;

  /// No description provided for @configuration.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get configuration;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'TEMPERATURE'**
  String get temperature;

  /// No description provided for @humidite.
  ///
  /// In en, this message translates to:
  /// **'HUMIDITY'**
  String get humidite;

  /// No description provided for @frequenceMesure.
  ///
  /// In en, this message translates to:
  /// **'MEASUREMENT FREQUENCY'**
  String get frequenceMesure;

  /// No description provided for @seuilsAlerte.
  ///
  /// In en, this message translates to:
  /// **'Alert thresholds'**
  String get seuilsAlerte;

  /// No description provided for @capteurID.
  ///
  /// In en, this message translates to:
  /// **'CAPTOR IDENTIFICATION'**
  String get capteurID;

  /// No description provided for @lotID.
  ///
  /// In en, this message translates to:
  /// **'NAME OF THE BATCH'**
  String get lotID;

  /// No description provided for @cultureID.
  ///
  /// In en, this message translates to:
  /// **'CULTURE MONITORED'**
  String get cultureID;

  /// No description provided for @faoVal.
  ///
  /// In en, this message translates to:
  /// **'FAO values recommended'**
  String get faoVal;

  /// No description provided for @temperatureMax.
  ///
  /// In en, this message translates to:
  /// **'Max temperature'**
  String get temperatureMax;

  /// No description provided for @humidityMax.
  ///
  /// In en, this message translates to:
  /// **'Max humidity'**
  String get humidityMax;

  /// No description provided for @co2Max.
  ///
  /// In en, this message translates to:
  /// **'Max CO₂'**
  String get co2Max;

  /// No description provided for @historique.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historique;

  /// No description provided for @uneHeure.
  ///
  /// In en, this message translates to:
  /// **'1h'**
  String get uneHeure;

  /// No description provided for @septJours.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get septJours;

  /// No description provided for @trenteJours.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get trenteJours;

  /// No description provided for @temp.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temp;

  /// No description provided for @hr.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get hr;

  /// No description provided for @co2.
  ///
  /// In en, this message translates to:
  /// **'CO₂'**
  String get co2;

  /// No description provided for @seuil.
  ///
  /// In en, this message translates to:
  /// **'Thresholds'**
  String get seuil;

  /// No description provided for @journalAlerte.
  ///
  /// In en, this message translates to:
  /// **'ALERTS DIARY'**
  String get journalAlerte;

  /// No description provided for @min41.
  ///
  /// In en, this message translates to:
  /// **'41 min ago'**
  String get min41;

  /// No description provided for @h3.
  ///
  /// In en, this message translates to:
  /// **'3 hours ago'**
  String get h3;

  /// No description provided for @j1.
  ///
  /// In en, this message translates to:
  /// **'1 day ago'**
  String get j1;

  /// No description provided for @hrMsg.
  ///
  /// In en, this message translates to:
  /// **'High relative humidity - HR 91%'**
  String get hrMsg;

  /// No description provided for @tempMsg.
  ///
  /// In en, this message translates to:
  /// **'Temperature near threashold - T° 6.9°C'**
  String get tempMsg;

  /// No description provided for @hrMsg2.
  ///
  /// In en, this message translates to:
  /// **'High relative humidity - HR 90.5%'**
  String get hrMsg2;

  /// No description provided for @pasDeDonnees.
  ///
  /// In en, this message translates to:
  /// **'No data for this period'**
  String get pasDeDonnees;

  /// No description provided for @rapportLot.
  ///
  /// In en, this message translates to:
  /// **'Batch Report'**
  String get rapportLot;

  /// No description provided for @rapportTitre.
  ///
  /// In en, this message translates to:
  /// **'Report Batch 03'**
  String get rapportTitre;

  /// No description provided for @scoreRisqueGlobal.
  ///
  /// In en, this message translates to:
  /// **'GLOBAL RISK SCORE'**
  String get scoreRisqueGlobal;

  /// No description provided for @faible.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get faible;

  /// No description provided for @modere.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get modere;

  /// No description provided for @eleve.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get eleve;

  /// No description provided for @duree.
  ///
  /// In en, this message translates to:
  /// **'STOCK LIFE SPAN'**
  String get duree;

  /// No description provided for @jour.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get jour;

  /// No description provided for @jours.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get jours;

  /// No description provided for @alertes.
  ///
  /// In en, this message translates to:
  /// **'TRIGGERED\nALERTS'**
  String get alertes;

  /// No description provided for @moyTemp.
  ///
  /// In en, this message translates to:
  /// **'AVERAGE T°'**
  String get moyTemp;

  /// No description provided for @maxHR.
  ///
  /// In en, this message translates to:
  /// **'MAX HR REACHED'**
  String get maxHR;

  /// No description provided for @co2Moy.
  ///
  /// In en, this message translates to:
  /// **'AVERAGE CO₂'**
  String get co2Moy;

  /// No description provided for @totMesure.
  ///
  /// In en, this message translates to:
  /// **'TOTAL MEASURES'**
  String get totMesure;

  /// No description provided for @visuel.
  ///
  /// In en, this message translates to:
  /// **'FOLLOW-UP VISUAL'**
  String get visuel;

  /// No description provided for @exportCSV.
  ///
  /// In en, this message translates to:
  /// **'CSV EXPORT'**
  String get exportCSV;

  /// No description provided for @langue.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get langue;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'QUICK ACCESS'**
  String get quickAccess;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settings;

  /// No description provided for @moduleTitleProfil.
  ///
  /// In en, this message translates to:
  /// **'🌿 Module 1 - Plant Diagnosis'**
  String get moduleTitleProfil;

  /// No description provided for @module2TitleProfil.
  ///
  /// In en, this message translates to:
  /// **'📦 Module 2 - IoT'**
  String get module2TitleProfil;

  /// No description provided for @fusionIaIoT.
  ///
  /// In en, this message translates to:
  /// **'🔗 Merge: IA + IoT'**
  String get fusionIaIoT;

  /// No description provided for @voirProfil.
  ///
  /// In en, this message translates to:
  /// **'View my profile →'**
  String get voirProfil;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @anglais.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get anglais;

  /// No description provided for @slogan.
  ///
  /// In en, this message translates to:
  /// **'SECURE. MONITOR. PROTECT.'**
  String get slogan;

  /// No description provided for @userScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userScreenTitle;

  /// No description provided for @nonDefini.
  ///
  /// In en, this message translates to:
  /// **'Not defined'**
  String get nonDefini;

  /// No description provided for @agri.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get agri;

  /// No description provided for @gestionn.
  ///
  /// In en, this message translates to:
  /// **'Stock manager'**
  String get gestionn;

  /// No description provided for @pbProfil.
  ///
  /// In en, this message translates to:
  /// **'Profile not defined'**
  String get pbProfil;

  /// No description provided for @emailVerification.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent'**
  String get emailVerification;

  /// No description provided for @profilSauvegarde.
  ///
  /// In en, this message translates to:
  /// **'Profile saved!'**
  String get profilSauvegarde;

  /// No description provided for @sain.
  ///
  /// In en, this message translates to:
  /// **'Safe'**
  String get sain;

  /// No description provided for @douteux.
  ///
  /// In en, this message translates to:
  /// **'Suspect'**
  String get douteux;

  /// No description provided for @infecte.
  ///
  /// In en, this message translates to:
  /// **'Infected'**
  String get infecte;

  /// No description provided for @danger.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get danger;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @delayed.
  ///
  /// In en, this message translates to:
  /// **'Lated signal'**
  String get delayed;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @alerteTemp.
  ///
  /// In en, this message translates to:
  /// **'Temperature high'**
  String get alerteTemp;

  /// No description provided for @alerteHumid.
  ///
  /// In en, this message translates to:
  /// **'Humidity high'**
  String get alerteHumid;

  /// No description provided for @alerteco2.
  ///
  /// In en, this message translates to:
  /// **'CO₂ high'**
  String get alerteco2;

  /// No description provided for @capteurOff.
  ///
  /// In en, this message translates to:
  /// **'Offline Captor'**
  String get capteurOff;

  /// No description provided for @fusionTitle.
  ///
  /// In en, this message translates to:
  /// **'Merge IA + IoT'**
  String get fusionTitle;

  /// No description provided for @correlation.
  ///
  /// In en, this message translates to:
  /// **'Correlated View'**
  String get correlation;

  /// No description provided for @plantsDouteux.
  ///
  /// In en, this message translates to:
  /// **'DUBIOUS PLANTS'**
  String get plantsDouteux;

  /// No description provided for @plantsDanger.
  ///
  /// In en, this message translates to:
  /// **'PLANTS IN DANGER'**
  String get plantsDanger;

  /// No description provided for @alertesIoT.
  ///
  /// In en, this message translates to:
  /// **'ALERTS'**
  String get alertesIoT;

  /// No description provided for @totalScans.
  ///
  /// In en, this message translates to:
  /// **'TOTAL SCANS'**
  String get totalScans;

  /// No description provided for @seuilsParDefaut.
  ///
  /// In en, this message translates to:
  /// **'Default thresholds'**
  String get seuilsParDefaut;

  /// No description provided for @alerteTemp2.
  ///
  /// In en, this message translates to:
  /// **'TEMPERATURE ALERTS'**
  String get alerteTemp2;

  /// No description provided for @alerteHR.
  ///
  /// In en, this message translates to:
  /// **'HUMIDITY ALERTS'**
  String get alerteHR;

  /// No description provided for @alerteCO2.
  ///
  /// In en, this message translates to:
  /// **'CO₂ ALERTS'**
  String get alerteCO2;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
