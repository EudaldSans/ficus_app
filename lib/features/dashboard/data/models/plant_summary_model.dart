import '../../domain/entities/plant_summary.dart';

class PlantSummaryModel extends PlantSummary {
  const PlantSummaryModel({
    required super.macAddress,
    super.temperature,
    super.humidity,
    super.lastUpdated,
  });

  factory PlantSummaryModel.fromFirebase(
    String macAddress,
    Map<dynamic, dynamic> readingsMap,
  ) {
    final entries = readingsMap.entries
        .map((e) => MapEntry(int.tryParse(e.key.toString()) ?? 0, e.value))
        .where((e) => e.key > 0)
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (entries.isEmpty) {
      return PlantSummaryModel(macAddress: macAddress);
    }

    final latest = entries.last;
    final data = Map<dynamic, dynamic>.from(latest.value as Map? ?? {});

    return PlantSummaryModel(
      macAddress: macAddress,
      temperature: (data['temperature'] as num?)?.toDouble(),
      humidity: (data['humidity'] as num?)?.toDouble(),
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(latest.key * 1000),
    );
  }
}
