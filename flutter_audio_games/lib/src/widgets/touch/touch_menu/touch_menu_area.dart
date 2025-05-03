import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_audio_games/touch.dart';

/// A touch area which reports back to a [TouchMenu].
class TouchMenuArea extends StatelessWidget {
  /// Create an instance.
  const TouchMenuArea({
    required this.onDoubleTap,
    required this.onPan,
    super.key,
  });

  /// The function to call when this area is double tapped.
  final VoidCallback onDoubleTap;

  /// The function to call when the cursor moves in this area.
  final void Function(Point<double> point) onPan;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => GestureDetector(
    onDoubleTap: onDoubleTap,
    onPanDown: (final details) => onMove(details.localPosition),
    onPanEnd: (final details) => onMove(details.localPosition),
    onPanUpdate: (final details) => onMove(details.localPosition),
  );

  /// The function to call with a new [offset].
  void onMove(final Offset offset) => onPan(Point(offset.dx, offset.dy));
}
