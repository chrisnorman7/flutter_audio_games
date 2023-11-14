import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game_shortcut.dart';

/// A widget for handling game shortcuts.
class GameShortcuts extends StatelessWidget {
  /// Create an instance.
  const GameShortcuts({
    required this.shortcuts,
    required this.child,
    this.autofocus = true,
    this.focusNode,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The shortcuts to handle.
  final List<GameShortcut> shortcuts;

  /// Whether this widget should be autofocused.
  final bool autofocus;

  /// The focus node to use.
  final FocusNode? focusNode;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => Focus(
        autofocus: autofocus,
        onKey: (final node, final event) {
          if (event.repeat) {
            return KeyEventResult.ignored;
          }
          for (final shortcut in shortcuts) {
            if (shortcut.key == event.logicalKey &&
                shortcut.controlKey == event.isControlPressed &&
                shortcut.altKey == event.isAltPressed &&
                shortcut.shiftKey == event.isShiftPressed) {
              if (event is RawKeyDownEvent) {
                shortcut.onStart?.call();
              } else {
                shortcut.onStop?.call();
              }
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        focusNode: focusNode,
        child: child,
      );
}
