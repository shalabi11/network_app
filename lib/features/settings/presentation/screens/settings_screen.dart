import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/app_localizations.dart';
import '../cubit/language_cubit.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/theme_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageCode = context.watch<LanguageCubit>().state;
    final localizations = AppLocalizations(languageCode);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settingsTitle)),
      body: ListView(
        children: [
          _buildSectionHeader(localizations.themeSettings, context),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text(localizations.lightTheme),
                    subtitle: const Text('Light mode'),
                    value: ThemeMode.light,
                    groupValue: themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<ThemeCubit>().changeTheme(value);
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(localizations.darkTheme),
                    subtitle: const Text('Dark mode'),
                    value: ThemeMode.dark,
                    groupValue: themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<ThemeCubit>().changeTheme(value);
                      }
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(localizations.systemTheme),
                    subtitle: const Text('Follow system settings'),
                    value: ThemeMode.system,
                    groupValue: themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<ThemeCubit>().changeTheme(value);
                      }
                    },
                  ),
                ],
              );
            },
          ),
          const Divider(),
          _buildSectionHeader(localizations.languageSettings, context),
          BlocBuilder<LanguageCubit, String>(
            builder: (context, currentLanguage) {
              return Column(
                children: [
                  RadioListTile<String>(
                    title: Text(localizations.english),
                    subtitle: const Text('English'),
                    value: 'en',
                    groupValue: currentLanguage,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<LanguageCubit>().changeLanguage(value);
                      }
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(localizations.arabic),
                    subtitle: const Text('العربية'),
                    value: 'ar',
                    groupValue: currentLanguage,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<LanguageCubit>().changeLanguage(value);
                      }
                    },
                  ),
                ],
              );
            },
          ),
          const Divider(),
          _buildSectionHeader(localizations.notificationSettings, context),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return Column(
                children: [
                  SwitchListTile(
                    title: Text(localizations.enableNotifications),
                    subtitle: const Text('Receive app notifications'),
                    value: state.notificationsEnabled,
                    onChanged: (value) {
                      context.read<SettingsCubit>().toggleNotifications(value);
                    },
                  ),
                  SwitchListTile(
                    title: Text(localizations.backgroundUpdates),
                    subtitle: const Text(
                      'Enable background network monitoring',
                    ),
                    value: state.backgroundUpdatesEnabled,
                    onChanged: (value) {
                      context.read<SettingsCubit>().toggleBackgroundUpdates(
                        value,
                      );
                    },
                  ),
                ],
              );
            },
          ),
          const Divider(),
          _buildSectionHeader(localizations.about, context),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(localizations.version),
            subtitle: Text(AppConstants.appVersion),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(localizations.privacyPolicy),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to privacy policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(localizations.termsOfService),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to terms of service
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
