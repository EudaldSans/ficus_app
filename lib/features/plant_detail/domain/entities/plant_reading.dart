class PlantReading {
  final DateTime timestamp;
  final double? temperature;
  final double? soilMoisture;

  const PlantReading({
    required this.timestamp,
    this.temperature,
    this.soilMoisture,
  });
}
