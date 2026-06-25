import 'package:firebase_database/firebase_database.dart';
import '../models/plant_summary_model.dart';

class PlantRemoteDatasource {
  final FirebaseDatabase _database;

  PlantRemoteDatasource(this._database);

  Future<List<PlantSummaryModel>> fetchPlants() async {
    final snapshot = await _database.ref('plant_data').get();
    final raw = snapshot.value;
    if (raw == null) return [];

    final map = _toStringMap(raw as Map);
    return map.entries
        .map((e) => PlantSummaryModel.fromFirebase(e.key, _toStringMap(e.value as Map)))
        .toList();
  }

  static Map<String, dynamic> _toStringMap(Map source) =>
      Map.fromEntries(source.entries.map((e) => MapEntry(e.key.toString(), e.value)));
}
