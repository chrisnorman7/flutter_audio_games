import 'dart:async';

import 'package:flutter/material.dart';

/// A widget which builds the next [WidgetBuilder] in [builders] every
/// [duration].
///
/// Instances of [TimedBuilders] are useful for cut scenes, and showing splash
/// screens before a main menu for example.
class TimedBuilders extends StatefulWidget {
  /// Create an instance.
  const TimedBuilders({
    required this.duration,
    required this.builders,
    super.key,
  });

  /// The duration to wait before building the next [WidgetBuilder] from
  /// [builders].
  final Duration duration;

  /// The builders to cycle through.
  ///
  /// A new [WidgetBuilder] from [builders] will be built every [duration].
  final List<WidgetBuilder> builders;

  /// Create state for this widget.
  @override
  TimedBuildersState createState() => TimedBuildersState();
}

/// State for [TimedBuilders].
class TimedBuildersState extends State<TimedBuilders> {
  /// The index of the current builder.
  late int _index;

  /// The timer to use.
  Timer? _timer;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _index = 0;
    if (widget.builders.isEmpty) {
      throw StateError('The `builders` list cannot be empty.');
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final builder = widget.builders[_index];
    if (_index < (widget.builders.length - 1)) {
      _timer = Timer(widget.duration, () => setState(() => _index++));
    }
    return Builder(builder: builder);
  }
}
