import 'package:flutter/material.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart';

class QuickAccessCard extends StatelessWidget {
  final VoidCallback onCtaTap1;
  final VoidCallback onCtaTap2;
  final VoidCallback onCtaTap3;

  const QuickAccessCard({
    super.key,
    required this.onCtaTap1,
    required this.onCtaTap2,
    required this.onCtaTap3,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AgrosafeTheme.cardPadding),
      decoration: BoxDecoration(
        color: AgrosafeTheme.cardBg(),
        borderRadius: BorderRadius.circular(AgrosafeTheme.radiusCards),
        border: Border.all(color: AgrosafeTheme.borderColor()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------ MODULE 2 SCREEN ------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.module2TitleProfil,
                      style: AgrosafeTheme.displayTitle.copyWith(
                        color: AgrosafeTheme.textPrimary(),
                        fontSize: 25,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onCtaTap1,
                child: Text("→", style: AgrosafeTheme.quickAccess),
              ),
            ],
          ),
          const SizedBox(height: 15), // Espace entre la sous-carte et la ligne séparatrice
          Divider(height: 1, color: AgrosafeTheme.separationColor()), // Ligne séparatrice et son style
          const SizedBox(height: 15), // Espace entre la ligne séparatrice et la dernière sous-carte

          // ------ HISTORY SCREEN ------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📊 ${l10n.historique}',
                      style: AgrosafeTheme.displayTitle.copyWith(
                        color: AgrosafeTheme.textPrimary(),
                        fontSize: 25,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onCtaTap2,
                child: Text("→", style: AgrosafeTheme.quickAccess),
              ),
            ],
          ),
          const SizedBox(height: 15), // Espace entre la sous-carte et la ligne séparatrice
          Divider(height: 1, color: AgrosafeTheme.separationColor()), // Ligne séparatrice et son style
          const SizedBox(height: 15), // Espace entre la ligne séparatrice et la dernière sous-carte

          // ------ REPORT SCREEN ------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📋 ${l10n.rapportLot}',
                      style: AgrosafeTheme.displayTitle.copyWith(
                        color: AgrosafeTheme.textPrimary(),
                        fontSize: 25,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onCtaTap3,
                child: Text("→", style: AgrosafeTheme.quickAccess),
              ),
            ],
          ),
        ],
      ),
    );
  }
}