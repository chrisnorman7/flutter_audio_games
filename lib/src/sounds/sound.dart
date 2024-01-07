import 'package:flutter_synthizer/flutter_synthizer.dart';

/// A single sound to play.
class Sound {
  /// Create an instance.
  const Sound({
    required this.bufferReference,
    this.gain = 0.7,
  });

  /// The asset path to use.
  final BufferReference bufferReference;

  /// The gain to play [bufferReference] at.
  final double gain;
}
