import 'dart:async';
import 'package:network_app/core/models/speed_test_models.dart';
import 'package:network_app/features/speed_test/data/datasources/speed_test_datasource.dart';
import 'package:network_app/features/speed_test/domain/entities/speed_test_result.dart';
import 'package:network_app/features/speed_test/domain/repositories/speed_test_repository.dart';

class SpeedTestRepositoryImpl implements SpeedTestRepository {
  final SpeedTestDataSource dataSource;

  SpeedTestRepositoryImpl({required this.dataSource});

  @override
  Stream<SpeedTestResult> startSpeedTest() {
    final controller = StreamController<SpeedTestResult>();
    SpeedTestResult currentResult = const SpeedTestResult(isDownloading: true);
    controller.add(currentResult);

    dataSource.startDownloadTest(
      onProgress: (percent, transferRate, unit) {
        double speedInMbps = transferRate;
        if (unit == SpeedUnit.Kbps) {
          speedInMbps = transferRate / 1000;
        }

        currentResult = currentResult.copyWith(
          downloadSpeed: speedInMbps,
          isDownloading: true,
        );
        controller.add(currentResult);
      },
      onDone: (transferRate, unit) {
        double speedInMbps = transferRate;
        if (unit == SpeedUnit.Kbps) {
          speedInMbps = transferRate / 1000;
        }

        currentResult = currentResult.copyWith(
          downloadSpeed: speedInMbps,
          isDownloading: false,
          isUploading: true,
        );
        controller.add(currentResult);

        // Start Upload Test
        dataSource.startUploadTest(
          onProgress: (percent, transferRate, unit) {
            double speedInMbps = transferRate;
            if (unit == SpeedUnit.Kbps) {
              speedInMbps = transferRate / 1000;
            }

            currentResult = currentResult.copyWith(
              uploadSpeed: speedInMbps,
              isUploading: true,
            );
            controller.add(currentResult);
          },
          onDone: (transferRate, unit) {
            double speedInMbps = transferRate;
            if (unit == SpeedUnit.Kbps) {
              speedInMbps = transferRate / 1000;
            }

            currentResult = currentResult.copyWith(
              uploadSpeed: speedInMbps,
              isUploading: false,
              isDone: true,
            );
            controller.add(currentResult);
            controller.close();
          },
          onError: (errorMessage, speedTestError) {
            currentResult = currentResult.copyWith(
              error: errorMessage,
              isUploading: false,
              isDone: true,
            );
            controller.add(currentResult);
            controller.close();
          },
        );
      },
      onError: (errorMessage, speedTestError) {
        currentResult = currentResult.copyWith(
          error: errorMessage,
          isDownloading: false,
          isDone: true,
        );
        controller.add(currentResult);
        controller.close();
      },
    );

    return controller.stream;
  }
}
