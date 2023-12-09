import 'package:flutter/material.dart';

import 'random_tasks.dart';

/// A task which will happen every [getDuration].
///
/// Instances of [RandomTask] are used by the [RandomTasks] widget.
class RandomTask {
  /// Create an instance.
  const RandomTask({
    required this.getDuration,
    required this.onTick,
  });

  /// The function to call to get the duration.
  final Duration Function() getDuration;

  /// The function to call every [getDuration].
  final VoidCallback onTick;
}
