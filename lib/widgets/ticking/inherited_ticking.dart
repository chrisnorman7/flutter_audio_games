import 'package:flutter/material.dart';

import 'ticking.dart';

/// The inherited version of [Ticking].
class InheritedTicking extends InheritedWidget {
  /// Create an instance.
  const InheritedTicking({
    required this.pause,
    required this.resume,
    required super.child,
    super.key,
  });

  /// The function that will pause the [Ticking].
  final VoidCallback pause;

  /// The function that will resume the [Ticking].
  final VoidCallback resume;

  /// Whether this widget should notify listeners.
  @override
  bool updateShouldNotify(covariant final InheritedTicking oldWidget) =>
      pause != oldWidget.pause ||
      resume != oldWidget.resume ||
      child != oldWidget.child;
}
