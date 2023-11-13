import 'package:flutter/material.dart';

import 'ticking_builder.dart';

/// The inherited version of [TickingBuilder].
class InheritedTickingBuilder extends InheritedWidget {
  /// Create an instance.
  const InheritedTickingBuilder({
    required this.pause,
    required this.resume,
    required super.child,
    super.key,
  });

  /// The function that will pause the [TickingBuilder].
  final VoidCallback pause;

  /// The function that will resume the [TickingBuilder].
  final VoidCallback resume;

  /// Whether this widget should notify listeners.
  @override
  bool updateShouldNotify(covariant final InheritedTickingBuilder oldWidget) =>
      pause != oldWidget.pause ||
      resume != oldWidget.resume ||
      child != oldWidget.child;
}
