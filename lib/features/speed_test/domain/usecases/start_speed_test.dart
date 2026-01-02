import 'package:network_app/features/speed_test/domain/entities/speed_test_result.dart';
import 'package:network_app/features/speed_test/domain/repositories/speed_test_repository.dart';

class StartSpeedTest {
  final SpeedTestRepository repository;

  StartSpeedTest(this.repository);

  Stream<SpeedTestResult> call() {
    return repository.startSpeedTest();
  }
}
