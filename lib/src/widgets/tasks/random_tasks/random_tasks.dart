import 'dart:async';

import 'package:flutter/material.dart';

import 'inherited_random_tasks.dart';
import 'random_task.dart';

/// A widget which runs random [tasks].
///
/// This widget is useful for random events, such as playing background sounds,
/// spawning game objects, or moving non-player characters.
///
/// Tasks can be paused by calling [InheritedRandomTasks.pause], and resumed
/// with [InheritedRandomTasks.resume]. You can obtain an [InheritedRandomTasks]
/// instance with the [maybeOf] or [of] static methods.
class RandomTasks extends StatefulWidget {
  /// Create an instance.
  const RandomTasks({
    required this.tasks,
    required this.child,
    super.key,
  });

  /// Possibly provide an instance.
  static InheritedRandomTasks? maybeOf(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedRandomTasks>();

  /// Provide an instance.
  static InheritedRandomTasks of(final BuildContext context) =>
      maybeOf(context)!;

  /// The tasks to use.
  ///
  /// If [tasks] is empty, then this widget will do nothing.
  final List<RandomTask> tasks;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Create state for this widget.
  @override
  RandomTasksState createState() => RandomTasksState();
}

/// State for [RandomTasks].
class RandomTasksState extends State<RandomTasks> {
  /// Whether the random tasks are paused.
  late bool _paused;

  /// Returns `true` if the tasks are running, `false` otherwise.
  bool get isRunning => !_paused;

  /// Returns `true` if the tasks are paused, `false` otherwise.
  bool get isPaused => _paused;

  /// The timers for the tasks.
  late final Map<RandomTask, Timer> timers;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _paused = false;
    timers = {};
    widget.tasks.forEach(scheduleTask);
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    for (final timer in timers.values) {
      timer.cancel();
    }
    timers.clear();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => InheritedRandomTasks(
        pause: pause,
        resume: resume,
        child: widget.child,
      );

  /// Pause the tasks.
  void pause() => _paused = true;

  /// Resume the tasks.
  void resume() => _paused = false;

  /// Run [task].
  void scheduleTask(final RandomTask task) {
    timers[task] = Timer(task.getDuration(), () {
      if (!_paused) {
        task.onTick();
      }
      scheduleTask(task);
    });
  }
}
