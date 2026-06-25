import '../entities/plant_reading.dart';
import '../repositories/i_plant_readings_repository.dart';

class WatchPlantReadingsUseCase {
  final IPlantReadingsRepository _repository;

  WatchPlantReadingsUseCase(this._repository);

  Future<List<PlantReading>> call(String macAddress) =>
      _repository.fetchPlantReadings(macAddress);
}
