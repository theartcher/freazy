import 'package:flutter/material.dart';

class Item {
  int? id;
  String title;
  num weight;
  String weightUnit;
  DateTime freezeDate;
  DateTime expirationDate;
  String category;
  String freezer;

  Item(this.id, this.title, this.weight, this.weightUnit, this.freezeDate,
      this.expirationDate, this.category, this.freezer);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'weight': weight,
      'weightUnit': weightUnit,
      'freezeDate': freezeDate.toIso8601String(),
      'expirationDate': expirationDate.toIso8601String(),
      'category': category,
      'freezer': freezer,
    };
  }

  factory Item.fromMap(Map<dynamic, dynamic> map) {
    return Item(
      map['id'] as int,
      map['title'] as String,
      map['weight'] as num,
      map['weightUnit'] as String,
      DateUtils.dateOnly(DateTime.parse(map['freezeDate'] as String)),
      DateUtils.dateOnly(DateTime.parse(map['expirationDate'] as String)),
      map['category'] as String,
      map['freezer'] as String,
    );
  }
}
