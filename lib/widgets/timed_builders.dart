import 'dart:async';

import 'package:flutter/material.dart';

/// A widget which runs through [builders] every [duration].
class TimedBuilders extends StatefulWidget {
  /// Create an instance.
  const TimedBuilders({
    required this.duration,
    required this.builders,
    super.key,
  });

  /// The duration to wait between rebuilding.
  final Duration duration;

  /// The builders to cycle through.
  final List<WidgetBuilder> builders;

  /// Create state for this widget.
  @override
  TimedBuildersState createState() => TimedBuildersState();
}

/// State for [TimedBuilders].
class TimedBuildersState extends State<TimedBuilders> {
  /// The index of the current builder.
  late int index;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    index = 0;
    if (widget.builders.isEmpty) {
      throw StateError('The `builders` list cannot be empty.');
    }
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final builder = widget.builders[index];
    if (index < (widget.builders.length - 1)) {
      Timer(widget.duration, () => setState(() => index++));
    }
    return Builder(builder: builder);
  }
}
