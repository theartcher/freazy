import 'package:flutter/material.dart';

class PressableSettingTile extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? trailing;
  final Color? color;
  final VoidCallback? onPress;
  final bool disabled;

  const PressableSettingTile({
    super.key,
    required this.title,
    this.description,
    this.trailing,
    this.onPress,
    this.color,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = disabled
        ? Theme.of(context).disabledColor
        : color ?? Theme.of(context).textTheme.bodyLarge?.color;

    return ListTile(
      enabled: !disabled,
      onTap: disabled ? null : onPress,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: textColor,
            ),
      ),
      subtitle: description != null
          ? Text(
              description!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor,
                  ),
            )
          : null,
      trailing: trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minVerticalPadding: 0,
    );
  }
}
