import 'dart:math';

import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/touch.dart';

/// A surface which is split into distinct touch surfaces.
class TouchSurface extends StatelessWidget {
  /// Create an instance.
  const TouchSurface({
    required this.rows,
    required this.columns,
    required this.onTouch,
    this.canPop = false,
    this.areaDescriptions = const {},
    this.areaShortcuts = const {},
    this.childBuilder,
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

  /// Area shortcut keys.
  final Map<GameShortcutsShortcut, Point<int>> areaShortcuts;

  /// The function to call to build [TouchArea] children.
  final Widget Function(BuildContext context, Point<int> point)? childBuilder;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => GameShortcuts(
    shortcuts:
        areaShortcuts.entries.map((final entry) {
          final shortcut = entry.key;
          final point = entry.value;
          return GameShortcut(
            title: areaDescriptions[point] ?? '${point.x}, ${point.y}',
            shortcut: shortcut,
            onStart:
                (final innerContext) => onTouch(point, TouchAreaEvent.touch),
            onStop:
                (final innerContext) => onTouch(point, TouchAreaEvent.release),
          );
        }).toList(),
    child: PopScope(
      canPop: canPop,
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var y = 0; y < rows; y++)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var x = 0; x < columns; x++)
                      TouchArea(
                        description: areaDescriptions[Point(x, y)] ?? '$x, $y',
                        onTouch: (final event) {
                          final point = Point(x, y);
                          onTouch(point, event);
                        },
                        child: childBuilder?.call(context, Point(x, y)),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
