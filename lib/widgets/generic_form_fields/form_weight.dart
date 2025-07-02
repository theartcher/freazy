import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freazy/utils/forms/form_validation_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

//TODO: Rework into 'weight.dart', this isn't generic enough.
class _WeightInputState extends State<WeightInput> {
  final _validationHelper = FormValidationHelper();

  late TextEditingController _controller;
  String? _lastSelectedWeight;
  String? _errorText;
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text:
            widget.selectedWeight == 0 ? '' : widget.selectedWeight.toString());
    _lastSelectedWeight = widget.selectedWeight.toString();
  }

  @override
  void didUpdateWidget(covariant WeightInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newWeight = widget.selectedWeight == 0 ? '' : widget.selectedWeight.toString();
    if (newWeight != _lastSelectedWeight) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = newWeight;
        }
      });
      _lastSelectedWeight = newWeight;
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
          labelText: localization.itemConfig_generic_weighTitle,
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
