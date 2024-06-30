import 'package:flutter_soloud/flutter_soloud.dart';

import 'scene_builder_ambiance.dart';

/// Hold context for [sceneBuilderAmbiance].
class SceneBuilderAmbianceContext {
  /// Create an instance.
  const SceneBuilderAmbianceContext({
    required this.sceneBuilderAmbiance,
    required this.handle,
  });

  /// The ambiance to represent.
  final SceneBuilderAmbiance sceneBuilderAmbiance;

  /// The sound handle to use.
  final SoundHandle handle;
}
