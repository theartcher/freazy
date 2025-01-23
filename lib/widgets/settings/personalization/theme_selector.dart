import 'package:flutter/material.dart';
import 'package:freazy/widgets/settings/pressable_setting.dart';

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

    return PressableSettingTile(
      title: "Thema selecteren",
      description: "Kies het thema van de app.",
      trailing: DropdownMenu(
        menuStyle: const MenuStyle(),
        initialSelection: widget.selectedTheme,
        inputDecorationTheme: InputDecorationTheme(
          iconColor: theme.colorScheme.primary,
          focusColor: theme.colorScheme.primary,
        ),
        dropdownMenuEntries: const <DropdownMenuEntry>[
          DropdownMenuEntry(value: ThemeMode.dark, label: "Dark"),
          DropdownMenuEntry(value: ThemeMode.light, label: "Light"),
          DropdownMenuEntry(value: ThemeMode.system, label: "System")
        ],
        onSelected: (value) => widget.selectTheme(value),
      ),
    );
  }
}
