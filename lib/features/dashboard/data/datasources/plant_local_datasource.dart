import 'package:shared_preferences/shared_preferences.dart';

class PlantLocalDatasource {
  final SharedPreferences _prefs;

  const PlantLocalDatasource(this._prefs);

  static const _typePrefix = 'plant_type_';

  Future<void> savePlantType(String macAddress, String? typeKey) async {
    final key = '$_typePrefix$macAddress';
    if (typeKey == null) {
      await _prefs.remove(key);
    } else {
      await _prefs.setString(key, typeKey);
    }
  }

  String? getPlantType(String macAddress) =>
      _prefs.getString('$_typePrefix$macAddress');
}
