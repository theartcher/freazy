import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freazy/models/item.dart';

//TODO - Update widgets to use clear functions
class FrozenItemStore with ChangeNotifier {
  int? _id;
  String _title = '';
  String _freezer = '';
  String _category = '';
  String _weightUnit = '';
  num _weight = 0;
  DateTime _freezeDate = DateTime.now();
  DateTime _expirationDate = DateTime.now().add(const Duration(days: 14));
  bool _isDirty = false;

  int? get id => _id ?? -1;
  String get title => _title;
  String get freezer => _freezer;
  String get category => _category;
  String get weightUnit => _weightUnit;
  num get weight => _weight;
  DateTime get freezeDate => _freezeDate;
  DateTime get expirationDate => _expirationDate;
  bool get isDirty => _isDirty;

  void clearItem() {
    _id = -1;
    _title = "";
    _freezer = "";
    _category = "";
    _weightUnit = "";
    _weight = 0;
    _freezeDate = DateTime.now();
    _expirationDate = DateTime.now().add(const Duration(days: 14));

    _isDirty = false;

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
    _isDirty = false;

    notifyListeners();
  }

  void setId(int id) {
    if (_id != id) {
      _id = id;
      _isDirty = true;
      notifyListeners();
    }
  }

  void clearId() {
    _id = -1;
    _isDirty = false;
    notifyListeners();
  }

  void setTitle(String newTitle) {
    if (_title != newTitle) {
      _title = newTitle;
      _isDirty = true;
      notifyListeners();
    }
  }

  void clearTitle() {
    _title = "";
    _isDirty = false;
    notifyListeners();
  }

  void setFreezer(String freezer) {
    if (_freezer != freezer) {
      _freezer = freezer;
      _isDirty = true;
      notifyListeners();
    }
  }

  void clearFreezer() {
    _freezer = "";
    _isDirty = false;
    notifyListeners();
  }

  void setCategory(String category) {
    if (_category != category) {
      _category = category;
      _isDirty = true;
      notifyListeners();
    }
  }

  void clearCategory() {
    _category = "";
    _isDirty = false;
    notifyListeners();
  }

  void setWeight(num weight) {
    if (_weight != weight) {
      _weight = weight;
      _isDirty = true;
      notifyListeners();
    }
  }

  void clearWeight() {
    _weight = 0;
    _isDirty = false;
    notifyListeners();
  }

  void setWeightUnit(String weightUnit) {
    if (_weightUnit != weightUnit) {
      _weightUnit = weightUnit;
      _isDirty = true;
      notifyListeners();
    }
  }

  void clearWeightUnit() {
    _weightUnit = "";
    _isDirty = false;
    notifyListeners();
  }

  void setFreezerDate(DateTime freezeDate) {
    if (_freezeDate != freezeDate) {
      _freezeDate = freezeDate;
      _isDirty = true;
      notifyListeners();
    }
  }

  void setExpirationDate(DateTime expirationDate) {
    if (_expirationDate != expirationDate) {
      _expirationDate = expirationDate;
      _isDirty = true;
      notifyListeners();
    }
  }
}
