import 'package:dart_synthizer/dart_synthizer.dart';

import 'ambiances.dart';

/// An ambiance to play in an [Ambiances] widget.
class Ambiance {
  /// Create an instance.
  const Ambiance({
    required this.assetPath,
    this.gain = 0.7,
  });

  /// The sound to play.
  final String assetPath;

  /// The gain of this ambiance.
  ///
  /// [gain] will be applied to the [BufferGenerator] which is created by the
  /// [Ambiances] widget.
  final double gain;
}
