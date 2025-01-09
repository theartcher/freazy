import 'package:freazy/stores/actions.dart';

String productReducer(String state, dynamic action) {
  if (action is UpdateProduct) {
    return action.product;
  }
  return state;
}

num weightReducer(num state, dynamic action) {
  if (action is UpdateWeight) {
    return action.weight;
  }
  return state;
}

String weightUnitReducer(String state, dynamic action) {
  if (action is UpdateWeightUnit) {
    return action.weightUnit;
  }
  return state;
}

String freezerReducer(String state, dynamic action) {
  if (action is UpdateFreezer) {
    return action.freezer;
  }
  return state;
}

String categoryReducer(String state, dynamic action) {
  if (action is UpdateCategory) {
    return action.category;
  }
  return state;
}

DateTime freezeDateReducer(DateTime state, dynamic action) {
  if (action is UpdateFreezeDate) {
    return action.freezeDate;
  }
  return state;
}

DateTime expirationDateReducer(DateTime state, dynamic action) {
  if (action is UpdateExpirationDate) {
    return action.expirationDate;
  }
  return state;
}
