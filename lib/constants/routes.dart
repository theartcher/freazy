import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:freazy/constants/constants.dart';
import 'package:freazy/models/item.dart';
import 'package:freazy/pages/frozen_item/details.dart';
import 'package:freazy/pages/settings.dart';
import 'package:freazy/pages/home.dart';

final GoRouter router = GoRouter(routes: <RouteBase>[
  GoRoute(
    path: ROUTE_HOME,
    builder: (BuildContext context, GoRouterState state) {
      return const HomePage();
    },
  ),
  GoRoute(
    path: ROUTE_ITEM_DETAILS,
    builder: (BuildContext context, GoRouterState state) {
      final item = state.extra as Item?;
      return ItemDetailsPage(item: item);
    },
  ),
  GoRoute(
    path: ROUTE_SETTINGS,
    builder: (BuildContext context, GoRouterState state) {
      return const SettingsPage();
    },
  ),
]);
