import 'package:equatable/equatable.dart';
import 'package:network_app/features/speed_test/domain/entities/speed_test_result.dart';

abstract class SpeedTestState extends Equatable {
  const SpeedTestState();

  @override
  List<Object?> get props => [];
}

class SpeedTestInitial extends SpeedTestState {}

class SpeedTestRunInProgress extends SpeedTestState {
  final SpeedTestResult result;

  const SpeedTestRunInProgress(this.result);

  @override
  List<Object?> get props => [result];
}

class SpeedTestRunComplete extends SpeedTestState {
  final SpeedTestResult result;

  const SpeedTestRunComplete(this.result);

  @override
  List<Object?> get props => [result];
}

class SpeedTestRunFailure extends SpeedTestState {
  final String message;

  const SpeedTestRunFailure(this.message);

  @override
  List<Object?> get props => [message];
}
