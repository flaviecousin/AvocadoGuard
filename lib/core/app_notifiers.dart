// Importation de la bibliothèque Material de Flutter
import 'package:flutter/material.dart';

// Généralisation des préférences avec leurs variables
final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('fr'));
final ValueNotifier<bool> darkModeNotifier = ValueNotifier(false);
final ValueNotifier<bool> notificationsNotifier = ValueNotifier(true);