import 'dart:async';

import 'package:flutter/material.dart';

import 'inherited_random_tasks.dart';
import 'random_task.dart';

/// A widget which runs random [tasks].
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
  final List<RandomTask> tasks;

  /// The builder to build the widget.
  final Widget child;

  /// Create state for this widget.
  @override
  RandomTasksState createState() => RandomTasksState();
}

/// State for [RandomTasks].
class RandomTasksState extends State<RandomTasks> {
  /// Whether the random tasks are paused.
  late bool paused;

  /// The timers for the tasks.
  late final Map<RandomTask, Timer> timers;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    paused = false;
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
  void pause() => paused = true;

  /// Resume the tasks.
  void resume() => paused = false;

  /// Run [task].
  void scheduleTask(final RandomTask task) {
    timers[task] = Timer(task.getDuration(), () {
      if (!paused) {
        task.onTick();
      }
      scheduleTask(task);
    });
  }
}
