class PlantReading {
  final DateTime timestamp;
  final double? temperature;
  final double? humidity;

  const PlantReading({
    required this.timestamp,
    this.temperature,
    this.humidity,
  });
}
