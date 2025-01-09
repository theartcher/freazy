import 'package:freazy/stores/reducers.dart';
import 'package:redux/redux.dart';

class AppState {
  final String product;
  final num weight;
  final String weightUnit;
  final String freezer;
  final String category;
  final DateTime freezeDate;
  final DateTime expirationDate;

  AppState({
    required this.product,
    required this.weight,
    required this.weightUnit,
    required this.freezer,
    required this.category,
    required this.freezeDate,
    required this.expirationDate,
  });

  AppState.initial()
      : product = '',
        weight = 0,
        weightUnit = '',
        freezer = '',
        category = '',
        freezeDate = DateTime.now(),
        expirationDate = DateTime.now();
}

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    product: productReducer(state.product, action),
    weight: weightReducer(state.weight, action),
    weightUnit: weightUnitReducer(state.weightUnit, action),
    freezer: freezerReducer(state.freezer, action),
    category: categoryReducer(state.category, action),
    freezeDate: freezeDateReducer(state.freezeDate, action),
    expirationDate: expirationDateReducer(state.expirationDate, action),
  );
}
