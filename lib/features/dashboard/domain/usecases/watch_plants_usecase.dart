import '../entities/plant_summary.dart';
import '../repositories/i_plant_repository.dart';

class WatchPlantsUseCase {
  final IPlantRepository _repository;

  WatchPlantsUseCase(this._repository);

  Future<List<PlantSummary>> call() => _repository.fetchPlants();
}
