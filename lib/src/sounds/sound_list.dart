import 'dart:math';

import '../extensions.dart';
import 'sound.dart';
import 'sound_type.dart';

/// A class which provides a list of [paths] to choose a sound from.
///
/// To get a single sound, use the [getSound] method.
class SoundList {
  /// Create an instance.
  const SoundList({
    required this.paths,
    required this.soundType,
    this.gain = 0.7,
  });

  /// The asset paths to choose from.
  final List<String> paths;

  /// The type of [paths].
  final SoundType soundType;

  /// The gain to play the sound at.
  ///
  /// This value is used by [getSound] to determine the gain for the new sound.
  final double gain;

  /// Get a single sound.
  Sound getSound({final Random? random}) => Sound(
        path: paths.randomElement(random ?? Random()),
        soundType: soundType,
        gain: gain,
      );
}
