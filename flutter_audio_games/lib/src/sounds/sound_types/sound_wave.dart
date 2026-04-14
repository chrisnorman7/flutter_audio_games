import 'dart:math';

import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A [Sound] from a wave form.
class SoundWave extends Sound {
  /// Create an instance.
  const SoundWave({
    this.waveForm = WaveForm.sin,
    super.destroy = false,
    this.superWave = false,
    this.scale = 0.0,
    this.detune = 0.0,
    this.frequency = 440.0,
    super.looping,
    super.volume,
    super.loopingStart,
    super.paused,
    super.position,
    super.relativePlaySpeed,
  });

  /// Create an instance from a [midiNote].
  ///
  /// For example: 60 is middle C, 61 is C#, 62 is D, etc.
  SoundWave.romMidiNote({
    required final int midiNote,
    this.waveForm = WaveForm.sin,
    super.destroy = false,
    this.superWave = false,
    this.scale = 0.0,
    this.detune = 0.0,
    super.looping,
    super.volume,
    super.loopingStart,
    super.paused,
    super.position,
    super.relativePlaySpeed,
  }) : frequency = 440.0 * pow(2, (midiNote - 69) / 12.0);

  /// The type of wave to create.
  final WaveForm waveForm;

  /// Whether this wave is a super wave.
  final bool superWave;

  /// The scale to use.
  final double scale;

  /// The detune to use.
  final double detune;

  /// The frequency of the new wave.
  final double frequency;

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
  Future<AudioSource> load() async {
    final source = await SoLoud.instance.loadWaveform(
      waveForm,
      superWave,
      scale,
      detune,
    );
    SoLoud.instance.setWaveformFreq(source, frequency);
    return source;
  }
}
