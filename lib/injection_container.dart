import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_constants.dart';
import 'core/network/mock_interceptor.dart';
import 'core/utils/logger.dart';
import 'core/network/network_info.dart';
import 'features/settings/presentation/cubit/language_cubit.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/settings/presentation/cubit/theme_cubit.dart';
import 'features/towers/data/datasources/tower_local_data_source.dart';
import 'features/towers/data/datasources/tower_remote_data_source.dart';
import 'features/towers/data/repositories/tower_repository_impl.dart';
import 'features/towers/domain/repositories/tower_repository.dart';
import 'features/towers/domain/usecases/get_nearby_towers.dart';
import 'features/towers/domain/usecases/ping_tower.dart';
import 'features/towers/presentation/bloc/tower_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============== Features ==============

  // Bloc
  sl.registerFactory(
    () => TowerBloc(
      getNearbyTowers: sl(),
      pingTower: sl(),
      towerRepository: sl(),
    ),
  );

  // Cubit
  sl.registerLazySingleton(() => ThemeCubit(sl()));
  sl.registerLazySingleton(() => LanguageCubit(sl()));
  sl.registerLazySingleton(() => SettingsCubit(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetNearbyTowers(sl()));
  sl.registerLazySingleton(() => PingTower(sl()));

  // Repository
  sl.registerLazySingleton<TowerRepository>(
    () => TowerRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TowerRemoteDataSource>(
    () => TowerRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<TowerLocalDataSource>(
    () => TowerLocalDataSourceImpl(),
  );

  // ============== Core ==============

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // ============== External ==============

  // Dio
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add mock interceptor only in development mode
    if (AppConstants.useMockData) {
      dio.interceptors.add(MockInterceptor());
    }

    // Add logging interceptor in debug mode
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => AppLogger.debug(obj.toString()),
      ),
    );

    return dio;
  });

  // Connectivity
  sl.registerLazySingleton(() => Connectivity());

  // Shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
