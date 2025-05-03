import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A [Sound] from a wave form.
class SoundWave extends Sound {
  /// Create an instance.
  const SoundWave({
    required this.waveForm,
    required this.superWave,
    required this.scale,
    required this.detune,
    required super.destroy,
    super.looping,
    super.volume,
    super.loopingStart,
    super.paused,
    super.position,
    super.relativePlaySpeed,
  });

  /// The type of wave to create.
  final WaveForm waveForm;

  /// Whether this wave is a super wave.
  final bool superWave;

  /// The scale to use.
  final double scale;

  /// The detune to use.
  final double detune;

  /// Copy this instance.
  @override
  SoundWave copyWith({
    final WaveForm? waveForm,
    final bool? superWave,
    final double? scale,
    final double? detune,
    final bool? destroy,
    final double? volume,
    final bool? looping,
    final Duration? loopingStart,
    final SoundPosition? position,
    final bool? paused,
    final double? relativePlaySpeed,
  }) => SoundWave(
    waveForm: waveForm ?? this.waveForm,
    superWave: superWave ?? this.superWave,
    scale: scale ?? this.scale,
    detune: detune ?? this.detune,
    destroy: destroy ?? this.destroy,
    volume: volume ?? this.volume,
    looping: looping ?? this.looping,
    loopingStart: loopingStart ?? this.loopingStart,
    position: position ?? this.position,
    paused: paused ?? this.paused,
    relativePlaySpeed: relativePlaySpeed ?? this.relativePlaySpeed,
  );

  /// Return a string representation of this wave.
  @override
  String get internalUri => '${waveForm.name}:$superWave:$scale:$detune';

  /// Create an audio source.
  @override
  Future<AudioSource> load() =>
      SoLoud.instance.loadWaveform(waveForm, superWave, scale, detune);
}
