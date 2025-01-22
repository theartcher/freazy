import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freazy/utils/forms/form_validation_helper.dart';

class WeightInput extends StatefulWidget {
  final FocusNode focusNode;
  final void Function(num weight) selectWeight;
  final VoidCallback shiftFocus;
  final num selectedWeight;

  const WeightInput({
    super.key,
    required this.focusNode,
    required this.selectWeight,
    required this.shiftFocus,
    required this.selectedWeight,
  });

  @override
  _WeightInputState createState() => _WeightInputState();
}

class _WeightInputState extends State<WeightInput> {
  final _validationHelper = FormValidationHelper();

  late TextEditingController _controller;
  String? _errorText;
  bool _enabled = true;
  late String _currentWeightUnit;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text:
            widget.selectedWeight == 0 ? '' : widget.selectedWeight.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        enabled: _enabled,
        focusNode: widget.focusNode,
        controller: _controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
        ],
        decoration: InputDecoration(
          labelText: 'Gewicht',
          errorText: _errorText,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _controller.clear();
              });
            },
          ),
        ),
        validator: _validationHelper.validateWeight,
        onTapOutside: (PointerDownEvent? event) =>
            FocusScope.of(context).unfocus(),
        onSaved: (value) => setState(() {
          _enabled = false;
        }),
        onChanged: (value) {
          if (_validationHelper.validateWeight(value) == null) {
            widget.selectWeight(num.parse(value));
          }
        },
        onFieldSubmitted: (value) {
          if (_validationHelper.validateWeight(value) == null) {
            widget.selectWeight(num.parse(value));
            widget.shiftFocus();
          } else {
            FocusScope.of(context).requestFocus(widget.focusNode);
          }
        },
      ),
    );
  }
}
