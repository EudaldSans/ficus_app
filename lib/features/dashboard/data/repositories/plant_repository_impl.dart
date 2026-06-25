import '../../domain/entities/plant_summary.dart';
import '../../domain/repositories/i_plant_repository.dart';
import '../datasources/plant_remote_datasource.dart';

class PlantRepositoryImpl implements IPlantRepository {
  final PlantRemoteDatasource _datasource;

  PlantRepositoryImpl(this._datasource);

  @override
  Future<List<PlantSummary>> fetchPlants() => _datasource.fetchPlants();
}
