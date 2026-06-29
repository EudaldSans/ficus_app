import 'package:firebase_database/firebase_database.dart';
import '../models/plant_summary_model.dart';

class PlantRemoteDatasource {
  final FirebaseDatabase _database;

  PlantRemoteDatasource(this._database);

  Future<List<PlantSummaryModel>> fetchPlants() async {
    final snapshot = await _database.ref('plants').get();
    final raw = snapshot.value;
    if (raw == null) return [];

    final map = _toStringMap(raw as Map);
    return map.entries
        .map((e) => PlantSummaryModel.fromFirebase(e.key, _toStringMap(e.value as Map)))
        .toList();
  }

  Future<void> savePlantName(String macAddress, String name) {
    final ref = _database.ref('plants/$macAddress/name');
    return name.isEmpty ? ref.remove() : ref.set(name);
  }

  static Map<String, dynamic> _toStringMap(Map source) =>
      Map.fromEntries(source.entries.map((e) => MapEntry(e.key.toString(), e.value)));
}
