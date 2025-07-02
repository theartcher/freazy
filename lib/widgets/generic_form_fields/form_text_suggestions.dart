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

  const InputWithSuggestions({
    super.key,
    required this.autocompleteSuggestions,
    required this.selectItem,
    required this.selectedItem,
    required this.validateForm,
    required this.focusNode,
    required this.setFocusNode,
    required this.shiftFocus,
    required this.label,
    required this.icon,
    this.autoFocus = false,
  });

  @override
  State<InputWithSuggestions> createState() => _InputWithSuggestionsState();
}

class _InputWithSuggestionsState extends State<InputWithSuggestions> {
  bool _enabled = true;
  late TextEditingController _controller;
  String? _lastSelectedItem;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.selectedItem);
    _lastSelectedItem = widget.selectedItem;
  }

  @override
  void didUpdateWidget(covariant InputWithSuggestions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != _lastSelectedItem) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = widget.selectedItem;
        }
      });
      _lastSelectedItem = widget.selectedItem;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                  .map(
                    (option) => option.trim(),
                  ) // Trim leading and trailing spaces
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
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController _ignored, // ignore, use our own
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
            ) {
              widget.setFocusNode(focusNode);

              return TextFormField(
                enabled: _enabled,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: widget.validateForm,
                controller: _controller,
                focusNode: focusNode,
                autofocus: widget.autoFocus,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: widget.label,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                      });
                    },
                  ),
                ),
                onTapOutside: (PointerDownEvent? event) =>
                    FocusScope.of(context).unfocus(),
                onSaved: (value) => setState(() {
                  _enabled = false;
                }),
                onChanged: (value) => {
                  if (widget.validateForm(value) == null)
                    {
                      widget.selectItem(value),
                    }
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
