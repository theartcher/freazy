import 'package:flutter/material.dart';

class WeightUnitSelector extends StatefulWidget {
  final List<String> autocompleteSuggestions;
  final void Function(String item) selectItem;
  final String? Function(String? item) validateForm;
  final String selectedItem;
  final void Function(FocusNode focusNode) setFocusNode;
  final VoidCallback shiftFocus;

  const WeightUnitSelector({
    super.key,
    required this.autocompleteSuggestions,
    required this.selectItem,
    required this.selectedItem,
    required this.validateForm,
    required this.setFocusNode,
    required this.shiftFocus,
  });

  @override
  State<WeightUnitSelector> createState() => _WeightUnitSelectorState();
}

class _WeightUnitSelectorState extends State<WeightUnitSelector> {
  bool _enabled = true;
  bool _hasBeenInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: IntrinsicWidth(
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            return widget.autocompleteSuggestions.where((String option) {
              return option
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            }).toList();
          },
          onSelected: widget.selectItem,
          fieldViewBuilder: (BuildContext context,
              TextEditingController controller,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            if (!_hasBeenInitialized) {
              controller.text = widget.selectedItem;
              _hasBeenInitialized = true;
            }

            widget.setFocusNode(focusNode);
            return SizedBox(
              width: 100,
              child: TextFormField(
                enabled: _enabled,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: widget.validateForm,
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: 'Eenheid',
                ),

                //TODO: Focusnode for units
                //TODO: Adding , to weighiniput crashes bug??
                //TODO: Make notification widget
                textCapitalization: TextCapitalization.none,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                onSaved: (_) => setState(() => _enabled = false),
                onChanged: (value) {
                  if (widget.validateForm(value) == null) {
                    widget.selectItem(value);
                  }
                },
                onFieldSubmitted: (value) {
                  if (widget.validateForm(value) == null) {
                    widget.selectItem(value);
                    widget.shiftFocus();
                  } else {
                    FocusScope.of(context).requestFocus(focusNode);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
