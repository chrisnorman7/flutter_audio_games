import 'dart:math';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

/// A zombie in the game.
class Zombie {
  /// Create an instance.
  Zombie({
    required this.coordinates,
    required this.source,
    required this.ambiance,
    required this.ambianceGenerator,
    required this.saying,
    required this.hitPoints,
  });

  /// The position of this zombie.
  Point<double> coordinates;

  /// The source to play sounds through.
  final Source3D source;

  /// The ambiance of this zombie.
  final Sound ambiance;

  /// The generator to use for the [ambiance].
  final BufferGenerator ambianceGenerator;

  /// The sound this zombie will emit.
  final Sound saying;

  /// The hit points of this zombie.
  int hitPoints;

  /// Move this zombie to the [newCoordinates].
  void move(final Point<double> newCoordinates) {
    coordinates = newCoordinates;
    source.position.value = Double3(newCoordinates.x, newCoordinates.y, 0.0);
  }

  /// Destroy this zombie.
  void destroy() {
    ambianceGenerator.destroy();
    source.destroy();
  }
}
