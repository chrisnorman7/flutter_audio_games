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
  Widget build(BuildContext context) => GestureDetector(
    onDoubleTap: onDoubleTap,
    onPanDown: (details) => onMove(details.localPosition),
    onPanEnd: (details) => onMove(details.localPosition),
    onPanUpdate: (details) => onMove(details.localPosition),
  );

  /// The function to call with a new [offset].
  void onMove(Offset offset) => onPan(Point(offset.dx, offset.dy));
}
