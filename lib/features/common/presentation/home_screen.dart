import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../settings/presentation/cubit/language_cubit.dart';
import '../../towers/presentation/screens/list_view_screen.dart';
import '../../towers/presentation/screens/map_view_screen.dart';
import '../../settings/presentation/screens/settings_screen.dart';
import '../../../core/localization/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  late final List<Widget> _screens;
  
  @override
  void initState() {
    super.initState();
    _screens = [
      const MapViewScreen(),
      const ListViewScreen(),
      const SettingsScreen(),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, languageCode) {
        final localizations = AppLocalizations(languageCode);
        
        return Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.map),
                label: localizations.map,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.list),
                label: localizations.list,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: localizations.settings,
              ),
            ],
          ),
        );
      },
    );
  }
}
