import 'dart:async';

import 'package:flutter/material.dart';

/// A widget which allows the registration of commands to run at a specified
/// interval.
///
/// This widget is used for handling commands like player movement or firing
/// weapons, where you want commands to be invoked at at least a certain
/// interval, but for it to not be possible to spam.
///
/// ```
/// Widget build(final BuildContext context) {
///   return TimedCommands(
///     builder: (final context, final state) {
///       _timedCommandsState = state;
///       state.registerCommand(movePlayer, playerMoveSpeed);
///       return GameShortcuts(
///         autofocus: widget.autofocus,
///         shortcuts: [...],
///         child: Text(
///           'Keyboard area',
///         ),
///       );
///     },
///   );
/// }
/// ```
class TimedCommands extends StatefulWidget {
  /// Create an instance.
  const TimedCommands({
    required this.builder,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget Function(BuildContext context, TimedCommandsState state) builder;

  /// Create state for this widget.
  @override
  TimedCommandsState createState() => TimedCommandsState();
}

/// State for [TimedCommands].
class TimedCommandsState extends State<TimedCommands> {
  /// The commands to run.
  late final List<VoidCallback> _commands;

  /// The intervals at which commands will run.
  late final List<Duration> _intervals;

  /// The flags which show whether commands are running or not.
  late List<bool> _running;

  /// The timers which are currently running.
  late final List<Timer?> _timers;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _commands = [];
    _intervals = [];
    _running = [];
    _timers = [];
  }

  /// Cancel all the timers.
  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    for (final timer in _timers) {
      timer?.cancel();
    }
    for (final list in [_commands, _running, _timers, _intervals]) {
      list.clear();
    }
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => widget.builder(context, this);

  /// Get the index for [command].
  int _getCommandIndex(final VoidCallback command) {
    final index = _commands.indexOf(command);
    if (index == -1) {
      throw StateError(
        'Command $command has not been or is no longer registered.',
      );
    }
    return index;
  }

  /// Register a new command.
  void registerCommand(final VoidCallback command, final Duration interval) {
    _commands.add(command);
    _intervals.add(interval);
    _running.add(false);
    _timers.add(null);
  }

  /// Returns a boolean indicating whether [command] is registered with this
  /// widget.
  bool commandIsRegistered(final VoidCallback command) =>
      _commands.contains(command);

  /// Returns a boolean indicating whether [command] is running.
  ///
  /// This is different from [commandIsScheduled], as it will only return `true`
  /// if the player has indicated a desire to run [command] next cycle.
  bool commandIsRunning(final VoidCallback command) =>
      _running[_getCommandIndex(command)];

  /// Returns a boolean indicating whether [command] is scheduled.
  ///
  /// This is different from [commandIsRunning], as [command] may be scheduled,
  /// but may not run if [stopCommand] has been called.
  bool commandIsScheduled(final VoidCallback command) =>
      _timers[_getCommandIndex(command)] != null;

  /// Start a command.
  ///
  /// Returns `true` if the command was started.
  bool startCommand(final VoidCallback command) {
    final index = _getCommandIndex(command);
    if (commandIsRunning(command)) {
      return false;
    }
    _running[index] = true;
    if (!commandIsScheduled(command)) {
      command();
      _startCommandTimer(command);
    }
    return true;
  }

  /// Start the timer for [command].
  void _startCommandTimer(final VoidCallback command) {
    final index = _getCommandIndex(command);
    final interval = _intervals[index];
    _timers[index] = Timer.periodic(
      interval,
      (final timer) => _runCommand(timer, command, interval),
    );
  }

  /// Stop [command].
  ///
  /// This method will not cancel the timer for [command]. It only ensures it
  /// won't run again this interval.
  ///
  /// Returns `true` if successful.
  bool stopCommand(final VoidCallback command) {
    if (commandIsRunning(command)) {
      _running[_getCommandIndex(command)] = false;
      return true;
    }
    return false;
  }

  /// Change the [interval] that [command] runs at.
  void setCommandInterval(final VoidCallback command, final Duration interval) {
    final index = _getCommandIndex(command);
    _intervals[index] = interval;
    final oldTimer = _timers[index];
    if (oldTimer != null) {
      oldTimer.cancel();
      _startCommandTimer(command);
    }
  }

  /// Run [command].
  ///
  /// This method will be called by the timer created by [startCommand]. It
  /// handles changing intervals after a call to [setCommandInterval], and
  /// cancelling timers when [command] is no longer running.
  void _runCommand(
    final Timer timer,
    final VoidCallback command,
    final Duration interval,
  ) {
    final index = _getCommandIndex(command);
    if (commandIsRunning(command)) {
      command();
      final newInterval = _intervals[index];
      if (newInterval != interval) {
        timer.cancel();
        _startCommandTimer(command);
      }
    } else {
      timer.cancel();
      _timers[index] = null;
    }
  }
}
