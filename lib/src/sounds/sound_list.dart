import 'dart:math';

import 'package:flutter_synthizer/flutter_synthizer.dart';

import '../extensions.dart';
import 'sound.dart';

/// A class which provides a list of [paths] to choose a sound from.
///
/// To get a single sound, use the [getSound] method.
class SoundList {
  /// Create an instance.
  const SoundList({
    required this.paths,
    required this.pathType,
    this.gain = 0.7,
  });

  /// The asset paths to choose from.
  final List<String> paths;

  /// The type of [paths].
  final PathType pathType;

  /// The gain to play the sound at.
  ///
  /// This value is used by [getSound] to determine the gain for the new sound.
  final double gain;

  /// Get a single sound.
  Sound getSound({final Random? random}) => Sound(
        bufferReference: BufferReference(
          path: paths.randomElement(random ?? Random()),
          pathType: pathType,
        ),
      );
}
