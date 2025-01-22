import 'package:flutter/material.dart';
import 'package:freazy/stores/item-store.dart';
import 'package:freazy/utils/forms/form_focus_helper.dart';
import 'package:freazy/utils/forms/form_validation_helper.dart';
import 'package:freazy/widgets/generic_form_fields/form_date.dart';
import 'package:provider/provider.dart';

class ItemExpirationDate extends StatefulWidget {
  final FormFocusHelper focusHelper;

  const ItemExpirationDate({super.key, required this.focusHelper});

  @override
  State<ItemExpirationDate> createState() => _ItemExpirationDateState();
}

class _ItemExpirationDateState extends State<ItemExpirationDate> {
  final _validationHelper = FormValidationHelper();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FrozenItemStore>(context);

    return DateInput(
        focusNode: widget.focusHelper.expirationDateFocusNode,
        selectDate: (value) => store.setExpirationDate(value),
        shiftFocus: () => widget.focusHelper.nextFocus(
            widget.focusHelper.expirationDateFocusNode,
            widget.focusHelper.sendFormFocusNode,
            context),
        validateForm: (value) =>
            _validationHelper.validateExpirationDate(value),
        firstDate: DateUtils.dateOnly(DateTime.now()),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        label: 'Houdbaarheidsdatum',
        icon: Icons.running_with_errors,
        initialDate: store.expirationDate);
  }
}
