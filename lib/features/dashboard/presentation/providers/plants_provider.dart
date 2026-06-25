import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/plant_remote_datasource.dart';
import '../../data/repositories/plant_repository_impl.dart';
import '../../domain/entities/plant_summary.dart';
import '../../domain/repositories/i_plant_repository.dart';
import '../../domain/usecases/watch_plants_usecase.dart';

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
