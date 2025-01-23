import 'package:flutter/material.dart';

class PressableSettingTile extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? trailing;
  final Color? color;
  final Function? onPress;

  const PressableSettingTile({
    super.key,
    required this.title,
    this.description,
    this.trailing,
    this.onPress,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress != null ? () => onPress!() : null,
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
      trailing: trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minVerticalPadding: 0,
    );
  }
}
