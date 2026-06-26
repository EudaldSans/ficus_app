import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/domain/plant_type.dart';
import '../../data/datasources/plant_local_datasource.dart';
import '../../data/datasources/plant_remote_datasource.dart';
import '../../data/repositories/plant_repository_impl.dart';
import '../../domain/entities/plant_summary.dart';
import '../../domain/repositories/i_plant_repository.dart';
import '../../domain/usecases/watch_plants_usecase.dart';

// Overridden in main.dart after SharedPreferences.getInstance()
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main.dart');
});

final plantLocalDatasourceProvider = Provider<PlantLocalDatasource>((ref) {
  return PlantLocalDatasource(ref.watch(sharedPreferencesProvider));
});

final plantRemoteDatasourceProvider = Provider<PlantRemoteDatasource>((ref) {
  return PlantRemoteDatasource(FirebaseDatabase.instance);
});

final plantRepositoryProvider = Provider<IPlantRepository>((ref) {
  return PlantRepositoryImpl(ref.watch(plantRemoteDatasourceProvider));
});

final watchPlantsUseCaseProvider = Provider<WatchPlantsUseCase>((ref) {
  return WatchPlantsUseCase(ref.watch(plantRepositoryProvider));
});

final plantsProvider = FutureProvider<List<PlantSummary>>((ref) {
  return ref.watch(watchPlantsUseCaseProvider)();
});

// ── Plant type (local, per-device) ───────────────────────────────────────────

class PlantTypeNotifier extends StateNotifier<PlantType?> {
  final PlantLocalDatasource _local;
  final String _mac;

  PlantTypeNotifier(this._local, this._mac)
      : super(PlantType.fromKey(_local.getPlantType(_mac)));

  Future<void> setType(PlantType? type) async {
    await _local.savePlantType(_mac, type?.name);
    state = type;
  }
}

final plantTypeProvider =
    StateNotifierProvider.family<PlantTypeNotifier, PlantType?, String>(
  (ref, mac) => PlantTypeNotifier(ref.watch(plantLocalDatasourceProvider), mac),
);
