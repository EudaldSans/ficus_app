import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/plant_readings_datasource.dart';
import '../../data/repositories/plant_readings_repository_impl.dart';
import '../../domain/entities/plant_reading.dart';
import '../../domain/repositories/i_plant_readings_repository.dart';
import '../../domain/usecases/watch_plant_readings_usecase.dart';

final plantReadingsDatasourceProvider = Provider<PlantReadingsDatasource>((ref) {
  return PlantReadingsDatasource(FirebaseDatabase.instance);
});

final plantReadingsRepositoryProvider =
    Provider<IPlantReadingsRepository>((ref) {
  return PlantReadingsRepositoryImpl(
    ref.watch(plantReadingsDatasourceProvider),
  );
});

final watchPlantReadingsUseCaseProvider =
    Provider<WatchPlantReadingsUseCase>((ref) {
  return WatchPlantReadingsUseCase(ref.watch(plantReadingsRepositoryProvider));
});

final plantReadingsProvider =
    FutureProvider.family<List<PlantReading>, String>((ref, macAddress) {
  return ref.watch(watchPlantReadingsUseCaseProvider)(macAddress);
});
