import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Extract the new text from the new value
    final newText = newValue.text;

    // Only allow digits and limit to 8 characters (ddmmyyyy)
    if (newText.length > 10 || !RegExp(r'^\d*$').hasMatch(newText)) {
      return oldValue;
    }

    // Auto-formatting to dd/mm/yyyy
    StringBuffer newTextBuffer = StringBuffer();
    int selectionIndex = newValue.selection.end;

    for (int i = 0; i < newText.length; i++) {
      if (i == 2 || i == 4) {
        newTextBuffer.write('/');
        if (i == 2 && newValue.selection.end >= 2) selectionIndex++;
        if (i == 4 && newValue.selection.end >= 4) selectionIndex++;
      }
      newTextBuffer.write(newText[i]);
    }

    return TextEditingValue(
      text: newTextBuffer.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
