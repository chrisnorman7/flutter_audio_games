import 'package:flutter/services.dart';

/// A shortcut in the game.
class GameShortcut {
  /// Create an instance.
  const GameShortcut({
    required this.title,
    required this.key,
    this.onStart,
    this.onStop,
    this.controlKey = false,
    this.altKey = false,
    this.shiftKey = false,
  });

  /// The title of this shortcut.
  final String title;

  /// The key which will activate this shortcut.
  final LogicalKeyboardKey key;

  /// Whether the control key must be used.
  final bool controlKey;

  /// Whether the shift key must be used.
  final bool shiftKey;

  /// Whether the alt key must be used.
  final bool altKey;

  /// The function to call when this key is activated.
  final VoidCallback? onStart;

  /// The function to call when this key is deactivated.
  final VoidCallback? onStop;
}
