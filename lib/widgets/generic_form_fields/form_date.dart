import 'package:flutter/material.dart';
import 'package:freazy/widgets/generic_form_fields/date_input_formatter.dart';

class DateInput extends StatefulWidget {
  final FocusNode focusNode;
  final void Function(DateTime date) selectDate;
  final String? Function(DateTime? date) validateForm;
  final VoidCallback shiftFocus;
  final DateTime firstDate;
  final DateTime lastDate;
  final String label;
  final IconData icon;
  final DateTime initialDate;

  const DateInput({
    super.key,
    required this.focusNode,
    required this.selectDate,
    required this.validateForm,
    required this.shiftFocus,
    required this.firstDate,
    required this.lastDate,
    required this.label,
    required this.icon,
    required this.initialDate,
  });

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  final GlobalKey<FormFieldState> _formFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController textController = TextEditingController();
  late DateTime _selectedDate;
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    textController.text = _formatDate(_selectedDate);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        textController.text = _formatDate(picked);
      });

      if (widget.validateForm(picked) == null) {
        widget.selectDate(picked);
      }

      _formFieldKey.currentState?.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Icon(
            widget.icon,
            size: 24,
          ),
        ),
        Flexible(
          child: TextFormField(
            key: _formFieldKey,
            controller: textController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            readOnly: true,
            enabled: _enabled,
            focusNode: widget.focusNode,
            inputFormatters: [DateInputFormatter()],
            decoration: InputDecoration(
              labelText: widget.label,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: theme.primaryColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
              ),
            ),
            onSaved: (value) => setState(() {
              _enabled = false;
            }),
            onTap: () => _selectDate(context),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final parts = value.split('/');
                if (parts.length == 3) {
                  final day = int.parse(parts[0]);
                  final month = int.parse(parts[1]);
                  final year = int.parse(parts[2]);
                  final date = DateTime(year, month, day);
                  return widget.validateForm(date);
                } else {
                  return 'Invalid date format';
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
