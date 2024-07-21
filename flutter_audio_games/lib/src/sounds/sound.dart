import 'package:flutter_soloud/flutter_soloud.dart';

import 'sound_position.dart';
import 'sound_type.dart';

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
    final bool? destroy,
    final double? volume,
    final bool? looping,
    final Duration? loopingStart,
    final bool? paused,
    final SoundPosition? position,
  }) =>
      Sound(
        path: path,
        soundType: soundType,
        destroy: destroy ?? this.destroy,
        volume: volume ?? this.volume,
        looping: looping ?? this.looping,
        loopingStart: loopingStart ?? this.loopingStart,
        paused: paused ?? this.paused,
        position: position ?? this.position,
      );
}
