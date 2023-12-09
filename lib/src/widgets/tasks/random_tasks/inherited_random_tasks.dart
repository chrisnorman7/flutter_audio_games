import 'package:flutter/material.dart';

import 'random_tasks.dart';

/// An inherited version of [RandomTasks].
///
/// Instances of [InheritedRandomTasks] will be used when calling
/// [RandomTasks.maybeOf()] and [RandomTasks.of()].
class InheritedRandomTasks extends InheritedWidget {
  /// Create an instance.
  const InheritedRandomTasks({
    required this.pause,
    required this.resume,
    required super.child,
    super.key,
  });

  /// The function that will pause the [RandomTasks.tasks].
  final VoidCallback pause;

  /// The function that will resume the [RandomTasks.tasks].
  final VoidCallback resume;

  /// Whether this widget should notify listeners.
  @override
  bool updateShouldNotify(
    covariant final InheritedRandomTasks oldWidget,
  ) =>
      pause != oldWidget.pause || resume != oldWidget.resume;
}
