import 'package:equatable/equatable.dart';

abstract class SpeedTestEvent extends Equatable {
  const SpeedTestEvent();

  @override
  List<Object> get props => [];
}

class SpeedTestStarted extends SpeedTestEvent {}
