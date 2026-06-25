import '../entities/plant_reading.dart';

abstract class IPlantReadingsRepository {
  Future<List<PlantReading>> fetchPlantReadings(String macAddress);
}
