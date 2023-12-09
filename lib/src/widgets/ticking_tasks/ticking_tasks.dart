import 'package:flutter/material.dart';

import '../../../flutter_audio_games.dart';

/// A widget which ticks [tasks].
///
/// Instances of [TickingTasks] to move player or fire weapons for example.
class TickingTasks extends StatelessWidget {
  /// Create an instance.
  const TickingTasks({
    required this.tasks,
    required this.child,
    super.key,
  });

  /// The tasks to run.
  ///
  /// If the [tasks] list is empty, this widget will do nothing.
  final List<TickingTask> tasks;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => RandomTasks(
        tasks: tasks
            .map(
              (final e) => RandomTask(
                getDuration: () => e.duration,
                onTick: e.onTick,
              ),
            )
            .toList(),
        child: child,
      );
}
