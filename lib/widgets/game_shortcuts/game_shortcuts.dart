import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game_shortcut.dart';

/// A widget for handling game [shortcuts].
///
/// Wrap a widget in a [GameShortcuts] widget to easily add game-friendly
/// shortcuts to a game.
///
/// This widget differs from the [CallbackShortcuts] widget because repeated key
/// events are ignored.
class GameShortcuts extends StatelessWidget {
  /// Create an instance.
  const GameShortcuts({
    required this.shortcuts,
    required this.child,
    this.autofocus = true,
    this.focusNode,
    super.key,
  });

  /// Possibly return an instance.
  static GameShortcuts? maybeOf(final BuildContext context) =>
      context.findAncestorWidgetOfExactType<GameShortcuts>();

  /// Return an instance.
  static GameShortcuts of(final BuildContext context) => maybeOf(context)!;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The shortcuts to handle.
  ///
  /// If the [shortcuts] list is empty, then this widget will do nothing.
  final List<GameShortcut> shortcuts;

  /// Whether the resulting [Focus] widget should be autofocused.
  final bool autofocus;

  /// The focus node to use.
  ///
  /// Only provide a [focusNode] if you wish to use [focusNode.requestFocus()]
  /// for example.
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
