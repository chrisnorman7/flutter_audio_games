import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import '../../../extensions.dart';
import '../../../sounds/sound.dart';
import 'scene_builder_ambiance.dart';
import 'scene_builder_ambiance_context.dart';

/// A scene complete with 3d [ambiances],.
class SceneBuilder extends StatefulWidget {
  /// Create an instance.
  const SceneBuilder({
    required this.ambiances,
    required this.builder,
    this.sourceGain = 0.7,
    this.fadeIn,
    this.fadeOut,
    super.key,
  });

  /// The ambiances to use.
  final List<SceneBuilderAmbiance> ambiances;

  /// The builder to use.
  final Widget Function(
    BuildContext context,
    List<SceneBuilderAmbianceContext> ambiances,
  ) builder;

  /// The gain for each created source.
  final double sourceGain;

  /// The fade in time.
  final double? fadeIn;

  /// The fade out time.
  final double? fadeOut;

  /// Create state for this widget.
  @override
  SceneBuilderState createState() => SceneBuilderState();
}

/// State for [SceneBuilder].
class SceneBuilderState extends State<SceneBuilder> {
  /// The ambiances which have been created.
  late final List<SceneBuilderAmbianceContext> ambianceContexts;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    ambianceContexts = [];
  }

  /// Load the ambiances.
  Future<void> loadAmbiances() async {
    for (final ambianceContext in ambianceContexts) {
      ambianceContext.destroy();
    }
    ambianceContexts.clear();
    final fadeIn = widget.fadeIn;
    for (final ambiance in widget.ambiances) {
      if (mounted) {
        final source = context.synthizerContext.createSource3D(
          pannerStrategy: ambiance.pannerStrategy,
          x: ambiance.x,
          y: ambiance.y,
          z: ambiance.z,
        )
          ..gain.value = widget.sourceGain
          ..configDeleteBehavior(linger: true);
        final sound = fadeIn == null
            ? ambiance.sound
            : Sound(
                bufferReference: ambiance.sound.bufferReference,
                gain: 0.0,
              );
        final generator = await context.playSound(
          sound: sound,
          source: source,
          destroy: false,
          linger: true,
          looping: true,
        );
        generator.maybeFade(
          fadeLength: fadeIn,
          startGain: 0.0,
          endGain: ambiance.sound.gain,
        );
        if (mounted) {
          source.addGenerator(generator);
          ambianceContexts.add(
            SceneBuilderAmbianceContext(
              sceneBuilderAmbiance: ambiance,
              source: source,
              generator: generator,
            ),
          );
        } else {
          source.destroy();
          generator.destroy();
        }
      }
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    for (var i = 0; i < widget.ambiances.length; i++) {
      final ambiance = widget.ambiances[i];
      final ambianceContext = ambianceContexts[i];
      ambianceContext.generator.maybeFade(
        fadeLength: widget.fadeOut,
        startGain: ambiance.sound.gain,
        endGain: 0.0,
      );
      ambianceContext.destroy();
    }
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final future = loadAmbiances();
    return SimpleFutureBuilder(
      future: future,
      done: (final futureBuilderContext, final value) =>
          widget.builder(futureBuilderContext, ambianceContexts),
      loading: (final futureBuilderContext) =>
          widget.builder(futureBuilderContext, []),
      error: ErrorListView.withPositional,
    );
  }
}
