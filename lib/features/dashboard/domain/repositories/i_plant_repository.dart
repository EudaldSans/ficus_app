import '../entities/plant_summary.dart';

abstract class IPlantRepository {
  Future<List<PlantSummary>> fetchPlants();
  Future<void> savePlantName(String macAddress, String name);
}
