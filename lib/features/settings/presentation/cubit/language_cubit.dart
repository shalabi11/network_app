import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';

class LanguageCubit extends Cubit<String> {
  final SharedPreferences prefs;
  
  LanguageCubit(this.prefs) : super('en') {
    _loadLanguage();
  }
  
  void _loadLanguage() {
    final languageCode = prefs.getString(AppConstants.keyLanguage) ?? 'en';
    emit(languageCode);
  }
  
  Future<void> changeLanguage(String languageCode) async {
    await prefs.setString(AppConstants.keyLanguage, languageCode);
    emit(languageCode);
  }
  
  bool get isEnglish => state == 'en';
  bool get isArabic => state == 'ar';
}
