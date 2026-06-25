import '../../domain/entities/plant_reading.dart';

class PlantReadingModel extends PlantReading {
  const PlantReadingModel({
    required super.timestamp,
    super.temperature,
    super.humidity,
  });

  factory PlantReadingModel.fromFirebase(
    String timestampKey,
    Map<dynamic, dynamic> data,
  ) {
    final ts = int.tryParse(timestampKey) ?? 0;
    return PlantReadingModel(
      timestamp: DateTime.fromMillisecondsSinceEpoch(ts * 1000),
      temperature: (data['temperature'] as num?)?.toDouble(),
      humidity: (data['humidity'] as num?)?.toDouble(),
    );
  }
}
