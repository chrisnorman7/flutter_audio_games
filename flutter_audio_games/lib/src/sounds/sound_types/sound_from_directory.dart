import 'dart:io';

import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A random [Sound] from [directory].
class SoundFromDirectory extends LoadableSound {
  /// Create an instance.
  const SoundFromDirectory({
    required this.directory,
    required super.destroy,
    super.loadMode,
    super.looping,
    super.loopingStart,
    super.paused,
    super.position,
    super.volume,
    super.relativePlaySpeed,
  });

  /// The directory to load from.
  final Directory directory;

  /// Allow sounds to be copied.
  @override
  SoundFromDirectory copyWith({
    final Directory? directory,
    final LoadMode? loadMode,
    final double? volume,
    final bool? looping,
    final Duration? loopingStart,
    final SoundPosition? position,
    final bool? paused,
    final double? relativePlaySpeed,
  }) =>
      SoundFromDirectory(
        directory: directory ?? this.directory,
        destroy: destroy,
        loadMode: loadMode ?? this.loadMode,
        looping: looping ?? this.looping,
        loopingStart: loopingStart ?? this.loopingStart,
        paused: paused ?? this.paused,
        position: position ?? this.position,
        volume: volume ?? this.volume,
        relativePlaySpeed: relativePlaySpeed ?? this.relativePlaySpeed,
      );

  /// Return the path of [directory].
  @override
  String get internalUri => directory.path;

  /// Load a single file.
  @override
  Future<AudioSource> load() {
    final sound = directory.asSound(
      destroy: destroy,
      loadMode: loadMode,
    );
    return sound.load();
  }
}
