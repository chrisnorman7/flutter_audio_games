import 'dart:math';

import '../extensions.dart';
import 'sound.dart';

/// A class which provides a list of [assetPaths] to choose a sound from.
///
/// To get a single sound, use the [getSound] method.
class SoundList {
  /// Create an instance.
  const SoundList({
    required this.assetPaths,
    this.gain = 0.7,
  });

  /// The asset paths to choose from.
  final List<String> assetPaths;

  /// The gain to play the sound at.
  ///
  /// This value is used by [getSound] to determine the gain for the new sound.
  final double gain;

  /// Get a single sound.
  Sound getSound({final Random? random}) =>
      Sound(assetPath: assetPaths.randomElement(random ?? Random()));
}
