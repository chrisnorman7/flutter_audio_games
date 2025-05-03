import 'dart:io' show File;

import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// Useful methods to turn [File]s into [Sound]s.
extension FileX on File {
  /// Create a sound from `this` file.
  SoundFromFile asSound({
    required final bool destroy,
    final double volume = 0.7,
    final bool looping = false,
    final Duration loopingStart = Duration.zero,
    final SoundPosition position = unpanned,
    final bool paused = false,
    final LoadMode loadMode = LoadMode.memory,
    final double relativePlaySpeed = 1.0,
  }) => SoundFromFile(
    file: this,
    destroy: destroy,
    loadMode: loadMode,
    looping: looping,
    loopingStart: loopingStart,
    paused: paused,
    position: position,
    volume: volume,
    relativePlaySpeed: relativePlaySpeed,
  );
}
