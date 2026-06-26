import 'plant_type.dart';

enum PlantHealthStatus {
  healthy,
  overwatered,
  needsWatering,
  tempTooHigh,
  tempTooLow,
  unknown;

  // Priority: overwatered > dry > heat > cold > healthy
  static PlantHealthStatus compute({
    required PlantType? plantType,
    required double? humidity,
    required double? temperature,
  }) {
    if (plantType == null) return unknown;

    if (humidity != null && humidity > plantType.humidityOverwatered) {
      return overwatered;
    }
    if (humidity != null && humidity < plantType.humidityDry) {
      return needsWatering;
    }
    if (temperature != null && temperature > plantType.tempCriticalHigh) {
      return tempTooHigh;
    }
    if (temperature != null && temperature < plantType.tempCriticalLow) {
      return tempTooLow;
    }
    return healthy;
  }
}
