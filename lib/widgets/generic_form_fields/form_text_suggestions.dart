import 'package:flutter/material.dart';

class InputWithSuggestions extends StatefulWidget {
  final FocusNode focusNode;
  final List<String> autocompleteSuggestions;
  final void Function(String item) selectItem;
  final String? Function(String? item) validateForm;
  final void Function(FocusNode focusNode) setFocusNode;
  final String selectedItem;
  final VoidCallback shiftFocus;
  final String label;
  final IconData icon;
  final bool autoFocus;

  const InputWithSuggestions(
      {super.key,
      required this.autocompleteSuggestions,
      required this.selectItem,
      required this.selectedItem,
      required this.validateForm,
      required this.focusNode,
      required this.setFocusNode,
      required this.shiftFocus,
      required this.label,
      required this.icon,
      this.autoFocus = false});

  @override
  State<InputWithSuggestions> createState() => _InputWithSuggestionsState();
}

class _InputWithSuggestionsState extends State<InputWithSuggestions> {
  bool _enabled = true;
  bool _hasBeenInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Icon(
            widget.icon,
            size: 24,
          ),
        ),
        Expanded(
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              return widget.autocompleteSuggestions
                  .map((option) =>
                      option.trim()) // Trim leading and trailing spaces
                  .toSet() // Remove duplicates
                  .where((String option) {
                return option.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    );
              }).toList();
            },
            onSelected: (String selection) {
              widget.selectItem(selection);
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController controller,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              if (!_hasBeenInitialized) {
                controller.text = widget.selectedItem;
                _hasBeenInitialized = true;
              }
              widget.setFocusNode(focusNode);
              return TextFormField(
                enabled: _enabled,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: widget.validateForm,
                controller: controller,
                focusNode: focusNode,
                autofocus: widget.autoFocus,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: widget.label,
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          controller.clear();
                        });
                      }),
                ),
                onTapOutside: (PointerDownEvent? event) =>
                    FocusScope.of(context).unfocus(),
                onSaved: (value) => setState(() {
                  _enabled = false;
                }),
                onChanged: (value) => {
                  if (widget.validateForm(value) == null)
                    {widget.selectItem(value)}
                },
                onFieldSubmitted: (value) {
                  var isFieldValid = (widget.validateForm(value) == null);

                  if (!isFieldValid) {
                    FocusScope.of(context).requestFocus(focusNode);
                    return;
                  }

                  if (isFieldValid) {
                    widget.selectItem(value);
                    widget.shiftFocus();
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
