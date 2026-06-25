class PlantSummary {
  final String macAddress;
  final double? temperature;
  final double? humidity;
  final DateTime? lastUpdated;

  const PlantSummary({
    required this.macAddress,
    this.temperature,
    this.humidity,
    this.lastUpdated,
  });

  String get displayName => 'Plant ${macAddress.substring(macAddress.length - 4)}';
}
