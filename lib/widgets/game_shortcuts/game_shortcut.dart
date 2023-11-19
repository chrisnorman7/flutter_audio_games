import 'package:flutter/services.dart';

import '../../src/type_defs.dart';
import 'game_shortcuts.dart';

/// A shortcut in a [GameShortcuts] widget.
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
  ///
  /// This property is hear to make shortcuts clearer, and to make it easier for
  /// help menus to be dynamically generated.
  final String title;

  /// The key which will activate this shortcut.
  ///
  /// Note: At this time, only [RawKeyEvent.logicalKey] is used.
  final LogicalKeyboardKey key;

  /// Whether the control key must be used to trigger this shortcut.
  final bool controlKey;

  /// Whether the shift key must be used to trigger this shortcut.
  final bool shiftKey;

  /// Whether the alt key must be used to trigger this shortcut.
  final bool altKey;

  /// The function to call when this key is activated.
  ///
  /// This function will be called when the associated key combination is first
  /// pressed.
  ///
  /// If this value is `null`, then nothing will happen.
  ///
  /// Note: Key repeats are not handled. [RawKeyEvent]s with
  /// [RawKeyEvent.repeat] are ignored.
  final ContextCallback? onStart;

  /// The function to call when this key is deactivated.
  ///
  /// This function will be called when the associated key combination is
  /// released.
  ///
  /// If this value is `null`, then nothing will happen.
  final VoidCallback? onStop;
}
