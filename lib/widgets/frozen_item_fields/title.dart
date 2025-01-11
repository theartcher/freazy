import 'package:flutter/material.dart';
import 'package:freazy/models/item-autocomplete-suggestions.dart';
import 'package:freazy/stores/item-store.dart';
import 'package:freazy/utils/form_focus_helper.dart';
import 'package:freazy/utils/form_validation_helper.dart';
import 'package:freazy/widgets/generic_form_fields/form_text_suggestions.dart';
import 'package:provider/provider.dart';

//TODO better label
//TODO translations
class ItemTitle extends StatefulWidget {
  final ItemAutoCompleteSuggestions suggestions;
  final FormFocusHelper focusHelper;

  const ItemTitle(
      {super.key, required this.suggestions, required this.focusHelper});

  @override
  State<ItemTitle> createState() => _ItemTitleState();
}

class _ItemTitleState extends State<ItemTitle> {
  final _validationHelper = FormValidationHelper();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FrozenItemStore>(context);

    return InputWithSuggestions(
      focusNode: widget.focusHelper.titleFocusNode,
      shiftFocus: () => widget.focusHelper.nextFocus(
          widget.focusHelper.titleFocusNode,
          widget.focusHelper.weightFocusNode,
          context),
      autocompleteSuggestions: widget.suggestions.titles,
      selectItem: (value) => store.setTitle(value),
      selectedItem: store.title,
      validateForm: (value) => _validationHelper.validateTitle(value),
      setFocusNode: widget.focusHelper.setTitleFocusNode,
      label: 'Product',
      icon: Icons.title,
      autoFocus: true,
    );
  }
}
