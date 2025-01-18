import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:freazy/constants/routes.dart';
import 'package:freazy/stores/item-store.dart';
import 'package:freazy/utils/notification_helper.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  print("callback dispatcher called");
  Workmanager().executeTask((task, inputData) {
    print("Executing task: $task");
    return NotificationHelper().sendNotifications();
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//TODO: Check if the app icon set as NULL will work in sending notifications
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
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
      debug: true);

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  // Workmanager().registerOneOffTask(
  //   "check-for-notifications",
  //   "notificationCheck",
  // );

  // Workmanager().registerPeriodicTask(
  //   "check-for-notifications",
  //   "notificationCheck",
  //   frequency: const Duration(days: 1),
  //   backoffPolicy: BackoffPolicy.exponential,
  //   backoffPolicyDelay: const Duration(hours: 1),
  // );

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
