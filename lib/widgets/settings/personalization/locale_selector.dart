import 'package:flutter/material.dart';
import 'package:freazy/widgets/settings/pressable_setting.dart';

class LocaleSelector extends StatefulWidget {
  final Locale selectedLocale;
  final Function(Locale) selectLocale;

  const LocaleSelector({
    super.key,
    required this.selectedLocale,
    required this.selectLocale,
  });

  @override
  State<LocaleSelector> createState() => _LocaleSelectorState();
}

class _LocaleSelectorState extends State<LocaleSelector> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PressableSettingTile(
      title: "Taal",
      description: "Veranderd de taal van de app",
      trailing: DropdownMenu(
        menuStyle: const MenuStyle(),
        initialSelection: widget.selectedLocale,
        inputDecorationTheme: InputDecorationTheme(
          iconColor: theme.colorScheme.primary,
          focusColor: theme.colorScheme.primary,
        ),
        dropdownMenuEntries: const <DropdownMenuEntry>[
          DropdownMenuEntry(value: Locale('nl'), label: "Nederlands"),
          DropdownMenuEntry(value: Locale('en'), label: "English"),
        ],
        onSelected: (value) => widget.selectLocale(value),
      ),
    );
  }
}
