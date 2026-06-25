import '../../domain/entities/plant_reading.dart';
import '../../domain/repositories/i_plant_readings_repository.dart';
import '../datasources/plant_readings_datasource.dart';

class PlantReadingsRepositoryImpl implements IPlantReadingsRepository {
  final PlantReadingsDatasource _datasource;

  PlantReadingsRepositoryImpl(this._datasource);

  @override
  Future<List<PlantReading>> fetchPlantReadings(String macAddress) =>
      _datasource.fetchPlantReadings(macAddress);
}
