import 'package:flutter/material.dart';

/// A task whose [onTick] method will be called every [duration].
class TickingTask {
  /// Create an instance.
  const TickingTask({
    required this.onTick,
    this.duration,
  });

  /// How often [onTick] should be called.
  ///
  /// If this value is `null`, [onTick] will be called every tick.
  final Duration? duration;

  /// The function which should be called every [duration].
  final VoidCallback onTick;
}
