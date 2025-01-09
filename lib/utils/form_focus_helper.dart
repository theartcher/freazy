import 'package:flutter/material.dart';

class FormFocusHelper {
  FocusNode titleFocusNode = FocusNode();
  final FocusNode weightFocusNode = FocusNode();
  FocusNode weightUnitFocusNode = FocusNode();
  FocusNode freezerFocusNode = FocusNode();
  FocusNode categoryFocusNode = FocusNode();
  final FocusNode freezeDateFocusNode = FocusNode();
  final FocusNode expirationDateFocusNode = FocusNode();
  final FocusNode sendFormFocusNode = FocusNode();

  void nextFocus(FocusNode current, FocusNode next, BuildContext context) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  void setWeightUnitFocusNode(FocusNode focusNode) {
    weightUnitFocusNode = focusNode;
  }

  void setFreezerFocusNode(FocusNode focusNode) {
    freezerFocusNode = focusNode;
  }

  void setCategoryFocusNode(FocusNode focusNode) {
    categoryFocusNode = focusNode;
  }

  void setTitleFocusNode(FocusNode focusNode) {
    titleFocusNode = focusNode;
  }
}
