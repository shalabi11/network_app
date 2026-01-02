import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_app/features/speed_test/domain/usecases/start_speed_test.dart';
import 'package:network_app/features/speed_test/presentation/bloc/speed_test_event.dart';
import 'package:network_app/features/speed_test/presentation/bloc/speed_test_state.dart';

class SpeedTestBloc extends Bloc<SpeedTestEvent, SpeedTestState> {
  final StartSpeedTest startSpeedTest;

  SpeedTestBloc({required this.startSpeedTest}) : super(SpeedTestInitial()) {
    on<SpeedTestStarted>(_onSpeedTestStarted);
  }

  Future<void> _onSpeedTestStarted(
    SpeedTestStarted event,
    Emitter<SpeedTestState> emit,
  ) async {
    await emit.forEach(
      startSpeedTest(),
      onData: (result) {
        if (result.error != null) {
          return SpeedTestRunFailure(result.error!);
        }
        if (result.isDone) {
          return SpeedTestRunComplete(result);
        }
        return SpeedTestRunInProgress(result);
      },
      onError: (error, stackTrace) => SpeedTestRunFailure(error.toString()),
    );
  }
}
