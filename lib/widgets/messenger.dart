import 'package:flutter/material.dart';

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
    MessagePosition position = MessagePosition.bottom,
    MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onClose,
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    // Clear any existing messages first
    messenger.hideCurrentMaterialBanner();
    messenger.hideCurrentSnackBar();

    if (position == MessagePosition.bottom) {
      _showSnackBar(
        message: message,
        type: type,
        duration: duration,
        onClose: onClose,
      );
    } else {
      _showBanner(
        message: message,
        position: position,
        type: type,
        duration: duration,
        onClose: onClose,
      );
    }
  }

  void _showSnackBar({
    required String message,
    required MessageType type,
    required Duration duration,
    VoidCallback? onClose,
  }) {
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
      backgroundColor: _getBackgroundColor(type),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: _getForegroundColor(type),
        onPressed: () {
          messengerKey.currentState?.hideCurrentSnackBar();
          onClose?.call();
        },
      ),
    );

    messengerKey.currentState?.showSnackBar(snackBar);
  }

  void _showBanner({
    required String message,
    required MessagePosition position,
    required MessageType type,
    required Duration duration,
    VoidCallback? onClose,
  }) {
    final banner = MaterialBanner(
      content: Text(
        message,
        style: TextStyle(color: _getForegroundColor(type)),
      ),
      backgroundColor: _getBackgroundColor(type),
      leading: _getIcon(type, _getForegroundColor(type)),
      actions: [
        TextButton(
          onPressed: () {
            messengerKey.currentState?.hideCurrentMaterialBanner();
            onClose?.call();
          },
          child: Text(
            'Dismiss',
            style: TextStyle(color: _getForegroundColor(type)),
          ),
        ),
      ],
      contentTextStyle: TextStyle(color: _getForegroundColor(type)),
      padding: EdgeInsets.only(
        top: position == MessagePosition.top
            ? MediaQuery.of(messengerKey.currentContext!).padding.top
            : 0,
        left: 16,
        right: 16,
        bottom: 16,
      ),
    );

    messengerKey.currentState?.showMaterialBanner(banner);
    Future.delayed(duration, () {
      messengerKey.currentState?.hideCurrentMaterialBanner();
      onClose?.call();
    });
  }

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
}
