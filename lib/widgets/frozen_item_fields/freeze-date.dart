import 'package:flutter/material.dart';
import 'package:freazy/stores/item-store.dart';
import 'package:freazy/utils/forms/form_focus_helper.dart';
import 'package:freazy/utils/forms/form_validation_helper.dart';
import 'package:freazy/widgets/generic_form_fields/form_date.dart';
import 'package:provider/provider.dart';

class ItemFreezeDate extends StatefulWidget {
  final FormFocusHelper focusHelper;

  const ItemFreezeDate({super.key, required this.focusHelper});

  @override
  State<ItemFreezeDate> createState() => _ItemFreezeDateState();
}

class _ItemFreezeDateState extends State<ItemFreezeDate> {
  final _validationHelper = FormValidationHelper();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FrozenItemStore>(context);

    return DateInput(
      focusNode: widget.focusHelper.freezeDateFocusNode,
      selectDate: (value) => store.setFreezerDate(value),
      shiftFocus: () => widget.focusHelper.nextFocus(
          widget.focusHelper.freezeDateFocusNode,
          widget.focusHelper.expirationDateFocusNode,
          context),
      validateForm: (value) => _validationHelper.validateFreezeDate(value),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
      label: 'Invriesdatum',
      icon: Icons.ac_unit,
      initialDate: store.freezeDate,
    );
  }
}
