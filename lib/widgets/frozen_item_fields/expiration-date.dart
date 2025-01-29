import 'package:flutter/material.dart';
import 'package:freazy/stores/item-store.dart';
import 'package:freazy/utils/forms/form_focus_helper.dart';
import 'package:freazy/utils/forms/form_validation_helper.dart';
import 'package:freazy/widgets/generic_form_fields/form_date.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemExpirationDate extends StatefulWidget {
  final FormFocusHelper focusHelper;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const ItemExpirationDate({
    super.key,
    required this.focusHelper,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<ItemExpirationDate> createState() => _ItemExpirationDateState();
}

class _ItemExpirationDateState extends State<ItemExpirationDate> {
  final _validationHelper = FormValidationHelper();
  static const int fiveYearsInDays = 1825;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FrozenItemStore>(context);
    final localization = AppLocalizations.of(context)!;

    return DateInput(
      focusNode: widget.focusHelper.expirationDateFocusNode,
      selectDate: (value) => store.setExpirationDate(value),
      shiftFocus: () => widget.focusHelper.nextFocus(
          widget.focusHelper.expirationDateFocusNode,
          widget.focusHelper.sendFormFocusNode,
          context),
      validateForm: (value) => _validationHelper.validateExpirationDate(value),
      firstDate: widget.firstDate ??
          DateUtils.dateOnly(
            DateTime.now(),
          ),
      lastDate: widget.lastDate ??
          DateTime.now().add(
            const Duration(days: fiveYearsInDays),
          ),
      label: localization.itemConfig_generic_expirationDateTitle,
      icon: Icons.running_with_errors,
      initialDate: store.expirationDate,
    );
  }
}
