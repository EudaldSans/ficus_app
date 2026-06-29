import '../../domain/entities/plant_summary.dart';
import '../../domain/repositories/i_plant_repository.dart';
import '../datasources/plant_firestore_datasource.dart';
import '../datasources/plant_remote_datasource.dart';
import '../models/plant_summary_model.dart';

class PlantRepositoryImpl implements IPlantRepository {
  final PlantRemoteDatasource _remote;
  final PlantFirestoreDatasource _firestore;

  PlantRepositoryImpl(this._remote, this._firestore);

  @override
  Future<List<PlantSummary>> fetchPlants() async {
    final plantsFuture = _remote.fetchPlants();
    final metaFuture = _firestore.fetchAllPlantMeta();
    final plants = await plantsFuture;
    final meta = await metaFuture;
    return plants.map((p) {
      final plantMeta = meta[p.macAddress];
      return PlantSummaryModel(
        macAddress: p.macAddress,
        name: plantMeta?['name'] as String?,
        temperature: p.temperature,
        soilMoisture: p.soilMoisture,
        lastUpdated: p.lastUpdated,
      );
    }).toList();
  }

  @override
  Future<void> savePlantName(String macAddress, String name) =>
      _firestore.savePlantName(macAddress, name);

  @override
  Future<void> savePlantType(String macAddress, String? typeKey) =>
      _firestore.savePlantType(macAddress, typeKey);

  @override
  Future<String?> getPlantType(String macAddress) =>
      _firestore.getPlantType(macAddress);
}
