import 'dart:math';

import 'package:flutter/material.dart';

import 'touch_area.dart';

/// A surface which is split into distinct touch surfaces.
class TouchSurface extends StatefulWidget {
  /// Create an instance.
  const TouchSurface({
    required this.rows,
    required this.columns,
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

  /// Allows the blocking of back gestures.
  final bool canPop;

  @override
  State<TouchSurface> createState() => _TouchSurfaceState();
}

class _TouchSurfaceState extends State<TouchSurface> {
  /// Build the widget.
  @override
  Widget build(final BuildContext context) => PopScope(
        canPop: widget.canPop,
        child: Material(
          child: Column(
            children: [
              for (var x = 0; x < widget.columns; x++)
                Expanded(
                  child: Row(
                    children: [
                      for (var y = 0; y < widget.rows; y++)
                        TouchArea(
                          description: '$x, $y',
                          onTouch: (final event) {
                            final point = Point(x, y);
                            switch (event) {
                              case TouchAreaEvent.touch:
                                widget.onStart?.call(point);
                              case TouchAreaEvent.release:
                                widget.onEnd?.call(point);
                            }
                          },
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
}
