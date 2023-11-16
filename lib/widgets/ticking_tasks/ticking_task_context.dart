import 'ticking_task.dart';

/// Contextual information for [task].
class TickingTaskContext {
  /// Create an instance.
  TickingTaskContext({
    required this.task,
    this.lastRun,
  });

  /// The task this class represents.
  final TickingTask task;

  /// The time that [task] was last ran.
  DateTime? lastRun;
}
