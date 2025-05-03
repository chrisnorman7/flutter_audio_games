import 'dart:io';

import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:path/path.dart' as p;

/// Useful extensions to turn [Directory] instances into [Sound]s.
extension DirectoryX on Directory {
  /// Create a sound from a file in `this` directory.
  SoundFromFile asSound({
    required final bool destroy,
    final double volume = 0.7,
    final bool looping = false,
    final Duration loopingStart = Duration.zero,
    final SoundPosition position = unpanned,
    final bool paused = false,
    final LoadMode loadMode = LoadMode.memory,
    final double relativePlaySpeed = 1.0,
    final List<String> audioFileExtensions = const ['.mp3', '.wav'],
  }) {
    final files =
        listSync()
            .whereType<File>()
            .where(
              (final file) =>
                  audioFileExtensions.contains(p.extension(file.path)),
            )
            .toList();
    if (files.isEmpty) {
      throw StateError('Empty directory found at $path.');
    }
    final file = files.randomElement();
    return file.asSound(
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
}
