// Importations de la bibliothèque et des fichiers nécessaire
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/app_notifiers.dart'; // pour accéder aux variables de préférences de l'application
import 'package:avocadoguard/core/services/notification_service.dart'; // pour envoyer les notifications
import 'package:avocadoguard/core/services/user_service.dart'; // pour accéder aux préférences de l'utilisateur
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour accéder à la traduction des textes

class SettingsCard extends StatefulWidget {
  // Classe permettant de configurer la carte des paramètres de l'application
  final String title;
  final String subtitle;

  const SettingsCard({
    // Constructeur de la classe
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  State<SettingsCard> createState() => _SettingsCardState(); // permet de créer l'état mutable de la classe
}

class _SettingsCardState extends State<SettingsCard> {
  // Classe permettant de gérer l'affichage du widget de la carte des paramètres de l'application

  @override
  Widget build(BuildContext context) {
    // Widget permettant de gérer l'affichage de la carte des paramètres de l'application
    final l10n = AppLocalizations.of(context)!; // permet de changer la langue des textes
    return ValueListenableBuilder<bool>( // permet de recharger si le thème de l'application est modifié
      valueListenable: darkModeNotifier,
      builder: (context, darkMode, _){
        return Container(
          width: double.infinity, // permet d'utiliser toute la largeur possible
          padding: const EdgeInsets.all(AgrosafeTheme.cardPadding), // Marge interne de la carte
          // Style de la carte
          decoration: BoxDecoration(
            color: AgrosafeTheme.cardBg(),
            borderRadius: BorderRadius.circular(AgrosafeTheme.radiusCards),
            border: Border.all(color: AgrosafeTheme.borderColor()),
          ),
          child: Column( // Organisation en colonne
            crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
            children: [
              // ------ BOUTON DE LANGUE ------
              Row( // Organisation en ligne
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child:Row(
                      children: [
                        Icon(Icons.translate, size: 30, color: AgrosafeTheme.iconeColor()), // Affichage de l'icône de traduction et son style
                        const SizedBox(width: 12), // Espace entre l'icône et le texte
                        Flexible(
                          // Affichage du texte avec son style
                          child: Text(l10n.langue,
                            overflow: TextOverflow.ellipsis, // Permet d'afficher '... ' à la fin du texte s'il est trop grand pour l'écran
                            style: AgrosafeTheme.displayTitle.copyWith(
                              color: AgrosafeTheme.textPrimary(), 
                              fontSize: MediaQuery.of(context).size.width<600 ? 19 : 25,  // permet de changer la taille de la police en fonction de la taille de l'écran
                              fontWeight: FontWeight.w200)
                          ),
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder<Locale>( // Permet d'être à l'écoute des boutons de langue et recharger l'application lorsque la langue est changée
                      valueListenable: localeNotifier,
                      builder: (context, locale, _) {
                        return Row( // Organisation en ligne des boutons
                          children: [
                            // Action du bouton français
                            GestureDetector(
                              onTap: (){
                                localeNotifier.value = const Locale('fr'); // permet de changer la valeur de la variable locale de langue
                                UserService.savePreferences(locale: 'fr'); // permet de sauvegarder la nouvelle valeur de la variable locale de langue
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Marge interne du bouton
                                // Style du bouton
                                decoration: BoxDecoration(
                                  color: locale.languageCode == 'fr' ? AgrosafeTheme.leaf : AgrosafeTheme.bg(), // la couleur du bouton est différente s'il est sélectionné ou non
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AgrosafeTheme.leaf),
                                ),
                                // Texte du bouton français et son style
                                child: Text('🇫🇷 FR', // Le petit FR permet d'afficher le drapeau français
                                    style: TextStyle(
                                      color: locale.languageCode == 'fr' ? AgrosafeTheme.cardBg() : AgrosafeTheme.leaf, // la couleur de la police change lorsque le bouton est sélectionné ou non
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ),
                            const SizedBox(width: 8), // Espace entre le bouton français et celui de l'anglais
                            // Action du bouton anglais
                            GestureDetector(
                              onTap: (){
                                localeNotifier.value = const Locale('en'); // On change la valeur de la variable locale de langue
                                UserService.savePreferences(locale: 'en'); // On sauvegarde la nouvelle variable
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Marges interne du bouton
                                // Style du bouton
                                decoration: BoxDecoration(
                                  color: locale.languageCode == 'en' ? AgrosafeTheme.leaf : AgrosafeTheme.bg(), // La couleur change en fonction du fait qu'il soit sélectionné ou non
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AgrosafeTheme.leaf),
                                ),
                                // Texte du bouton et son style
                                child: Text('🇬🇧 EN',
                                    style: TextStyle(
                                      color: locale.languageCode == 'en' ? AgrosafeTheme.cardBg() : AgrosafeTheme.leaf, // La couleur de la police change en fonction du fait qu'il soit sélectionné ou non
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 15), // Espace entre le paramètre de langue et la ligne séparatrice
              Divider(height: 1, color: AgrosafeTheme.separationColor()), // Ligne séparatrice et son style
              const SizedBox(height: 15), // Espace entre la ligne séparatrice et le paramètre de notifications
              
              // ------ NOTIFICATIONS ------
              Row( // Organisation en ligne
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.notifications, size: 30, color: AgrosafeTheme.iconeColor()), // Affichage de l'icône et de son style
                        const SizedBox(width: 12), // Espace entre l'icône et le texte
                        Flexible(
                          // Texte du paramètre et son style
                          child: Text(widget.title,
                            overflow: TextOverflow.ellipsis, // permet d'afficher '...' si l'écran est trop petit pour le texte entier
                            style: AgrosafeTheme.displayTitle.copyWith(
                                color: AgrosafeTheme.textPrimary(), 
                                fontSize: MediaQuery.of(context).size.width<600 ? 19 : 25, // permet de changer la taille de la police en fonction de la taille de l'écran
                                fontWeight: FontWeight.w200)),
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder<bool>(  // Permet d'écouter la valeur de la variable de notification
                    valueListenable: notificationsNotifier,
                    builder: (context, notifEnabled, _) {
                      return Switch( // Création d'un bouton type switch (on/off)
                        value: notifEnabled,  // variable du switch
                        // Action du switch
                        onChanged: (value) async {
                          notificationsNotifier.value = value;  // met à jour le notifier en fonction de la nouvelle valeur
                          if (value) await NotificationService.init();
                          UserService.savePreferences(notifications: value); // on sauvegarde la nouvelle préférence
                        },
                    thumbColor: WidgetStateProperty.resolveWith((states) { // Change de couleur en fonction de sa position
                      // Cas 1 : switch ON
                      if (states.contains(WidgetState.selected)) {
                        return AgrosafeTheme.cardBg(); // Couleur du point
                      }
                      // Cas 2 : switch OFF
                      else{
                        return AgrosafeTheme.textMuted(); // Couleur du point
                      }
                    }),
                    trackColor: WidgetStateProperty.resolveWith((states) { // Change de couleur en fonction de la position du point
                      // Cas 1 : switch ON
                      if (states.contains(WidgetState.selected)) {
                        return AgrosafeTheme.leaf; // Couleur du fond
                      }
                      else{
                        return AgrosafeTheme.bg(); // Couleur du fond
                      }
                    }),
                    trackOutlineColor: WidgetStateProperty.resolveWith((states) { // Change de couleur en fonction de la position du point
                      // Cas 1 : switch ON
                      if (states.contains(WidgetState.selected)) {
                        return Colors.transparent; // Couleur du contour
                      }
                      // Cas 2  : switch OFF
                      else{
                        return AgrosafeTheme.leaf; // Couleur du contour
                      }
                    }),
                  );
                },
                ),
              ],
              ),
              const SizedBox(height: 15), // Espace entre le paramètre de notification et la ligne séparatrice
              Divider(height: 1, color: AgrosafeTheme.separationColor()), // Ligne séparatrice et son style
              const SizedBox(height: 15), // Espace entre la ligne séparatrice et son paramètre de thème (clair/sombre)

              // ------ DARK MODE ------
              ValueListenableBuilder<bool>( // On écoute la variable de thème
                valueListenable: darkModeNotifier,
                builder: (context, darkMode, _) {
                  return Row( // Organisation en ligne
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child:Row(
                          children: [
                            // Affichage de l'icône de thème et son style
                            Icon(
                              darkModeNotifier.value ? Icons.nightlight : Icons.sunny, // Icône soleil si thème clair et icône de demi-lune si thème sombre
                              size: 30, 
                              color: AgrosafeTheme.iconeColor()),
                            const SizedBox(width: 12), // Espace entre l'icône et le texte du paramètre
                            // Affichage du texte du paramètre et son style
                            Text(widget.subtitle,
                            overflow: TextOverflow.ellipsis, // permet d'afficher '...' si le texte est trop long par rapport à la taille de l'écran
                              style: AgrosafeTheme.displayTitle.copyWith( 
                                color: AgrosafeTheme.textPrimary(),
                                fontSize: MediaQuery.of(context).size.width<600 ? 19 : 25, // permet de changer la taille de la police en fonction de la taille de l'écran
                                fontWeight: FontWeight.w200)
                            ),
                          ],
                        ),
                      ),
                      // Affichage d'un bouton type switch (on/off)
                      Switch(
                        value: darkModeNotifier.value, // variable du switch
                        // Action du bouton switch
                        onChanged: (value) {
                          darkModeNotifier.value = value; // permet de changer la valeur de la variable du bouton switch
                          UserService.savePreferences(darkMode: value); // permet de sauvegarder la nouvelle valeur de la variable du bouton switch
                        },
                        // Couleur du point du switch
                        thumbColor: WidgetStateProperty.resolveWith((states) {
                          // Cas 1 : switch on
                          if (states.contains(WidgetState.selected)) {
                            return AgrosafeTheme.cardBg();
                          }
                          // Cas 2 : switch off
                          else{
                            return AgrosafeTheme.textMuted();
                          }
                        }),
                        // Couleur de fond du switch
                        trackColor: WidgetStateProperty.resolveWith((states) {
                          // Cas 1 : switch on
                          if (states.contains(WidgetState.selected)) {
                            return AgrosafeTheme.leaf;
                          }
                          // Cas 2 : switch off
                          else {
                            return AgrosafeTheme.bg();
                          }
                        }),
                        // Couleur du contour du switch
                        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
                          // Cas 1 : switch on
                          if (states.contains(WidgetState.selected)) {
                            return Colors.transparent;
                          }
                          // Cas 2 : switch off
                          else{
                            return AgrosafeTheme.leaf;
                          }
                        }),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      }
    );
  }
}