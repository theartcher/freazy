import 'package:flutter/material.dart';

const appPrimary = Color(0XFF1f00ff);

final darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: appPrimary,
    brightness: Brightness.dark,
  ),
);

final lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: appPrimary,
    brightness: Brightness.light,
  ),
);
