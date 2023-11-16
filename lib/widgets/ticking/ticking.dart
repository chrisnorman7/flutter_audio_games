import 'dart:async';

import 'package:flutter/material.dart';

import 'inherited_ticking.dart';

/// A widget that calls [onTick] every [duration].
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

  /// The builder that will build this widget.
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
  late bool paused;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    paused = false;
    timer = Timer.periodic(widget.duration, (final _) {
      if (!paused) {
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
        pause: () => paused = true,
        resume: () => paused = false,
        child: widget.child,
      );
}
