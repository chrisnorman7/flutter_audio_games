import 'package:flutter/material.dart';

import 'ticking_tasks.dart';

/// A task whose [onTick] method will be called every [duration].
///
/// Instances of [TickingTask] are used by the [TickingTasks] widget.
class TickingTask {
  /// Create an instance.
  const TickingTask({
    required this.duration,
    required this.onTick,
  });

  /// How often [onTick] should be called.
  ///
  /// If this value is `null`, [onTick] will be called every tick.
  final Duration duration;

  /// The function which should be called every [duration].
  final VoidCallback onTick;
}
