// Importations des bibliothèques et fichiers nécessaires
import 'package:flutter/material.dart';
import 'package:avocadoguard/core/models/connection_status.dart'; // pour accéder au statut de connexion de la carte du module 2
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart'; // pour accéder à la traduction des textes

class LiveIndicator extends StatefulWidget {
  // Classe permettant de configurer le widget de connexion à la carte du module 2
  final ConnectionStatus status;  // On vérifie la connexion

  const LiveIndicator({
    // Constructeur de la classe
    super.key,
    this.status = ConnectionStatus.live, // live par défaut
  });

  @override
  State<LiveIndicator> createState() => _LiveIndicatorState(); // permet de créer le statut mutable de la classe
}

class _LiveIndicatorState extends State<LiveIndicator> with SingleTickerProviderStateMixin {
  // Permet de configurer l'affichage de l'indicateur du statut de connexion de la carte du module 2
  late AnimationController _controller;
  late Animation<double> _animation;

  // Permet de récupérer la couleur du statut selon l'état de connexion
  Color get _color {
    switch (widget.status) {
      case ConnectionStatus.live:    return AgrosafeTheme.safe;
      case ConnectionStatus.delayed: return AgrosafeTheme.warning;
      case ConnectionStatus.offline: return AgrosafeTheme.danger;
    }
  }

  // Permet de récupérer le label selon le statut en utilisant les traductions des textes
  String get _label {
    switch (widget.status) {
      case ConnectionStatus.live:    return AppLocalizations.of(context)!.live;
      case ConnectionStatus.delayed: return AppLocalizations.of(context)!.delayed;
      case ConnectionStatus.offline: return AppLocalizations.of(context)!.offline;
    }
  }

  bool get _shouldBlink => widget.status == ConnectionStatus.live; // permet à ce que le point clignote quand on est en live

  @override
  void initState() {
    // Fonction permettant d'initialiser le point animé du statut du module
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    // Fonction permettant de nettoyer les données
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Widget permettant de gérer l'affichage de l'étiquette du statut du module
    return Row( // Alignement en ligne
      mainAxisSize: MainAxisSize.min,
      children: [
        // Clignote seulement si on est en direct sinon il est statique
        _shouldBlink
            ? FadeTransition(
                opacity: _animation,
                child: _dot(),
              )
            : _dot(), // fixe si en retard ou hors ligne
        const SizedBox(width: 6), // Espace entre le point et le texte
        // Affichage du texte avec son style
        Text(
          _label,
          style: AgrosafeTheme.dataText.copyWith(color: _color),
        ),
      ],
    );
  }

  Widget _dot() => Container(
    // Widget permettant de définir le point si on ne reçoit pas les données en direct
        width: 8, // Largeur de l'emplacement du point
        height: 8, // Hauteur de l'emplacement du point
        // Style du point
        decoration: BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
        ),
      );
}