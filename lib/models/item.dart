import 'package:flutter/material.dart';

class Item {
  int? id;
  String title;
  String freezer;
  String category;
  String weightUnit;
  num weight;
  DateTime freezeDate;
  DateTime expirationDate;

  Item({
    this.id,
    required this.title,
    required this.freezer,
    required this.category,
    required this.weightUnit,
    required this.weight,
    required this.freezeDate,
    required this.expirationDate,
  });

  /// Empty constructor with default values
  Item.empty()
      : id = null,
        title = '',
        weight = 0,
        weightUnit = 'g',
        freezeDate = DateTime.now(),
        expirationDate = DateTime.now().add(const Duration(days: 14)),
        category = '',
        freezer = '';

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

  Item copyWith({
    String? title,
    String? freezer,
    String? category,
    String? weightUnit,
    num? weight,
    DateTime? freezeDate,
    DateTime? expirationDate,
    int? id,
  }) {
    return Item(
      title: title ?? this.title,
      freezer: freezer ?? this.freezer,
      category: category ?? this.category,
      weightUnit: weightUnit ?? this.weightUnit,
      weight: weight ?? this.weight,
      freezeDate: freezeDate ?? this.freezeDate,
      expirationDate: expirationDate ?? this.expirationDate,
      id: id ?? this.id,
    );
  }

  factory Item.fromMap(Map<dynamic, dynamic> map) {
    return Item(
      id: map['id'] as int,
      title: map['title'] as String,
      weight: map['weight'] as num,
      weightUnit: map['weightUnit'] as String,
      freezeDate:
          DateUtils.dateOnly(DateTime.parse(map['freezeDate'] as String)),
      expirationDate:
          DateUtils.dateOnly(DateTime.parse(map['expirationDate'] as String)),
      category: map['category'] as String,
      freezer: map['freezer'] as String,
    );
  }
}
