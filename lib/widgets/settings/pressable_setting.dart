import 'package:flutter/material.dart';

class PressableSettingTile extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final Color? color;
  final Function onPress;

  const PressableSettingTile({
    super.key,
    required this.title,
    this.description,
    this.icon,
    required this.onPress,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onPress(),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
            ),
      ),
      subtitle: description != null
          ? Text(
              description!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        color ?? Theme.of(context).textTheme.bodySmall?.color,
                  ),
            )
          : null,
      trailing: icon != null
          ? Icon(
              icon,
              size: 24,
              color: color,
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minVerticalPadding: 0,
    );
  }
}
