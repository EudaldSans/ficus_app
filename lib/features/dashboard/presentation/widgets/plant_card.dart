import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/plant_health_status.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/plant_summary.dart';
import '../providers/plants_provider.dart';

class PlantCard extends ConsumerWidget {
  final PlantSummary plant;
  final VoidCallback onTap;

  const PlantCard({super.key, required this.plant, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantType = ref.watch(plantTypeProvider(plant.macAddress));
    final healthStatuses = PlantHealthStatus.compute(
      plantType: plantType,
      humidity: plant.humidity,
      temperature: plant.temperature,
    );

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.eco, color: AppColors.green, size: 20),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      plant.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.greenDark,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ...healthStatuses.map((s) => Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: _HealthBadge(status: s),
                      )),
                ],
              ),
              const Spacer(),
              _ReadingRow(
                icon: Icons.thermostat_outlined,
                label: 'Temp',
                value: plant.temperature != null
                    ? '${plant.temperature!.toStringAsFixed(1)} °C'
                    : '—',
              ),
              const SizedBox(height: 8),
              _ReadingRow(
                icon: Icons.water_drop_outlined,
                label: 'Humidity',
                value: plant.humidity != null
                    ? '${plant.humidity!.toStringAsFixed(1)} %'
                    : '—',
              ),
              if (plant.lastUpdated != null) ...[
                const SizedBox(height: 8),
                Text(
                  DateFormat('MMM d, HH:mm').format(plant.lastUpdated!),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurface.withValues(alpha: 0.45),
                        fontSize: 10,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

Color _healthColor(PlantHealthStatus status) => switch (status) {
      PlantHealthStatus.healthy => AppColors.green,
      PlantHealthStatus.overwatered => const Color(0xFF1565C0),
      PlantHealthStatus.needsWatering => const Color(0xFFE65100),
      PlantHealthStatus.tempTooHigh => const Color(0xFFB71C1C),
      PlantHealthStatus.tempTooLow => const Color(0xFF283593),
      PlantHealthStatus.unknown => AppColors.error
    };

class _HealthBadge extends StatelessWidget {
  final PlantHealthStatus status;

  const _HealthBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _healthColor(status);
    final icon = switch (status) {
      PlantHealthStatus.healthy => Icons.check_circle_outline,
      PlantHealthStatus.overwatered => Icons.water,
      PlantHealthStatus.needsWatering => Icons.water_drop_outlined,
      PlantHealthStatus.tempTooHigh => Icons.wb_sunny_outlined,
      PlantHealthStatus.tempTooLow => Icons.ac_unit,
      PlantHealthStatus.unknown => Icons.help_outline,
    };

    return Tooltip(
      message: switch (status) {
        PlantHealthStatus.healthy => 'Healthy',
        PlantHealthStatus.overwatered => 'Overwatered',
        PlantHealthStatus.needsWatering => 'Needs water',
        PlantHealthStatus.tempTooHigh => 'Too hot',
        PlantHealthStatus.tempTooLow => 'Too cold',
        PlantHealthStatus.unknown => '',
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
        ),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }
}

class _ReadingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ReadingRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.green),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurface.withValues(alpha: 0.6),
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.greenDark,
              ),
        ),
      ],
    );
  }
}
