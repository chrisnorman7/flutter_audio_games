import 'dart:async';

import 'package:flutter/material.dart';

import 'inherited_ticking_builder.dart';

/// A widget that calls [onTick] every [duration].
class TickingBuilder extends StatefulWidget {
  /// Create an instance.
  const TickingBuilder({
    required this.duration,
    required this.onTick,
    required this.builder,
    super.key,
  });

  /// Maybe return an instance.
  static InheritedTickingBuilder? maybeOf(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedTickingBuilder>();

  /// Return the nearest instance.
  static InheritedTickingBuilder of(final BuildContext context) =>
      maybeOf(context)!;

  /// How often [onTick] should be called.
  final Duration duration;

  /// The function to call every [duration].
  final VoidCallback onTick;

  /// The builder that will build this widget.
  final WidgetBuilder builder;

  /// Create state for this widget.
  @override
  TickingBuilderState createState() => TickingBuilderState();
}

/// State for [TickingBuilder].
class TickingBuilderState extends State<TickingBuilder> {
  /// The timer to use.
  late final Timer timer;

  /// Whether or not [timer] is paused.
  late bool paused;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    paused = false;
    timer = Timer.periodic(widget.duration, (final timer) {
      if (!paused) {
        widget.onTick();
      }
    });
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => InheritedTickingBuilder(
        pause: () => paused = true,
        resume: () => paused = false,
        child: Builder(builder: widget.builder),
      );
}
