import 'package:cloud_firestore/cloud_firestore.dart';

class PlantFirestoreDatasource {
  final FirebaseFirestore _firestore;

  PlantFirestoreDatasource(this._firestore);

  Future<Map<String, Map<String, dynamic>>> fetchAllPlantMeta() async {
    final snapshot = await _firestore.collection('sensor_history').get();
    return {for (final doc in snapshot.docs) doc.id: doc.data()};
  }

  Future<String?> getPlantType(String macAddress) async {
    final doc =
        await _firestore.collection('sensor_history').doc(macAddress).get();
    return doc.data()?['type'] as String?;
  }

  Future<void> savePlantName(String macAddress, String name) {
    final dynamic value = name.isEmpty ? FieldValue.delete() : name;
    return _firestore
        .collection('sensor_history')
        .doc(macAddress)
        .set({'name': value}, SetOptions(merge: true));
  }

  Future<void> savePlantType(String macAddress, String? typeKey) {
    final dynamic value = typeKey ?? FieldValue.delete();
    return _firestore
        .collection('sensor_history')
        .doc(macAddress)
        .set({'type': value}, SetOptions(merge: true));
  }
}
