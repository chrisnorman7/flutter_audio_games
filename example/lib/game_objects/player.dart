import 'dart:math';

import 'package:flutter_audio_games/flutter_audio_games.dart';

/// The player object.
class Player {
  /// Create an instance.
  Player({
    this.coordinates = const Point(0.0, 0.0),
    this.heading = 0.0,
    this.hitPoints = 100,
    this.movingDirection,
    this.turningDirection,
  });

  /// The current player coordinates.
  Point<double> coordinates;

  /// The current direction of travel.
  double heading;

  /// The player's hit points.
  int hitPoints;

  /// What direction the player is moving in.
  MovingDirection? movingDirection;

  /// What direction the player is turning in.
  TurningDirection? turningDirection;
}
