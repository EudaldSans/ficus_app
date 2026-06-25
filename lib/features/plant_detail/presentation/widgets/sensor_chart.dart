import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/plant_reading.dart';

class SensorChart extends StatelessWidget {
  final List<PlantReading> readings;
  final double? Function(PlantReading) valueSelector;
  final Color color;
  final String unit;

  const SensorChart({
    super.key,
    required this.readings,
    required this.valueSelector,
    required this.color,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final spots = readings
        .where((r) => valueSelector(r) != null)
        .map((r) => FlSpot(
              r.timestamp.millisecondsSinceEpoch.toDouble(),
              valueSelector(r)!,
            ))
        .toList();

    if (spots.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.creamDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Text('No data available')),
      );
    }

    final minX = spots.first.x;
    final maxX = spots.last.x;
    final values = spots.map((s) => s.y).toList();
    final dataMin = values.reduce((a, b) => a < b ? a : b);
    final dataMax = values.reduce((a, b) => a > b ? a : b);
    final padding = ((dataMax - dataMin) * 0.15).clamp(1.0, double.infinity);
    final minY = dataMin - padding;
    final maxY = dataMax + padding;

    final xRange = maxX - minX;
    final xInterval = xRange > 0 ? xRange / 4 : 1.0;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.creamDark,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(4, 16, 16, 8),
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: spots.length > 2,
              curveSmoothness: 0.3,
              color: color,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: spots.length <= 15),
              belowBarData: BarAreaData(
                show: true,
                color: color.withValues(alpha: 0.08),
              ),
            ),
          ],
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppColors.onSurface.withValues(alpha: 0.08),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: xInterval,
                getTitlesWidget: (value, meta) {
                  final dt =
                      DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat('HH:mm').format(dt),
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.onSurface,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.greenDark.withValues(alpha: 0.85),
              getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                final dt =
                    DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)} $unit\n'
                  '${DateFormat('MMM d, HH:mm').format(dt)}',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    height: 1.5,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
