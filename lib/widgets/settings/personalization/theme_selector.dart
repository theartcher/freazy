import 'package:flutter/material.dart';
import 'package:freazy/widgets/settings/pressable_setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeSelector extends StatefulWidget {
  final ThemeMode selectedTheme;
  final Function(ThemeMode) selectTheme;

  const ThemeSelector({
    super.key,
    required this.selectedTheme,
    required this.selectTheme,
  });

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context)!;

    return PressableSettingTile(
      title: localization.settingsPage_personalizationSection_themeTitle,
      description:
          localization.settingsPage_personalizationSection_themeDescription,
      trailing: DropdownMenu(
        menuStyle: const MenuStyle(),
        initialSelection: widget.selectedTheme,
        inputDecorationTheme: InputDecorationTheme(
          iconColor: theme.colorScheme.primary,
          focusColor: theme.colorScheme.primary,
        ),
        dropdownMenuEntries: <DropdownMenuEntry>[
          DropdownMenuEntry(
            value: ThemeMode.dark,
            label: localization.settingsPage_personalizationSection_themeDark,
          ),
          DropdownMenuEntry(
            value: ThemeMode.light,
            label: localization.settingsPage_personalizationSection_themeLight,
          ),
          DropdownMenuEntry(
            value: ThemeMode.system,
            label: localization.settingsPage_personalizationSection_themeSystem,
          )
        ],
        onSelected: (value) => widget.selectTheme(value),
      ),
    );
  }
}
