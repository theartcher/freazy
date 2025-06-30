import 'package:flutter/material.dart';

class ToggleSwitchSetting extends StatelessWidget {
  final String title;
  final String? description;
  final bool isToggled;
  final ValueChanged<bool> changeValue;

  const ToggleSwitchSetting({
    super.key,
    required this.title,
    this.description,
    required this.isToggled,
    required this.changeValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge,
                ),
                if (description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      description!,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: isToggled,
            activeColor: theme.colorScheme.primary,
            activeTrackColor: theme.colorScheme.primaryContainer,
            inactiveThumbColor: theme.colorScheme.onSurfaceVariant,
            onChanged: changeValue,
          ),
        ],
      ),
    );
  }
}
