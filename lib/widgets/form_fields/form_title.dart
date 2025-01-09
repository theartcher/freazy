import 'package:flutter/material.dart';

class TitleInput extends StatefulWidget {
  final FocusNode focusNode;
  final List<String> titleOptions;
  final void Function(String title) selectTitle;
  final VoidCallback shiftFocus;

  const TitleInput({
    super.key,
    required this.focusNode,
    required this.selectTitle,
    this.titleOptions = const [],
    required this.shiftFocus,
  });

  @override
  State<TitleInput> createState() => _TitleInputState();
}

class _TitleInputState extends State<TitleInput> {
  final TextEditingController _controller = TextEditingController();
  static const int maxCharacterCount = 50;

  bool _enabled = true;

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'De naam moet ingevuld zijn.';
    }
    if (value.length > maxCharacterCount) {
      return 'De naam mag niet langer dan $maxCharacterCount karakters zijn.';
    }
    return null;
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
        const Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(
            Icons.title,
            size: 24,
          ),
        ),
        Flexible(
          child: TextFormField(
            focusNode: widget.focusNode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autofocus: true,
            enabled: _enabled,
            controller: _controller,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Productnaam',
            ),
            validator: _validateTitle,
            onSaved: (value) => setState(() {
              _enabled = false;
            }),
            onChanged: (value) => {
              if (_validateTitle(value) == null) {widget.selectTitle(value)}
            },
            onFieldSubmitted: (value) {
              if (_validateTitle(value) == null) {
                widget.selectTitle(value);
                widget.shiftFocus();
              } else {
                FocusScope.of(context).requestFocus(widget.focusNode);
              }
            },
          ),
        ),
      ],
    );
  }
}
