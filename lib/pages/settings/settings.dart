import 'package:flutter/material.dart';
import 'package:freazy/widgets/settings/export-import/export_settings.dart';
import 'package:freazy/widgets/settings/personalization/personalization_setting.dart';
import 'package:freazy/widgets/settings/reminders/reminders-settings.dart';
import 'package:freazy/widgets/settings/reset_app.dart';
import 'package:freazy/widgets/settings/setting_header.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        scrolledUnderElevation: 0,
        title: Text(localization.settingsPage_header_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(true),
        ),
      ),
      body: ListView(
        children: [
          SettingHeader(
            text: localization.settingsPage_remindersSection_header,
          ),
          const ReminderSettings(),
          const Divider(),
          SettingHeader(
            text: localization.settingsPage_personalizationSection_header,
          ),
          const PersonalizationSetting(),
          const Divider(),
          SettingHeader(
            text: localization.settingsPage_exportImportSection_header,
          ),
          const ExportSettings(),
          const Divider(),
          const ResetAppSetting(),
        ],
      ),
    );
  }
}
