import 'dart:typed_data';

import 'package:flutter_soloud/flutter_soloud.dart';

/// Useful methods for sources.
extension AudioSourceX on AudioSource {
  /// Returns the number of concurrent sounds that are playing from this source.
  int get countSounds => SoLoud.instance.countAudioSource(this);

  /// Dispose of this source.
  Future<void> dispose() => SoLoud.instance.disposeSource(this);

  /// Get the length of this source.
  Duration get length => SoLoud.instance.getLength(this);

  /// Set the waveform for this source.
  set waveform(final WaveForm newWaveform) =>
      SoLoud.instance.setWaveform(this, newWaveform);

  /// Set the waveform detune for this sound.
  set waveformDetune(final double detune) =>
      SoLoud.instance.setWaveformDetune(this, detune);

  /// Set the waveform frequency.
  set waveformFreq(final double frequency) =>
      SoLoud.instance.setWaveformFreq(this, frequency);

  /// Set the waveform scale.
  set waveformScale(final double scale) =>
      SoLoud.instance.setWaveformScale(this, scale);

  /// Set whether this source represents a super wave.
  set superwave(final bool superwave) =>
      SoLoud.instance.setWaveformSuperWave(this, superwave);

  /// Add PCM audio data to the stream.
  void addAudioDataStream(final Uint8List audioChunk) =>
      SoLoud.instance.addAudioDataStream(this, audioChunk);

  /// Get the current buffer size in bytes of this sound.
  int get size => SoLoud.instance.getBufferSize(this);
}
