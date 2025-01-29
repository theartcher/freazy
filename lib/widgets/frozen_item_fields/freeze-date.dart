import 'package:flutter/material.dart';
import 'package:freazy/stores/item-store.dart';
import 'package:freazy/utils/forms/form_focus_helper.dart';
import 'package:freazy/utils/forms/form_validation_helper.dart';
import 'package:freazy/widgets/generic_form_fields/form_date.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemFreezeDate extends StatefulWidget {
  final FormFocusHelper focusHelper;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const ItemFreezeDate({
    super.key,
    required this.focusHelper,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<ItemFreezeDate> createState() => _ItemFreezeDateState();
}

class _ItemFreezeDateState extends State<ItemFreezeDate> {
  final _validationHelper = FormValidationHelper();
  static const int fiveYearsInDays = 1825;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FrozenItemStore>(context);
    final localization = AppLocalizations.of(context)!;

    return DateInput(
      focusNode: widget.focusHelper.freezeDateFocusNode,
      selectDate: (value) => store.setFreezerDate(value),
      shiftFocus: () => widget.focusHelper.nextFocus(
          widget.focusHelper.freezeDateFocusNode,
          widget.focusHelper.expirationDateFocusNode,
          context),
      validateForm: (value) => _validationHelper.validateFreezeDate(value),
      firstDate: widget.firstDate ??
          DateTime.now().subtract(
            const Duration(days: fiveYearsInDays),
          ),
      lastDate: widget.lastDate ?? DateTime.now(),
      label: localization.itemConfig_generic_freezeDateTitle,
      icon: Icons.ac_unit,
      initialDate: store.freezeDate,
    );
  }
}
