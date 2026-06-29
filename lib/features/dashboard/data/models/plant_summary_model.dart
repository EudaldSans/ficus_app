import '../../domain/entities/plant_summary.dart';

class PlantSummaryModel extends PlantSummary {
  const PlantSummaryModel({
    required super.macAddress,
    super.name,
    super.temperature,
    super.soilMoisture,
    super.lastUpdated,
  });

  factory PlantSummaryModel.fromFirebase(
    String macAddress,
    Map<String, dynamic> data,
  ) {
    final entries = data.entries
        .where((e) => int.tryParse(e.key) != null)
        .map((e) => MapEntry(int.parse(e.key), e.value))
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (entries.isEmpty) {
      return PlantSummaryModel(macAddress: macAddress);
    }

    final latest = entries.last;
    final reading = Map<String, dynamic>.fromEntries(
      (latest.value as Map).entries.map((e) => MapEntry(e.key.toString(), e.value)),
    );

    return PlantSummaryModel(
      macAddress: macAddress,
      temperature: (reading['t'] as num?)?.toDouble(),
      soilMoisture: (reading['sm'] as num?)?.toDouble(),
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(latest.key * 1000),
    );
  }
}
