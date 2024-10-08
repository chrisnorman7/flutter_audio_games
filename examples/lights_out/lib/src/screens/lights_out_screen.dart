import 'dart:math';

import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';

import '../widgets/square_widget.dart';

/// The lights out screen.
class LightsOutScreen extends StatefulWidget {
  /// Create an instance.
  const LightsOutScreen({
    this.gridSize = 5,
    this.tileSize = 50.0,
    this.initialPlayerPoints = 1000,
    super.key,
  });

  /// The size of the grid.
  final int gridSize;

  /// The size of each tile in pixels.
  final double tileSize;

  /// The points the player will start with.
  final int initialPlayerPoints;

  /// Create state for this widget.
  @override
  LightsOutScreenState createState() => LightsOutScreenState();
}

/// State for [LightsOutScreen].
class LightsOutScreenState extends State<LightsOutScreen> {
  /// The player's points.
  late int points;

  /// The light values.
  late final List<List<bool>> lights;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    points = widget.initialPlayerPoints;
    lights = [
      for (var y = 0; y < widget.gridSize; y++)
        [for (var x = 0; x < widget.gridSize; x++) false],
    ];
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => SimpleScaffold(
        title: 'Lights Out',
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Focus(
              autofocus: true,
              child: Center(
                child: Text(
                  'Points: $points',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            Expanded(
              child: SquareWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var y = 0; y < widget.gridSize; y++)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var x = 0; x < widget.gridSize; x++)
                            Builder(
                              builder: (final context) {
                                final point = Point(x, y);
                                final lit = lightAt(point);
                                return Checkbox(
                                  value: lit,
                                  onChanged: (final _) => toggleLight(point),
                                  activeColor: Colors.white,
                                  checkColor: Colors.white,
                                  semanticLabel: '${x + 1}, ${y + 1}',
                                  side: const BorderSide(
                                    color: Colors.blue,
                                    width: 5.0,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  /// Return the light value at the given [point].
  bool lightAt(final Point<int> point) => lights[point.y][point.x];

  /// Toggle the light at the given [point].
  void toggleLight(final Point<int> point) {
    final x = point.x;
    final y = point.y;
    for (final subPoint in [
      point,
      Point(x - 1, y),
      Point(x + 1, y),
      Point(x, y - 1),
      Point(x, y + 1),
    ]) {
      if (subPoint.x < 0 ||
          subPoint.x >= widget.gridSize ||
          subPoint.y < 0 ||
          subPoint.y >= widget.gridSize) {
        continue;
      }
      lights[subPoint.y][subPoint.x] = !lightAt(subPoint);
      points -= 10;
    }
    setState(() {});
  }
}
