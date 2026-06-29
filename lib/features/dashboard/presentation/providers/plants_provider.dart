import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/plant_type.dart';
import '../../data/datasources/plant_firestore_datasource.dart';
import '../../data/datasources/plant_remote_datasource.dart';
import '../../data/repositories/plant_repository_impl.dart';
import '../../domain/entities/plant_summary.dart';
import '../../domain/repositories/i_plant_repository.dart';
import '../../domain/usecases/watch_plants_usecase.dart';

final plantRemoteDatasourceProvider = Provider<PlantRemoteDatasource>((ref) {
  return PlantRemoteDatasource(FirebaseDatabase.instance);
});

final plantFirestoreDatasourceProvider = Provider<PlantFirestoreDatasource>((ref) {
  return PlantFirestoreDatasource(FirebaseFirestore.instance);
});

final plantRepositoryProvider = Provider<IPlantRepository>((ref) {
  return PlantRepositoryImpl(
    ref.watch(plantRemoteDatasourceProvider),
    ref.watch(plantFirestoreDatasourceProvider),
  );
});

final watchPlantsUseCaseProvider = Provider<WatchPlantsUseCase>((ref) {
  return WatchPlantsUseCase(ref.watch(plantRepositoryProvider));
});

final plantsProvider = StreamProvider<List<PlantSummary>>((ref) async* {
  final useCase = ref.watch(watchPlantsUseCaseProvider);
  while (true) {
    yield await useCase();
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, now.hour, 1);
    if (!next.isAfter(now)) next = next.add(const Duration(hours: 1));
    await Future.delayed(next.difference(now));
  }
});

// ── Plant type (Firestore, synced across devices) ─────────────────────────────

class PlantTypeNotifier extends StateNotifier<PlantType?> {
  final IPlantRepository _repo;
  final String _mac;

  PlantTypeNotifier(this._repo, this._mac) : super(null) {
    _load();
  }

  Future<void> _load() async {
    final typeKey = await _repo.getPlantType(_mac);
    if (mounted) state = PlantType.fromKey(typeKey);
  }

  Future<void> setType(PlantType? type) async {
    await _repo.savePlantType(_mac, type?.name);
    state = type;
  }
}

final plantTypeProvider =
    StateNotifierProvider.family<PlantTypeNotifier, PlantType?, String>(
  (ref, mac) => PlantTypeNotifier(ref.watch(plantRepositoryProvider), mac),
);
