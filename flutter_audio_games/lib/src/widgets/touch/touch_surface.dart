import 'dart:math';

import 'package:flutter/material.dart';

/// A surface which is split into distinct touch surfaces.
class TouchSurface extends StatelessWidget {
  /// Create an instance.
  const TouchSurface({
    required this.rows,
    required this.columns,
    required this.onMove,
    required this.child,
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

  /// The function to call when the player moves around the screen.
  final void Function(Point<int> coordinates) onMove;

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
  Future<void> _onMove(final Offset position, final Size size) async {
    final x = (position.dx / size.width) * rows;
    final y = (position.dy / size.height) * columns;
    return onMove(Point(x.floor(), y.floor()));
  }
}
