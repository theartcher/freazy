import 'package:flutter/material.dart';
import 'package:freazy/constants/routes.dart';
import 'package:freazy/stores/item-store.dart';
import 'package:freazy/utils/notification_helper.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    return NotificationHelper().sendNotifications();
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  Workmanager().registerPeriodicTask(
    "check-for-notifications",
    "notificationCheck",
    frequency: const Duration(days: 1),
    backoffPolicy: BackoffPolicy.exponential,
    backoffPolicyDelay: const Duration(hours: 1),
  );

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
