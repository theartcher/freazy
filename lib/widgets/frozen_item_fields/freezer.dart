import 'package:flutter/material.dart';
import 'package:freazy/models/item-autocomplete-suggestions.dart';
import 'package:freazy/stores/item-store.dart';
import 'package:freazy/utils/forms/form_focus_helper.dart';
import 'package:freazy/utils/forms/form_validation_helper.dart';
import 'package:freazy/widgets/generic_form_fields/form_text_suggestions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemFreezer extends StatefulWidget {
  final ItemAutoCompleteSuggestions suggestions;
  final FormFocusHelper focusHelper;

  const ItemFreezer(
      {super.key, required this.suggestions, required this.focusHelper});

  @override
  State<ItemFreezer> createState() => _ItemFreezerState();
}

class _ItemFreezerState extends State<ItemFreezer> {
  final _validationHelper = FormValidationHelper();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FrozenItemStore>(context);
    final localization = AppLocalizations.of(context)!;

    return InputWithSuggestions(
      focusNode: widget.focusHelper.freezerFocusNode,
      autocompleteSuggestions: widget.suggestions.freezers,
      selectItem: (value) => store.setFreezer(value),
      selectedItem: store.freezer,
      setFocusNode: widget.focusHelper.setFreezerFocusNode,
      shiftFocus: () => widget.focusHelper.nextFocus(
          widget.focusHelper.freezerFocusNode,
          widget.focusHelper.categoryFocusNode,
          context),
      validateForm: (value) => _validationHelper.validateFreezer(value),
      label: localization.itemConfig_generic_freezerTitle,
      icon: Icons.kitchen,
    );
  }
}
