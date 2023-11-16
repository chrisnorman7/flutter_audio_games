import 'package:flutter/material.dart';

import '../ticking/ticking.dart';
import 'ticking_task.dart';
import 'ticking_task_context.dart';

/// A widget which ticks [tasks].
class TickingTasks extends StatefulWidget {
  /// Create an instance.
  const TickingTasks({
    required this.duration,
    required this.tasks,
    required this.child,
    super.key,
  });

  /// The duration the [Ticking] should tick.
  final Duration duration;

  /// The tasks to run.
  final List<TickingTask> tasks;

  /// The builder to build the child widget.
  final Widget child;

  /// Create state for this widget.
  @override
  TickingTasksState createState() => TickingTasksState();
}

/// State for [TickingTasks].
class TickingTasksState extends State<TickingTasks> {
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
  Widget build(final BuildContext context) => Ticking(
        duration: widget.duration,
        onTick: onTick,
        child: widget.child,
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
