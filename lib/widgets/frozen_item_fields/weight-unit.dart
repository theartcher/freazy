import 'package:flutter/material.dart';
import 'package:freazy/models/item-autocomplete-suggestions.dart';
import 'package:freazy/stores/item-store.dart';
import 'package:freazy/utils/forms/form_focus_helper.dart';
import 'package:freazy/utils/forms/form_validation_helper.dart';
import 'package:freazy/widgets/generic_form_fields/form_weightUnit.dart';
import 'package:provider/provider.dart';

class ItemWeightUnit extends StatefulWidget {
  final FormFocusHelper focusHelper;

  final ItemAutoCompleteSuggestions suggestions;

  const ItemWeightUnit(
      {super.key, required this.suggestions, required this.focusHelper});

  @override
  State<ItemWeightUnit> createState() => _ItemWeightUnit();
}

class _ItemWeightUnit extends State<ItemWeightUnit> {
  final _validationHelper = FormValidationHelper();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FrozenItemStore>(context);

    return WeightUnitSelector(
      autocompleteSuggestions: widget.suggestions.weightUnits,
      selectItem: (value) => store.setWeightUnit(value),
      selectedItem: context.watch<FrozenItemStore>().weightUnit,
      validateForm: (value) => _validationHelper.validateWeightUnit(value),
      setFocusNode: widget.focusHelper.setWeightUnitFocusNode,
      shiftFocus: () => widget.focusHelper.nextFocus(
        widget.focusHelper.weightUnitFocusNode,
        widget.focusHelper.freezerFocusNode,
        context,
      ),
    );
  }
}
