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
    StreamProvider.family<List<PlantReading>, String>((ref, macAddress) async* {
  final useCase = ref.watch(watchPlantReadingsUseCaseProvider);
  while (true) {
    yield await useCase(macAddress);
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, now.hour, 1);
    if (!next.isAfter(now)) next = next.add(const Duration(hours: 1));
    await Future.delayed(next.difference(now));
  }
});
