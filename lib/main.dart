import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:freazy/constants/routes.dart';
import 'package:freazy/stores/item-store.dart';
import 'package:freazy/utils/background_manager.dart';
import 'package:freazy/utils/notification_helper.dart';
import 'package:freazy/utils/settings/preferences_manager.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

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
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white)
    ],
    debug: true,
  );

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  BackgroundManager.scheduleReminder(
      policyOnExistingSchedule: ExistingWorkPolicy.keep);

  runApp(ChangeNotifierProvider(
    create: (context) => FrozenItemStore(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0XFF1f00ff),
            brightness: Brightness.light,
          ),
        ));
  }
}
