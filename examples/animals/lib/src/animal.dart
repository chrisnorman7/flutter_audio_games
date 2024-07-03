import 'dart:math';

import 'package:flutter_soloud/flutter_soloud.dart';

/// An animal in the game.
class Animal {
  /// Create an instance.
  Animal({
    required this.coordinates,
    required this.soundHandle,
  });

  /// The coordinates of this animal.
  Point<double> coordinates;

  /// The sound of this animal.
  final SoundHandle soundHandle;
}
