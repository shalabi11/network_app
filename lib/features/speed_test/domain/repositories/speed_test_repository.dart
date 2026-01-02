import 'package:network_app/features/speed_test/domain/entities/speed_test_result.dart';

abstract class SpeedTestRepository {
  Stream<SpeedTestResult> startSpeedTest();
}
