import 'package:flutter/material.dart';
import 'package:freazy/models/item-autocomplete-suggestions.dart';
import 'package:freazy/stores/item-store.dart';
import 'package:freazy/utils/forms/form_focus_helper.dart';
import 'package:freazy/utils/forms/form_validation_helper.dart';
import 'package:freazy/widgets/generic_form_fields/form_text_suggestions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemTitle extends StatefulWidget {
  final ItemAutoCompleteSuggestions suggestions;
  final FormFocusHelper focusHelper;

  const ItemTitle({
    super.key,
    required this.suggestions,
    required this.focusHelper,
  });

  @override
  State<ItemTitle> createState() => _ItemTitleState();
}

class _ItemTitleState extends State<ItemTitle> {
  final _validationHelper = FormValidationHelper();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<FrozenItemStore>();
    final localization = AppLocalizations.of(context)!;

    return InputWithSuggestions(
      focusNode: widget.focusHelper.titleFocusNode,
      shiftFocus: () => widget.focusHelper.nextFocus(
        widget.focusHelper.titleFocusNode,
        widget.focusHelper.weightFocusNode,
        context,
      ),
      autocompleteSuggestions: widget.suggestions.titles,
      selectItem: (value) => store.setTitle(value),
      selectedItem: context.watch<FrozenItemStore>().title,
      validateForm: (value) => _validationHelper.validateTitle(value),
      setFocusNode: widget.focusHelper.setTitleFocusNode,
      label: localization.itemConfig_generic_productTitle,
      icon: Icons.title,
      autoFocus: true,
    );
  }
}
