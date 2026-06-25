import '../entities/plant_summary.dart';

abstract class IPlantRepository {
  Future<List<PlantSummary>> fetchPlants();
}
