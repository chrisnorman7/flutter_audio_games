import 'package:flutter/material.dart';

import 'game_shortcut.dart';
import 'game_shortcuts.dart';

/// An inherited widget for use with [GameShortcuts].
///
/// Instances of [InheritedGameShortcuts] are returned by
/// [GameShortcuts.maybeOf] and [GameShortcuts.of].
class InheritedGameShortcuts extends InheritedWidget {
  /// Create an instance.
  const InheritedGameShortcuts({
    required this.shortcuts,
    required super.child,
    super.key,
  });

  /// The shortcuts to use.
  final List<GameShortcut> shortcuts;

  /// Whether listeners should be notified.
  @override
  bool updateShouldNotify(covariant final InheritedGameShortcuts oldWidget) =>
      shortcuts != oldWidget.shortcuts;
}
