import 'package:flutter/material.dart';
import 'package:avocadoguard/core/models/connection_status.dart';
import 'package:avocadoguard/core/models/lot_config.dart';
import 'package:avocadoguard/core/theme/app_theme.dart';
import 'package:avocadoguard/l10n/app_localizations.dart';
import 'package:avocadoguard/widgets/alert_window.dart';

class AlertBanner extends StatelessWidget {
  final double temperature;
  final double humidity;
  final int co2;
  final LotConfig config;
  final ConnectionStatus connectionStatus;

  const AlertBanner({
    super.key,
    required this.temperature,
    required this.humidity,
    required this.co2,
    required this.config,
    required this.connectionStatus,
  });

  List<String> _activeAlerts(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final alerts = <String>[];

    if (temperature > config.temperatureMax) {
      alerts.add('${l10n.alerteTemp} ($temperature°C > ${config.temperatureMax.toStringAsFixed(0)}°C)');
    }
    if (humidity > config.humidityMax) {
      alerts.add('${l10n.alerteHumid} (${humidity.toInt()}% > ${config.humidityMax.toStringAsFixed(0)}%)');
    }
    if (co2 > config.co2Max) {
      alerts.add('${l10n.alerteco2} ($co2 ppm > ${config.co2Max.toStringAsFixed(0)} ppm)');
    }
    if (connectionStatus == ConnectionStatus.offline) {
      alerts.add(l10n.capteurOff);
    }

    return alerts;
  }

  void _showAlertModal(BuildContext context, List<String> alerts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AlertModal(alerts: alerts),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final alerts = _activeAlerts(context);
    final count = alerts.length;

    if (count == 0) return const SizedBox.shrink();

    final message = count == 1 ? alerts.first : '$count ${l10n.alertesActives}';

    return GestureDetector(
      onTap: () => _showAlertModal(context, alerts),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AgrosafeTheme.dangerPastel,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AgrosafeTheme.danger.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AgrosafeTheme.danger.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: AgrosafeTheme.danger, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        count == 1 ? l10n.alerteRisque : '$count ${l10n.alertesActives}',
                        style: AgrosafeTheme.bodyText.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AgrosafeTheme.danger,
                        ),
                      ),
                      if (count > 1) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AgrosafeTheme.danger,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: AgrosafeTheme.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: const TextStyle(color: AgrosafeTheme.moss, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}