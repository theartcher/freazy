import 'package:flutter/material.dart';

class DropdownSetting extends StatefulWidget {
  final String title;
  final List<String> options;
  final String? selectedOption;

  const DropdownSetting({super.key, 
    required this.title,
    required this.options,
    this.selectedOption,
  });

  @override
  _DropdownSettingState createState() => _DropdownSettingState();
}

class _DropdownSettingState extends State<DropdownSetting> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ListTile(
        title: Text(
          widget.title,
          style: theme.textTheme.bodyLarge,
        ),
        subtitle: Text(
          selectedOption ?? 'Select an option',
          style: theme.textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: () {
          _showOptionsDialog(context);
        },
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecteer hoe vaak u notificaties wilt ontvangen'),
          content: SingleChildScrollView(
            child: ListBody(
              children: widget.options.map((String option) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = option;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(option),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
