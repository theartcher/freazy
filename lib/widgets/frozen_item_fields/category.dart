import 'package:flutter/material.dart';
import 'package:freazy/models/item-autocomplete-suggestions.dart';
import 'package:freazy/stores/item-store.dart';
import 'package:freazy/utils/forms/form_focus_helper.dart';
import 'package:freazy/utils/forms/form_validation_helper.dart';
import 'package:freazy/widgets/generic_form_fields/form_text_suggestions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemCategory extends StatefulWidget {
  final ItemAutoCompleteSuggestions suggestions;
  final FormFocusHelper focusHelper;

  const ItemCategory(
      {super.key, required this.suggestions, required this.focusHelper});

  @override
  State<ItemCategory> createState() => _ItemCategoryState();
}

class _ItemCategoryState extends State<ItemCategory> {
  final _validationHelper = FormValidationHelper();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FrozenItemStore>(context);
    final localization = AppLocalizations.of(context)!;

    return InputWithSuggestions(
      focusNode: widget.focusHelper.categoryFocusNode,
      autocompleteSuggestions: widget.suggestions.categories,
      selectItem: (value) => store.setCategory(value),
      selectedItem: store.category,
      setFocusNode: widget.focusHelper.setCategoryFocusNode,
      shiftFocus: () => widget.focusHelper.nextFocus(
          widget.focusHelper.categoryFocusNode,
          widget.focusHelper.freezeDateFocusNode,
          context),
      validateForm: (value) => _validationHelper.validateCategory(value),
      label: localization.itemConfig_generic_categoriesTitle,
      icon: Icons.category,
    );
  }
}
