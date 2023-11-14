import 'package:flutter/material.dart';

import 'random_task_builder.dart';

/// An inherited version of [RandomTaskBuilder].
class InheritedRandomTaskBuilder extends InheritedWidget {
  /// Create an instance.
  const InheritedRandomTaskBuilder({
    required this.pause,
    required this.resume,
    required super.child,
    super.key,
  });

  /// The function that will pause the [RandomTaskBuilder].
  final VoidCallback pause;

  /// The function that will resume the [RandomTaskBuilder].
  final VoidCallback resume;

  /// Whether this widget should notify listeners.
  @override
  bool updateShouldNotify(
    covariant final InheritedRandomTaskBuilder oldWidget,
  ) =>
      pause != oldWidget.pause ||
      resume != oldWidget.resume ||
      child != oldWidget.child;
}
