import 'package:flutter/material.dart';
import 'package:freazy/constants/locales.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

OpenFoodFactsLanguage fromLocaleToOpenFoodFactsLanguage(Locale locale) {
  switch (locale) {
    case (nlLocale):
      return OpenFoodFactsLanguage.DUTCH;
    case (enLocale):
    default:
      return OpenFoodFactsLanguage.ENGLISH;
  }
}
