import 'dart:ui';

import 'package:intl/intl.dart';

class NotificationLocalizationHelper {
  static const Locale enLocale = Locale("en");
  static const Locale nlLocale = Locale("nl");

  // #region String constants

  static const String unexpectedErrorEn =
      'Something went REALLY wrong if you receive this notification. Please contact us.';
  static const String unexpectedErrorNl =
      'Er is iets compleet misgegaan als u deze notificatie ontvangt. Neem contact met ons op.';

  static const String titleEn = 'Check your freezer soon';
  static const String titleNl = 'Check binnenkort de vriezer';

  static String singleProductExpirationNl(
      String productName, DateTime expirationDate) {
    return 'Uw product $productName gaat op ${DateFormat("yyyy-MM-dd").format(expirationDate)} over de datum.';
  }

  static String singleProductExpirationEn(
      String productName, DateTime expirationDate) {
    return 'Your product $productName will expire on ${DateFormat("yyyy-MM-dd").format(expirationDate)}.';
  }

  static String threeProductExpirationNl(
      String productName1, String productName2, String productName3) {
    return 'De volgende producten gaan binnenkort over de datum: $productName1, $productName2 en $productName3.';
  }

  static String threeProductExpirationEn(
      String productName1, String productName2, String productName3) {
    return 'The following products will expire soon: $productName1, $productName2 and $productName3.';
  }

  static String multipleProductExpirationNl(int count) {
    return 'Er zijn $count producten die binnenkort over de datum zijn.';
  }

  static String multipleProductExpirationEn(int count) {
    return 'There are $count products that will expire soon.';
  }

  // #endregion

  // #region Methods

  String getTitle(Locale locale) {
    switch (locale) {
      case enLocale:
        return titleEn;
      case nlLocale:
        return titleNl;
      default:
        return titleEn;
    }
  }

  String getUnexpectedError(Locale locale) {
    switch (locale) {
      case enLocale:
        return unexpectedErrorEn;
      case nlLocale:
        return unexpectedErrorNl;
      default:
        return unexpectedErrorEn;
    }
  }

  String getSingleItemNotification(
    Locale locale,
    String productName,
    DateTime expirationDate,
  ) {
    switch (locale) {
      case enLocale:
        return singleProductExpirationEn(productName, expirationDate);
      case nlLocale:
        return singleProductExpirationNl(productName, expirationDate);
      default:
        return singleProductExpirationEn(productName, expirationDate);
    }
  }

  String getThreeItemNotification(
    Locale locale,
    String productName1,
    String productName2,
    String productName3,
  ) {
    switch (locale) {
      case enLocale:
        return threeProductExpirationEn(
            productName1, productName2, productName3);
      case nlLocale:
        return threeProductExpirationNl(
            productName1, productName2, productName3);
      default:
        return threeProductExpirationEn(
            productName1, productName2, productName3);
    }
  }

  String getMultipleItemNotification(Locale locale, int count) {
    switch (locale) {
      case enLocale:
        return multipleProductExpirationEn(count);
      case nlLocale:
        return multipleProductExpirationNl(count);
      default:
        return multipleProductExpirationEn(count);
    }
  }
// #endregion
}
