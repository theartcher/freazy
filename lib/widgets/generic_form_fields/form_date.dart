import 'package:flutter/material.dart';
import 'package:freazy/main.dart';
import 'package:intl/intl.dart';

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
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    textController.text = _formatDate(_selectedDate);
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMd(
      MainApp.of(context).selectedLocale.languageCode,
    ).format(date);
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
            decoration: InputDecoration(
              labelText: widget.label,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: theme.primaryColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.primaryColor,
                  width: 2.0,
                ),
              ),
            ),
            onSaved: (value) => setState(() {
              _enabled = false;
            }),
            onTap: () => _selectDate(context),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Invalid date format';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
