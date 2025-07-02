import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

//TODO: Rework this into 'weigh-input.dart' widget, this isn't generic enough so can be used directly.
class _WeightUnitSelectorState extends State<WeightUnitSelector> {
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
  void didUpdateWidget(covariant WeightUnitSelector oldWidget) {
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
    final localization = AppLocalizations.of(context)!;

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
              TextEditingController _ignored,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            widget.setFocusNode(focusNode);
            return SizedBox(
              width: 100,
              child: TextFormField(
                enabled: _enabled,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: widget.validateForm,
                controller: _controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: localization.itemConfig_generic_weightUnitTitle,
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
