import 'package:flutter/material.dart';
import 'package:freazy/stores/item-store.dart';
import 'package:freazy/utils/forms/form_focus_helper.dart';
import 'package:freazy/widgets/generic_form_fields/form_weight.dart';
import 'package:provider/provider.dart';

class ItemWeight extends StatefulWidget {
  final FormFocusHelper focusHelper;

  const ItemWeight({super.key, required this.focusHelper});

  @override
  State<ItemWeight> createState() => _ItemWeight();
}

class _ItemWeight extends State<ItemWeight> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FrozenItemStore>(context);

    return WeightInput(
      focusNode: widget.focusHelper.weightFocusNode,
      selectWeight: (value) => store.setWeight(value),
      shiftFocus: () => widget.focusHelper.nextFocus(
          widget.focusHelper.weightFocusNode,
          widget.focusHelper.weightUnitFocusNode,
          context),
      selectedWeight: store.weight,
    );
  }
}
