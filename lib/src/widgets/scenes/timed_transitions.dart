import 'dart:async';

import 'package:flutter/material.dart';

import '../../type_defs.dart';

/// A widget which can transition between widgets on user gesture or similar.
///
/// The first widget to be build is returned by [initialBuilder], which will be
/// passed an [OnTransition] function.
class TimedTransitions extends StatefulWidget {
  /// Create an instance.
  const TimedTransitions({
    required this.initialBuilder,
    required this.transitionBuilder,
    super.key,
  });

  /// The initial builder to use.
  final Widget Function(BuildContext context, OnTransition onTransition)
      initialBuilder;

  /// The builder that will build transition widgets.
  final WidgetBuilder transitionBuilder;

  /// Create state for this widget.
  @override
  TimedTransitionsState createState() => TimedTransitionsState();
}

/// State for [TimedTransitions].
class TimedTransitionsState extends State<TimedTransitions> {
  /// The timer to use.
  Timer? _transitionTimer;

  /// The current builder.
  late WidgetBuilder _builder;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _builder = (final context) => widget.initialBuilder(context, transition);
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _transitionTimer?.cancel();
  }

  /// Perform a transition.
  ///
  /// Note: Only the most recent call to [transition] will actually do anything,
  /// as calling [transition] cancels the timer.
  void transition(
    final Duration duration,
    final WidgetBuilder builder,
  ) {
    _transitionTimer?.cancel();
    _transitionTimer = null;
    setState(() => _builder = widget.transitionBuilder);
    _transitionTimer = Timer(duration, () {
      _transitionTimer = null;
      if (mounted) {
        setState(() => _builder = builder);
      }
    });
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => Builder(builder: _builder);
}
