import 'package:flutter_soloud/flutter_soloud.dart';

import 'scene_builder.dart';

/// An ambiance in a [SceneBuilder].
class SceneBuilderAmbiance {
  /// Create an instance.
  const SceneBuilderAmbiance({
    required this.source,
    this.x = 0.0,
    this.y = 0.0,
    this.z = 0.0,
  });

  /// The sound to use.
  final AudioSource source;

  /// The x coordinate to use.
  final double x;

  /// The y coordinate of the sound.
  final double y;

  /// The z coordinate of the sound.
  final double z;
}
