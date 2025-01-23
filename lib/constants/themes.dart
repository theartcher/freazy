import 'package:flutter/material.dart';

final darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0XFF1f00ff),
    brightness: Brightness.dark,
  ),
);

final lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0XFF1f00ff),
    brightness: Brightness.light,
  ),
);
