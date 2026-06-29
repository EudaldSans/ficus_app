enum PlantType {
  ficusEnanus,
  peaceLily;

  String get displayName => switch (this) {
        PlantType.ficusEnanus => 'Ficus enanus',
        PlantType.peaceLily => 'Peace Lily',
      };

  // Temperature thresholds (°C)
  double get tempCriticalLow => switch (this) {
        PlantType.ficusEnanus => 10.0,
        PlantType.peaceLily => 10.0,
      };
  double get tempCriticalHigh => switch (this) {
        PlantType.ficusEnanus => 32.0,
        PlantType.peaceLily => 35.0,
      };
  double get tempIdealMin => switch (this) {
        PlantType.ficusEnanus => 18.0,
        PlantType.peaceLily => 18.0,
      };
  double get tempIdealMax => switch (this) {
        PlantType.ficusEnanus => 26.0,
        PlantType.peaceLily => 27.0,
      };

  // Soil moisture thresholds (%)
  double get soilMoistureDry => switch (this) {
        PlantType.ficusEnanus => 30.0,
        PlantType.peaceLily => 35.0,
      };
  double get soilMoistureOverwatered => switch (this) {
        PlantType.ficusEnanus => 80.0,
        PlantType.peaceLily => 85.0,
      };
  double get soilMoistureIdealMin => switch (this) {
        PlantType.ficusEnanus => 40.0,
        PlantType.peaceLily => 50.0,
      };
  double get soilMoistureIdealMax => switch (this) {
        PlantType.ficusEnanus => 65.0,
        PlantType.peaceLily => 70.0,
      };

  static PlantType? fromKey(String? key) =>
      key == null ? null : PlantType.values.where((t) => t.name == key).firstOrNull;
}
