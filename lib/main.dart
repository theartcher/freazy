import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:freazy/constants/routes.dart';
import 'package:freazy/constants/themes.dart';
import 'package:freazy/stores/item-store.dart';
import 'package:freazy/utils/background_manager.dart';
import 'package:freazy/utils/notification_helper.dart';
import 'package:freazy/utils/settings/preferences_manager.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    if (task == BackgroundManager.reminderBackgroundTaskName) {
      return NotificationHelper().sendNotifications();
    }

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: appPrimary,
        ledColor: appPrimary,
      )
    ],
    debug: true,
  );

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  BackgroundManager.scheduleReminder(
      policyOnExistingSchedule: ExistingWorkPolicy.keep);

  ThemeMode themeMode = await PreferencesManager.loadThemeMode();
  Locale locale = await PreferencesManager.loadLocale();

  runApp(ChangeNotifierProvider(
    create: (context) => FrozenItemStore(),
    child: MainApp(
      initialTheme: themeMode,
      initialLocale: locale,
    ),
  ));
}

class MainApp extends StatefulWidget {
  final ThemeMode initialTheme;
  final Locale initialLocale;

  const MainApp({
    super.key,
    required this.initialTheme,
    required this.initialLocale,
  });

  @override
  State<MainApp> createState() => _MainAppState();

  static _MainAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MainAppState>()!;
}

class _MainAppState extends State<MainApp> {
  late ThemeMode selectedTheme;
  late Locale selectedLocale;

  @override
  void initState() {
    super.initState();
    selectedTheme = widget.initialTheme;
    selectedLocale = widget.initialLocale;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: selectedLocale,
      themeMode: selectedTheme,
      theme: lightMode,
      darkTheme: darkMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English US
        Locale('nl'), // Dutch
      ],
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      selectedTheme = themeMode;
    });
  }

  void changeLocale(Locale locale) {
    setState(() {
      selectedLocale = locale;
    });
  }
}
