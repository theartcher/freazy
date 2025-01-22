import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freazy/models/item.dart';

/* TO DO:
  - Implement
  - Add validation
*/
class FrozenItemStore with ChangeNotifier {
  int? _id;
  String _title = '';
  String _freezer = '';
  String _category = '';
  String _weightUnit = '';
  num _weight = 0;
  DateTime _freezeDate = DateTime.now();
  DateTime _expirationDate = DateTime.now().add(const Duration(days: 14));

  int? get id => _id ?? -1;
  String get title => _title;
  String get freezer => _freezer;
  String get category => _category;
  String get weightUnit => _weightUnit;
  num get weight => _weight;
  DateTime get freezeDate => _freezeDate;
  DateTime get expirationDate => _expirationDate;

  void clearItem() {
    _id = -1;
    _title = "";
    _freezer = "";
    _category = "";
    _weightUnit = "";
    _weight = 0;
    _freezeDate = DateTime.now();
    _expirationDate = DateTime.now().add(const Duration(days: 14));

    notifyListeners();
  }

  Item getItem() {
    Item item = Item(
        title: title,
        freezer: freezer,
        category: category,
        weightUnit: weightUnit,
        weight: weight,
        freezeDate: freezeDate,
        expirationDate: expirationDate);

    return item;
  }

  void setItem(Item item) {
    _id = item.id ?? -1;
    _title = item.title;
    _freezer = item.freezer;
    _category = item.category;
    _weightUnit = item.weightUnit;
    _weight = item.weight;
    _freezeDate = item.freezeDate;
    _expirationDate = item.expirationDate;

    notifyListeners();
  }

  void setId(int id) {
    _id = id;
    notifyListeners();
  }

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setFreezer(String freezer) {
    _freezer = freezer;
    notifyListeners();
  }

  void setCategory(String category) {
    _category = category;
    notifyListeners();
  }

  void setWeight(num weight) {
    _weight = weight;
    notifyListeners();
  }

  void setWeightUnit(String weightUnit) {
    _weightUnit = weightUnit;
    notifyListeners();
  }

  void setFreezerDate(DateTime freezeDate) {
    _freezeDate = freezeDate;
    notifyListeners();
  }

  void setExpirationDate(DateTime expirationDate) {
    _expirationDate = expirationDate;
    notifyListeners();
  }
}
