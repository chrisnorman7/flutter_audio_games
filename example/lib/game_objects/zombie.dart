import 'dart:math';

import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A zombie in the game.
class Zombie {
  /// Create an instance.
  Zombie({
    required this.coordinates,
    required this.ambiance,
    required this.ambianceHandle,
    required this.saying,
    required this.hitPoints,
  });

  /// The position of this zombie.
  Point<double> coordinates;

  /// The ambiance of this zombie.
  final LoadedSound ambiance;

  /// The handle to use for the [ambiance].
  final SoundHandle ambianceHandle;

  /// The sound this zombie will emit.
  final LoadedSound saying;

  /// The hit points of this zombie.
  int hitPoints;

  /// Move this zombie to the [newCoordinates].
  void move(final Point<double> newCoordinates) {
    coordinates = newCoordinates;
    SoLoud.instance.set3dSourcePosition(
      ambianceHandle,
      newCoordinates.x,
      newCoordinates.y,
      0,
    );
  }

  /// Destroy this zombie.
  void destroy() {
    ambianceHandle.stop();
  }

  /// Play a sound.
  Future<SoundHandle> playSound({
    required final LoadedSound sound,
    required final bool destroy,
    final bool looping = false,
  }) =>
      sound.play3d(
        destroy: destroy,
        looping: looping,
        x: coordinates.x,
        y: coordinates.y,
      );
}
