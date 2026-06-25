import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/plant_summary.dart';

class PlantCard extends StatelessWidget {
  final PlantSummary plant;
  final VoidCallback onTap;

  const PlantCard({super.key, required this.plant, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                  Expanded(
                    child: Text(
                      plant.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.greenDark,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
                const SizedBox(height: 10),
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
