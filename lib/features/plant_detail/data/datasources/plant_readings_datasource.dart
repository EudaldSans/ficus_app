import 'package:firebase_database/firebase_database.dart';
import '../models/plant_reading_model.dart';

class PlantReadingsDatasource {
  final FirebaseDatabase _database;

  PlantReadingsDatasource(this._database);

  Future<List<PlantReadingModel>> fetchPlantReadings(String macAddress) async {
    final snapshot = await _database.ref('plants/$macAddress').get();
    final raw = snapshot.value;
    if (raw == null) return [];

    final map = _toStringMap(raw as Map);
    return map.entries
        .where((e) => int.tryParse(e.key) != null) // skip non-timestamp keys like 'name'
        .map((e) => PlantReadingModel.fromFirebase(e.key, _toStringMap(e.value as Map)))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  static Map<String, dynamic> _toStringMap(Map source) =>
      Map.fromEntries(source.entries.map((e) => MapEntry(e.key.toString(), e.value)));
}
