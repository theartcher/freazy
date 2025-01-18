import 'package:flutter/material.dart';
import 'package:freazy/models/reminder.dart';

class DialogueSettings extends StatelessWidget {
  final String title;
  final String? description;
  final Function openMenu;
  final IconData? icon;

  const DialogueSettings({
    super.key,
    required this.title,
    this.description,
    required this.openMenu,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => this.openMenu(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
            if (icon != null)
              Icon(
                icon,
                size: 24,
              )
          ],
        ),
      ),
    );
  }
}
