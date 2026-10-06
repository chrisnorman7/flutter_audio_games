import 'dart:io' show File;

import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// Useful methods to turn [File]s into [Sound]s.
extension FileX on File {
  /// Create a sound from `this` file.
  SoundFromFile asSound({
    required bool destroy,
    double volume = 0.7,
    bool looping = false,
    Duration loopingStart = Duration.zero,
    SoundPosition position = unpanned,
    bool paused = false,
    LoadMode loadMode = LoadMode.memory,
    double relativePlaySpeed = 1.0,
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
