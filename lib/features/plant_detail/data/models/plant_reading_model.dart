import '../../domain/entities/plant_reading.dart';

class PlantReadingModel extends PlantReading {
  const PlantReadingModel({
    required super.timestamp,
    super.temperature,
    super.soilMoisture,
  });

  factory PlantReadingModel.fromFirebase(
    String timestampKey,
    Map<dynamic, dynamic> data,
  ) {
    final ts = int.tryParse(timestampKey) ?? 0;
    return PlantReadingModel(
      timestamp: DateTime.fromMillisecondsSinceEpoch(ts * 1000),
      temperature: (data['t'] as num?)?.toDouble(),
      soilMoisture: (data['sm'] as num?)?.toDouble(),
    );
  }
}
