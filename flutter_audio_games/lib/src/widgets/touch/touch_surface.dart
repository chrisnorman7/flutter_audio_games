import 'dart:math';

import 'package:flutter/material.dart';

import 'touch_area.dart';

/// A surface which is split into distinct touch surfaces.
class TouchSurface extends StatelessWidget {
  /// Create an instance.
  const TouchSurface({
    required this.rows,
    required this.columns,
    required this.onTouch,
    this.canPop = false,
    this.areaDescriptions = const {},
    super.key,
  }) : assert(
          columns > 0 && rows > 0,
          'Both `rows` and `columns` must be at least 1.',
        );

  /// The number of rows to use.
  final int rows;

  /// The number of columns to use.
  final int columns;

  /// The function to call when the player touches or releases different parts
  /// of the screen.
  final void Function(Point<int> coordinates, TouchAreaEvent event) onTouch;

  /// Allows the blocking of back gestures.
  final bool canPop;

  /// The description for areas on this surface.
  final Map<Point<int>, String> areaDescriptions;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => PopScope(
        canPop: canPop,
        child: Material(
          child: Column(
            children: [
              for (var x = 0; x < columns; x++)
                Expanded(
                  child: Row(
                    children: [
                      for (var y = 0; y < rows; y++)
                        TouchArea(
                          description:
                              areaDescriptions[Point(x, y)] ?? '$x, $y',
                          onTouch: (final event) {
                            final point = Point(x, y);
                            onTouch(point, event);
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
