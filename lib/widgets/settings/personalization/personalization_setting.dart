import 'package:flutter/material.dart';
import 'package:freazy/main.dart';
import 'package:freazy/utils/settings/preferences_manager.dart';
import 'package:freazy/widgets/settings/personalization/locale_selector.dart';
import 'package:freazy/widgets/settings/personalization/theme_selector.dart';

class PersonalizationSetting extends StatefulWidget {
  const PersonalizationSetting({super.key});

  @override
  State<PersonalizationSetting> createState() => _PersonalizationSettingState();
}

class _PersonalizationSettingState extends State<PersonalizationSetting> {
  ThemeMode theme = ThemeMode.system;
  Locale locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _loadInitialSettings();
  }

  Future<void> _loadInitialSettings() async {
    ThemeMode selectedTheme = await PreferencesManager.loadThemeMode();
    Locale selectedLocale = await PreferencesManager.loadLocale();

    setState(() {
      theme = selectedTheme;
      locale = selectedLocale;
    });
  }

  void selectTheme(ThemeMode selectedTheme) {
    PreferencesManager.saveThemeMode(selectedTheme);
    MainApp.of(context).changeTheme(selectedTheme);

    setState(() {
      theme = selectedTheme;
    });
  }

  void selectLocale(Locale selectedLocale) {
    PreferencesManager.setLocale(selectedLocale);
    MainApp.of(context).changeLocale(selectedLocale);

    setState(() {
      locale = selectedLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: UniqueKey(),
      children: [
        ThemeSelector(
          selectTheme: selectTheme,
          selectedTheme: theme,
        ),
        LocaleSelector(
          selectLocale: selectLocale,
          selectedLocale: locale,
        )
      ],
    );
  }
}
