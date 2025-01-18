import 'package:flutter/material.dart';
import 'package:freazy/pages/frozen_item/add-new.dart';
import 'package:freazy/pages/frozen_item/edit.dart';
import 'package:freazy/pages/settings/edit-reminders.dart';
import 'package:go_router/go_router.dart';
import 'package:freazy/constants/constants.dart';
import 'package:freazy/models/item.dart';
import 'package:freazy/pages/settings/settings.dart';
import 'package:freazy/pages/home.dart';

final GoRouter router = GoRouter(routes: <RouteBase>[
  GoRoute(
    path: ROUTE_HOME,
    builder: (BuildContext context, GoRouterState state) {
      return const HomePage();
    },
  ),
  GoRoute(
    path: ROUTE_SETTINGS,
    builder: (BuildContext context, GoRouterState state) {
      return const SettingsPage();
    },
  ),
  GoRoute(
    path: ROUTE_REMINDERS_EDIT,
    builder: (BuildContext context, GoRouterState state) {
      return const EditNotificationsPage();
    },
  ),
  GoRoute(
    path: ROUTE_ITEM_EDIT,
    builder: (BuildContext context, GoRouterState state) {
      final item = state.extra as Item;
      return EditItemPage(item: item);
    },
  ),
  GoRoute(
    path: ROUTE_ITEM_ADD,
    builder: (BuildContext context, GoRouterState state) {
      return const AddItemPage();
    },
  ),
]);
