import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';

class SettingsState extends Equatable {
  final bool notificationsEnabled;
  final bool backgroundUpdatesEnabled;
  
  const SettingsState({
    required this.notificationsEnabled,
    required this.backgroundUpdatesEnabled,
  });
  
  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? backgroundUpdatesEnabled,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      backgroundUpdatesEnabled: backgroundUpdatesEnabled ?? this.backgroundUpdatesEnabled,
    );
  }
  
  @override
  List<Object> get props => [notificationsEnabled, backgroundUpdatesEnabled];
}

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences prefs;
  
  SettingsCubit(this.prefs)
      : super(const SettingsState(
          notificationsEnabled: true,
          backgroundUpdatesEnabled: true,
        )) {
    _loadSettings();
  }
  
  void _loadSettings() {
    final notificationsEnabled =
        prefs.getBool(AppConstants.keyNotifications) ?? true;
    final backgroundUpdatesEnabled =
        prefs.getBool('background_updates') ?? true;
    
    emit(SettingsState(
      notificationsEnabled: notificationsEnabled,
      backgroundUpdatesEnabled: backgroundUpdatesEnabled,
    ));
  }
  
  Future<void> toggleNotifications(bool enabled) async {
    await prefs.setBool(AppConstants.keyNotifications, enabled);
    emit(state.copyWith(notificationsEnabled: enabled));
  }
  
  Future<void> toggleBackgroundUpdates(bool enabled) async {
    await prefs.setBool('background_updates', enabled);
    emit(state.copyWith(backgroundUpdatesEnabled: enabled));
  }
}
