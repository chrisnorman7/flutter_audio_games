import 'dart:io';

import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A [Sound] loaded from [file].
class SoundFromFile extends LoadableSound {
  /// Create an instance.
  const SoundFromFile({
    required this.file,
    required super.destroy,
    super.loadMode,
    super.looping,
    super.loopingStart,
    super.paused,
    super.position,
    super.volume,
    super.relativePlaySpeed,
  });

  /// The file to load from.
  final File file;

  /// Allow sounds to be copied.
  @override
  SoundFromFile copyWith({
    final File? file,
    final LoadMode? loadMode,
    final double? volume,
    final bool? looping,
    final Duration? loopingStart,
    final SoundPosition? position,
    final bool? paused,
    final double? relativePlaySpeed,
  }) =>
      SoundFromFile(
        file: file ?? this.file,
        destroy: destroy,
        loadMode: loadMode ?? this.loadMode,
        looping: looping ?? this.looping,
        loopingStart: loopingStart ?? this.loopingStart,
        paused: paused ?? this.paused,
        position: position ?? this.position,
        volume: volume ?? this.volume,
        relativePlaySpeed: relativePlaySpeed ?? this.relativePlaySpeed,
      );

  /// Return the path of [file].
  @override
  String get internalUri => file.path;

  /// Load [file].
  @override
  Future<AudioSource> load() =>
      SoLoud.instance.loadFile(file.path, mode: loadMode);
}
