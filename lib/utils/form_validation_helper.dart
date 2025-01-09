import 'package:flutter/material.dart';

class FormValidationHelper {
  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'De naam moet ingevuld zijn.';
    }
    if (value.length > 50) {
      return 'De naam mag niet langer dan 50 karakters zijn.';
    }
    return null;
  }

  String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Gewicht mag niet leeg zijn.';
    }
    final number = num.tryParse(value);
    if (number == null) {
      return 'Gewicht moet een getal zijn.';
    }
    if (number > 2500) {
      return 'Zoveel kan je vriezer niet dragen...';
    }

    return null;
  }

  String? validateWeightUnit(String? value) {
    if (value == null || value.isEmpty) {
      return 'Je moet een eenheid kiezen.';
    }
    return null;
  }

  String? validateFreezer(String? value) {
    if (value == null || value.isEmpty) {
      return 'Je moet een vriezer selecteren.';
    }
    return null;
  }

  String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Je moet een categorie selecteren.';
    }
    return null;
  }

  String? validateFreezeDate(DateTime? freezeInDate) {
    if (freezeInDate == null) {
      return 'Je moet een invriesdatum kiezen.';
    }

    DateTime freezeInDateAsDay = DateUtils.dateOnly(freezeInDate);
    DateTime nowAsDay = DateUtils.dateOnly(DateTime.now());

    if (freezeInDateAsDay.isAfter(nowAsDay)) {
      return 'Je kan geen product in de toekomst invriezen.';
    }

    return null;
  }

  String? validateExpirationDate(DateTime? expirationDate) {
    if (expirationDate == null) {
      return 'Je moet een houdbaarheidsdatum kiezen.';
    }

    DateTime expireDateAsDay = DateUtils.dateOnly(expirationDate);
    DateTime nowAsDay = DateUtils.dateOnly(DateTime.now());

    if (expireDateAsDay.isBefore(nowAsDay)) {
      return 'Je kan geen bedorven product invriezen.';
    }
    return null;
  }
}
