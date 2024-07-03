import 'dart:math';

import 'package:flutter/material.dart';

/// A surface which is split into distinct touch surfaces.
class TouchSurface extends StatelessWidget {
  /// Create an instance.
  const TouchSurface({
    required this.rows,
    required this.columns,
    required this.child,
    this.onStart,
    this.onEnd,
    this.canPop = false,
    super.key,
  }) : assert(
          columns > 0 && rows > 0,
          'Both `rows` and `columns` must be at least 1.',
        );

  /// The number of rows to use.
  final int rows;

  /// The number of columns to use.
  final int columns;

  /// The function to call when the player enters different parts of the screen.
  final void Function(Point<int> coordinates)? onStart;

  /// The function to call when the player lifts their finger or releases the
  /// mouse.
  final void Function(Point<int> coordinates)? onEnd;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Allows the blocking of back gestures.
  final bool canPop;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: canPop,
      child: GestureDetector(
        onPanDown: (final details) => _onMove(details.globalPosition, size),
        onPanUpdate: (final details) => _onMove(details.globalPosition, size),
        onPanEnd: (final details) => _onMove(details.globalPosition, size),
        child: child,
      ),
    );
  }

  /// The player is moving around the screen.
  Future<void> _onMove(
    final Offset position,
    final Size size, {
    final bool end = false,
  }) async {
    final x = (position.dx / size.width) * rows;
    final y = (position.dy / size.height) * columns;
    final point = Point(x.floor(), y.floor());
    if (end) {
      onEnd?.call(point);
    } else {
      onStart?.call(point);
    }
  }
}
