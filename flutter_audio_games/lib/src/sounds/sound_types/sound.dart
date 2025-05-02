import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A single sound to play.
abstract class Sound {
  /// Create an instance.
  const Sound({
    required this.destroy,
    this.volume = 0.7,
    this.looping = false,
    this.loopingStart = Duration.zero,
    this.position = unpanned,
    this.paused = false,
    this.relativePlaySpeed = 1.0,
  });

  /// The volume to play at.
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

  /// The playback rate to use.
  final double relativePlaySpeed;

  /// The internal URI which refers to this sound.
  String get internalUri;

  /// Load an [AudioSource] from `this` [Sound].
  Future<AudioSource> load();

  /// Return a new copy of this sound with the provided settings.
  Sound copyWith({
    final bool? destroy,
    final double? volume,
    final bool? looping,
    final Duration? loopingStart,
    final SoundPosition? position,
    final bool? paused,
    final double? relativePlaySpeed,
  });
}
