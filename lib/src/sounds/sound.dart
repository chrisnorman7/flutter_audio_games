import 'sound_position.dart';
import 'sound_type.dart';

/// A single sound to play.
class Sound {
  /// Create an instance.
  const Sound({
    required this.path,
    required this.soundType,
    required this.destroy,
    this.gain = 0.7,
    this.looping = false,
    this.loopingStart = Duration.zero,
    this.paused = false,
    this.position = unpanned,
  });

  /// The asset path to use.
  final String path;

  /// The type of the sound to play.
  final SoundType soundType;

  /// The gain to play [path] at.
  final double gain;

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

  /// Get a hash code which can safely be used to check equality.
  @override
  int get hashCode => '$path${soundType.name}'.hashCode;

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
    final double? gain,
    final bool? looping,
    final Duration? loopingStart,
    final bool? paused,
    final SoundPosition? position,
  }) =>
      Sound(
        path: path,
        soundType: soundType,
        destroy: destroy ?? this.destroy,
        gain: gain ?? this.gain,
        looping: looping ?? this.looping,
        loopingStart: loopingStart ?? this.loopingStart,
        paused: paused ?? this.paused,
        position: position ?? this.position,
      );
}
