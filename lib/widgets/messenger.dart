import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum MessagePosition {
  top,
  bottom,
}

enum MessageType {
  success,
  error,
  info,
}

class MessengerService {
  static final MessengerService _instance = MessengerService._internal();
  factory MessengerService() => _instance;
  MessengerService._internal();

  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showMessage({
    required String message,
    String? closeMessage,
    MessagePosition position = MessagePosition.bottom,
    MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 60),
    VoidCallback? onClose,
  }) {
    final context = messengerKey.currentContext!;
    final localization = AppLocalizations.of(context)!;
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();

    _showSnackBar(
      message: message,
      type: type,
      duration: duration,
      onClose: onClose,
      position: position,
      closeText: closeMessage ?? localization.generic_dismiss,
    );
  }

  void _showSnackBar({
    required String message,
    required MessageType type,
    required Duration duration,
    required String closeText,
    VoidCallback? onClose,
    MessagePosition position = MessagePosition.bottom,
  }) {
    final context = messengerKey.currentContext!;

    final snackBar = SnackBar(
      content: Row(
        children: [
          _getIcon(type, _getForegroundColor(type)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: _getForegroundColor(type)),
            ),
          ),
        ],
      ),
      actionOverflowThreshold: 0.5,
      backgroundColor: _getBackgroundColor(type),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: position == MessagePosition.top
          ? EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              left: 10,
              right: 10,
            )
          : const EdgeInsets.all(10),
      action: SnackBarAction(
        label: closeText,
        textColor: _getForegroundColor(type),
        onPressed: () {
          messengerKey.currentState?.hideCurrentSnackBar();
          onClose?.call();
        },
      ),
    );

    messengerKey.currentState?.showSnackBar(snackBar);
  }

  //#region Helper methods
  Color _getForegroundColor(MessageType type) {
    final theme = Theme.of(messengerKey.currentContext!);

    switch (type) {
      case MessageType.info:
      case MessageType.success:
        return theme.colorScheme.onPrimary;
      case MessageType.error:
        return theme.colorScheme.onError;
    }
  }

  Color _getBackgroundColor(MessageType type) {
    final theme = Theme.of(messengerKey.currentContext!);

    switch (type) {
      case MessageType.info:
      case MessageType.success:
        return theme.colorScheme.primary;
      case MessageType.error:
        return theme.colorScheme.error;
    }
  }

  Icon _getIcon(MessageType type, Color color) {
    switch (type) {
      case MessageType.success:
        return Icon(Icons.check_circle, color: color);
      case MessageType.error:
        return Icon(Icons.error, color: color);
      case MessageType.info:
        return Icon(Icons.info, color: color);
    }
  }
  // #endregion
}
