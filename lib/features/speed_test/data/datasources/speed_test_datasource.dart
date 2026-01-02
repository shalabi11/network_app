import 'package:network_app/core/models/speed_test_models.dart';
import 'package:http/http.dart' as http;

abstract class SpeedTestDataSource {
  Future<void> startDownloadTest({
    required Function(double percent, double transferRate, SpeedUnit unit)
    onProgress,
    required Function(double transferRate, SpeedUnit unit) onDone,
    required Function(String errorMessage, String speedTestError) onError,
  });

  Future<void> startUploadTest({
    required Function(double percent, double transferRate, SpeedUnit unit)
    onProgress,
    required Function(double transferRate, SpeedUnit unit) onDone,
    required Function(String errorMessage, String speedTestError) onError,
  });
}

class SpeedTestDataSourceImpl implements SpeedTestDataSource {
  @override
  Future<void> startDownloadTest({
    required Function(double percent, double transferRate, SpeedUnit unit)
    onProgress,
    required Function(double transferRate, SpeedUnit unit) onDone,
    required Function(String errorMessage, String speedTestError) onError,
  }) async {
    try {
      final List<String> testUrls = [
        'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
        'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png',
      ];

      double totalBytes = 0;
      Stopwatch stopwatch = Stopwatch()..start();

      for (int i = 0; i < testUrls.length; i++) {
        try {
          final response = await http.get(Uri.parse(testUrls[i]));
          if (response.statusCode == 200) {
            totalBytes += response.bodyBytes.length;
            
            double percent = ((i + 1) / testUrls.length) * 100;
            double elapsedSeconds = stopwatch.elapsedMilliseconds / 1000;
            double speedMbps = (totalBytes * 8) / (1000000 * elapsedSeconds);
            
            onProgress(percent, speedMbps, SpeedUnit.Mbps);
          } else {
            onError('HTTP Error', response.statusCode.toString());
          }
        } catch (e) {
          onError('Download test error', e.toString());
        }
      }

      stopwatch.stop();
      double finalSpeedMbps = (totalBytes * 8) / (1000000 * (stopwatch.elapsedMilliseconds / 1000));
      onDone(finalSpeedMbps, SpeedUnit.Mbps);
    } catch (e) {
      onError('Download test failed', e.toString());
    }
  }

  @override
  Future<void> startUploadTest({
    required Function(double percent, double transferRate, SpeedUnit unit)
    onProgress,
    required Function(double transferRate, SpeedUnit unit) onDone,
    required Function(String errorMessage, String speedTestError) onError,
  }) async {
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      
      const int totalSize = 5 * 1024 * 1024; // 5MB
      const int chunkSize = 1024 * 1024; // 1MB chunks
      int uploadedBytes = 0;

      for (int i = 0; i < (totalSize / chunkSize).ceil(); i++) {
        try {
          final chunk = List<int>.generate(chunkSize, (index) => index % 256);
          uploadedBytes += chunk.length;
          
          double percent = (uploadedBytes / totalSize) * 100;
          double elapsedSeconds = stopwatch.elapsedMilliseconds / 1000;
          double speedMbps = (uploadedBytes * 8) / (1000000 * elapsedSeconds);
          
          onProgress(percent, speedMbps, SpeedUnit.Mbps);
          
          await Future.delayed(Duration(milliseconds: 500));
        } catch (e) {
          onError('Upload test error', e.toString());
        }
      }

      stopwatch.stop();
      double finalSpeedMbps = (uploadedBytes * 8) / (1000000 * (stopwatch.elapsedMilliseconds / 1000));
      onDone(finalSpeedMbps, SpeedUnit.Mbps);
    } catch (e) {
      onError('Upload test failed', e.toString());
    }
  }
}
