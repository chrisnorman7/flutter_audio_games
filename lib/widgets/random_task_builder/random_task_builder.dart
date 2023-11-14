import 'dart:async';

import 'package:flutter/material.dart';

import 'inherited_random_task_builder.dart';
import 'random_task.dart';

/// A widget which runs random [tasks].
class RandomTaskBuilder extends StatefulWidget {
  /// Create an instance.
  const RandomTaskBuilder({
    required this.tasks,
    required this.builder,
    super.key,
  });

  /// Possibly provide an instance.
  static InheritedRandomTaskBuilder? maybeOf(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedRandomTaskBuilder>();

  /// Provide an instance.
  static InheritedRandomTaskBuilder of(final BuildContext context) =>
      maybeOf(context)!;

  /// The tasks to use.
  final List<RandomTask> tasks;

  /// The builder to build the widget.
  final WidgetBuilder builder;

  /// Create state for this widget.
  @override
  RandomTaskBuilderState createState() => RandomTaskBuilderState();
}

/// State for [RandomTaskBuilder].
class RandomTaskBuilderState extends State<RandomTaskBuilder> {
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
  Widget build(final BuildContext context) => InheritedRandomTaskBuilder(
        pause: pause,
        resume: resume,
        child: Builder(builder: widget.builder),
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
