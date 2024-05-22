import 'package:dart_synthizer/dart_synthizer.dart';

import 'scene_builder_ambiance.dart';

/// Hold context for [sceneBuilderAmbiance].
class SceneBuilderAmbianceContext {
  /// Create an instance.
  const SceneBuilderAmbianceContext({
    required this.sceneBuilderAmbiance,
    required this.source,
    required this.generator,
  });

  /// The ambiance to represent.
  final SceneBuilderAmbiance sceneBuilderAmbiance;

  /// The source to use.
  final Source3D source;

  /// The buffer generator to use.
  final BufferGenerator generator;

  /// Destroy this ambiance.
  void destroy() {
    generator.looping.value = false;
    for (final object in [generator, source]) {
      object
        ..configDeleteBehavior(linger: false)
        ..destroy();
    }
  }
}
