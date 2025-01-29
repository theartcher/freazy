import 'package:flutter/material.dart';
import 'package:freazy/widgets/settings/pressable_setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  static const _enLocaleKey = "en";
  static const _nlLocaleKey = "nl";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context)!;

    return PressableSettingTile(
      title: localization.settingsPage_personalizationSection_localeTitle,
      description:
          localization.settingsPage_personalizationSection_localeDescription,
      trailing: DropdownMenu(
        menuStyle: const MenuStyle(),
        initialSelection: widget.selectedLocale,
        inputDecorationTheme: InputDecorationTheme(
          iconColor: theme.colorScheme.primary,
          focusColor: theme.colorScheme.primary,
        ),
        dropdownMenuEntries: <DropdownMenuEntry>[
          DropdownMenuEntry(
            value: const Locale(_nlLocaleKey),
            label: localization.settingsPage_personalizationSection_localeNL,
          ),
          DropdownMenuEntry(
            value: const Locale(_enLocaleKey),
            label: localization.settingsPage_personalizationSection_localeEN,
          ),
        ],
        onSelected: (value) => widget.selectLocale(value),
      ),
    );
  }
}
