import 'package:flutter/material.dart';

import '../ticking_builder/ticking_builder.dart';
import 'ticking_task.dart';
import 'ticking_task_context.dart';

/// A widget which ticks [tasks].
class TickingTaskBuilder extends StatefulWidget {
  /// Create an instance.
  const TickingTaskBuilder({
    required this.duration,
    required this.tasks,
    required this.builder,
    super.key,
  });

  /// The duration the [TickingBuilder] should tick.
  final Duration duration;

  /// The tasks to run.
  final List<TickingTask> tasks;

  /// The builder to build the child widget.
  final WidgetBuilder builder;

  /// Create state for this widget.
  @override
  TickingTaskBuilderState createState() => TickingTaskBuilderState();
}

/// State for [TickingTaskBuilder].
class TickingTaskBuilderState extends State<TickingTaskBuilder> {
  /// The contexts for the running tasks.
  late final List<TickingTaskContext> taskContexts;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    taskContexts =
        widget.tasks.map((final e) => TickingTaskContext(task: e)).toList();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => TickingBuilder(
        duration: widget.duration,
        onTick: onTick,
        builder: widget.builder,
      );

  /// Tick the clock.
  void onTick() {
    final now = DateTime.now();
    for (final taskContext in taskContexts) {
      final task = taskContext.task;
      final duration = task.duration;
      final lastRun = taskContext.lastRun;
      if (duration == null ||
          lastRun == null ||
          now.difference(lastRun) >= duration) {
        task.onTick();
        taskContext.lastRun = now;
      }
    }
  }
}
