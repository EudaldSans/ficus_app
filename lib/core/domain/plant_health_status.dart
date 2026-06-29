import 'plant_type.dart';

enum PlantHealthStatus {
  healthy,
  overwatered,
  needsWatering,
  tempTooHigh,
  tempTooLow,
  unknown;

  static List<PlantHealthStatus> compute({
    required PlantType? plantType,
    required double? soilMoisture,
    required double? temperature,
  }) {
    if (plantType == null) return const [];

    final statuses = <PlantHealthStatus>[];

    if (soilMoisture != null && soilMoisture > plantType.soilMoistureOverwatered) {
      statuses.add(overwatered);
    }
    if (soilMoisture != null && soilMoisture < plantType.soilMoistureDry) {
      statuses.add(needsWatering);
    }
    if (temperature != null && temperature > plantType.tempCriticalHigh) {
      statuses.add(tempTooHigh);
    }
    if (temperature != null && temperature < plantType.tempCriticalLow) {
      statuses.add(tempTooLow);
    }

    return statuses.isEmpty ? const [healthy] : statuses;
  }
}
