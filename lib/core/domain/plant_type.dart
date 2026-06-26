enum PlantType {
  ficusEnanus;

  String get displayName => switch (this) {
        PlantType.ficusEnanus => 'Ficus enanus',
      };

  // Temperature thresholds (°C)
  double get tempCriticalLow => switch (this) {
        PlantType.ficusEnanus => 10.0,
      };
  double get tempCriticalHigh => switch (this) {
        PlantType.ficusEnanus => 32.0,
      };
  double get tempIdealMin => switch (this) {
        PlantType.ficusEnanus => 18.0,
      };
  double get tempIdealMax => switch (this) {
        PlantType.ficusEnanus => 26.0,
      };

  // Soil moisture thresholds (%)
  double get humidityDry => switch (this) {
        PlantType.ficusEnanus => 30.0,
      };
  double get humidityOverwatered => switch (this) {
        PlantType.ficusEnanus => 80.0,
      };
  double get humidityIdealMin => switch (this) {
        PlantType.ficusEnanus => 40.0,
      };
  double get humidityIdealMax => switch (this) {
        PlantType.ficusEnanus => 65.0,
      };

  static PlantType? fromKey(String? key) =>
      key == null ? null : PlantType.values.where((t) => t.name == key).firstOrNull;
}
