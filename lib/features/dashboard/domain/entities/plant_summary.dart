class PlantSummary {
  final String macAddress;
  final String? name;
  final double? temperature;
  final double? humidity;
  final DateTime? lastUpdated;

  const PlantSummary({
    required this.macAddress,
    this.name,
    this.temperature,
    this.humidity,
    this.lastUpdated,
  });

  String get displayName => (name != null && name!.isNotEmpty)
      ? name!
      : 'Plant ${macAddress.substring(macAddress.length - 4)}';
}
