import 'dart:async';

import 'package:flutter/material.dart';

import 'inherited_ticking.dart';

/// A widget that calls [onTick] every [duration].
///
/// Wrapping any [Widget] in a [Ticking] can be used to run tasks which should
/// do something every frame, such as moving vehicles, healing or doing damage,
/// or resetting zones.
class Ticking extends StatefulWidget {
  /// Create an instance.
  const Ticking({
    required this.duration,
    required this.onTick,
    required this.child,
    super.key,
  });

  /// Maybe return an instance.
  static InheritedTicking? maybeOf(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedTicking>();

  /// Return the nearest instance.
  static InheritedTicking of(final BuildContext context) => maybeOf(context)!;

  /// How often [onTick] should be called.
  final Duration duration;

  /// The function to call every [duration].
  final VoidCallback onTick;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Create state for this widget.
  @override
  TickingState createState() => TickingState();
}

/// State for [Ticking].
class TickingState extends State<Ticking> {
  /// The timer to use.
  late final Timer timer;

  /// Whether or not [timer] is paused.
  late bool _paused;

  /// Returns `true` if [widget.onTick()] should run, `false` otherwise.
  bool get isRunning => !_paused;

  /// Returns `true` if [widget.onTick()] should not run, `false` otherwise.
  bool get isPaused => _paused;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _paused = false;
    timer = Timer.periodic(widget.duration, (final _) {
      if (!_paused) {
        widget.onTick();
      }
    });
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => InheritedTicking(
        pause: () => _paused = true,
        resume: () => _paused = false,
        child: widget.child,
      );
}
