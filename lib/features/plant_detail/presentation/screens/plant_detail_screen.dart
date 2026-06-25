import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/plant_reading.dart';
import '../providers/plant_readings_provider.dart';
import '../widgets/sensor_chart.dart';

class PlantDetailScreen extends ConsumerWidget {
  final String macAddress;

  const PlantDetailScreen({super.key, required this.macAddress});

  String get _displayName =>
      'Plant ${macAddress.substring(macAddress.length - 4)}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingsAsync = ref.watch(plantReadingsProvider(macAddress));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.eco, color: AppColors.green, size: 18),
                const SizedBox(width: 6),
                Text(
                  _displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.greenDark,
                  ),
                ),
              ],
            ),
            Text(
              macAddress,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurface.withValues(alpha: 0.45),
                    fontSize: 11,
                  ),
            ),
          ],
        ),
        actions: [
          if (readingsAsync.isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () => ref.invalidate(plantReadingsProvider(macAddress)),
            ),
        ],
      ),
      body: readingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(message: error.toString()),
        data: (readings) => _ReadingsContent(readings: readings),
      ),
    );
  }
}

class _ReadingsContent extends StatelessWidget {
  final List<PlantReading> readings;

  const _ReadingsContent({required this.readings});

  @override
  Widget build(BuildContext context) {
    if (readings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.show_chart, size: 52, color: AppColors.green),
            SizedBox(height: 12),
            Text('No readings available'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatRow(readings: readings),
          const SizedBox(height: 24),
          _ChartSection(
            title: 'Temperature',
            unit: '°C',
            readings: readings,
            valueSelector: (r) => r.temperature,
            color: AppColors.green,
          ),
          const SizedBox(height: 24),
          _ChartSection(
            title: 'Humidity',
            unit: '%',
            readings: readings,
            valueSelector: (r) => r.humidity,
            color: const Color(0xFF1565C0),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final List<PlantReading> readings;

  const _StatRow({required this.readings});

  @override
  Widget build(BuildContext context) {
    final latest = readings.last;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.thermostat_outlined,
            label: 'Current Temp',
            value: latest.temperature != null
                ? '${latest.temperature!.toStringAsFixed(1)} °C'
                : '—',
            color: AppColors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.water_drop_outlined,
            label: 'Current Humidity',
            value: latest.humidity != null
                ? '${latest.humidity!.toStringAsFixed(1)} %'
                : '—',
            color: const Color(0xFF1565C0),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.creamDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurface.withValues(alpha: 0.55),
                  fontSize: 11,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  final String title;
  final String unit;
  final List<PlantReading> readings;
  final double? Function(PlantReading) valueSelector;
  final Color color;

  const _ChartSection({
    required this.title,
    required this.unit,
    required this.readings,
    required this.valueSelector,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$title ($unit)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.greenDark,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(width: 6),
            Text(
              '${readings.length} readings',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurface.withValues(alpha: 0.45),
                  ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SensorChart(
          readings: readings,
          valueSelector: valueSelector,
          color: color,
          unit: unit,
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 52),
            const SizedBox(height: 12),
            Text(
              'Failed to load readings',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
