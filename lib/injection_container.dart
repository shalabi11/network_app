import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_constants.dart';
import 'core/network/mock_interceptor.dart';
import 'core/network/retry_interceptor.dart';
import 'core/services/cache_service.dart';
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
import 'features/speed_test/data/datasources/speed_test_datasource.dart';
import 'features/speed_test/data/repositories/speed_test_repository_impl.dart';
import 'features/speed_test/domain/repositories/speed_test_repository.dart';
import 'features/speed_test/domain/usecases/start_speed_test.dart';
import 'features/speed_test/presentation/bloc/speed_test_bloc.dart';

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
  sl.registerFactory(() => SpeedTestBloc(startSpeedTest: sl()));

  // Cubit
  sl.registerLazySingleton(() => ThemeCubit(sl()));
  sl.registerLazySingleton(() => LanguageCubit(sl()));
  sl.registerLazySingleton(() => SettingsCubit(sl()));

  // Use cases
  sl.registerLazySingleton(() => GetNearbyTowers(sl()));
  sl.registerLazySingleton(() => PingTower(sl()));
  sl.registerLazySingleton(() => StartSpeedTest(sl()));

  // Repository
  sl.registerLazySingleton<TowerRepository>(
    () => TowerRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<SpeedTestRepository>(
    () => SpeedTestRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TowerRemoteDataSource>(
    () => TowerRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<TowerLocalDataSource>(
    () => TowerLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<SpeedTestDataSource>(
    () => SpeedTestDataSourceImpl(),
  );

  // ============== Core ==============

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  
  // Cache service
  sl.registerLazySingleton(() => CacheService(sl()));

  // ============== External ==============

  // Dio
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
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
    
    // Add retry interceptor for better reliability
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: kDebugMode ? (message) => AppLogger.debug(message) : null,
      ),
    );

    // LogInterceptor is disabled to improve performance
    // Enable it only if you need detailed HTTP logging for debugging
    // if (kDebugMode) {
    //   dio.interceptors.add(
    //     LogInterceptor(
    //       requestBody: false,
    //       responseBody: false,
    //       error: true,
    //       logPrint: (obj) {
    //         final message = obj?.toString() ?? '';
    //         if (message.isNotEmpty) {
    //           AppLogger.debug(message);
    //         }
    //       },
    //     ),
    //   );
    // }

    return dio;
  });

  // Connectivity
  sl.registerLazySingleton(() => Connectivity());

  // Shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
