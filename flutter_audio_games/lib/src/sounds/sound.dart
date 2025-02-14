import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A single sound to play.
class Sound {
  /// Create an instance.
  const Sound({
    required this.path,
    required this.soundType,
    required this.destroy,
    this.volume = 0.7,
    this.looping = false,
    this.loopingStart = Duration.zero,
    this.position = unpanned,
    this.paused = false,
    this.loadMode = LoadMode.memory,
    this.relativePlaySpeed = 1.0,
  });

  /// The asset path to use.
  final String path;

  /// The type of the sound to play.
  final SoundType soundType;

  /// The volume to play [path] at.
  final double volume;

  /// Whether or not this sound should be destroyed after playing.
  final bool destroy;

  /// Whether this sound should loop.
  final bool looping;

  /// The point where this sound should start loading.
  final Duration loopingStart;

  /// The position for this sound.
  final SoundPosition position;

  /// Whether this sound should start paused.
  final bool paused;

  /// The mode to use when loading this sound.
  final LoadMode loadMode;

  /// The playback rate to use.
  final double relativePlaySpeed;

  /// Get a hash code which can safely be used to check equality.
  @override
  int get hashCode => internalUri.hashCode;

  /// Get an internal URI for this sound.
  ///
  /// The only value of [internalUri] is to generate a suitable [hashCode], and
  /// for pretty printing.
  String get internalUri => '${soundType.name}: $path';

  @override
  bool operator ==(final Object other) {
    if (other is Sound) {
      return other.path == path && other.soundType == soundType;
    }
    return super == other;
  }

  /// Copy this sound to a new instance.
  Sound copyWith({
    final String? path,
    final bool? destroy,
    final SoundType? soundType,
    final double? volume,
    final bool? looping,
    final Duration? loopingStart,
    final SoundPosition? position,
    final bool? paused,
    final LoadMode? loadMode,
    final double? relativePlaySpeed,
  }) =>
      Sound(
        path: path ?? this.path,
        soundType: soundType ?? this.soundType,
        destroy: destroy ?? this.destroy,
        volume: volume ?? this.volume,
        looping: looping ?? this.looping,
        loopingStart: loopingStart ?? this.loopingStart,
        position: position ?? this.position,
        paused: paused ?? this.paused,
        loadMode: loadMode ?? this.loadMode,
        relativePlaySpeed: relativePlaySpeed ?? this.relativePlaySpeed,
      );
}
