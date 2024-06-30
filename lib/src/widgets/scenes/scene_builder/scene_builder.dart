import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../../extensions.dart';
import 'scene_builder_ambiance.dart';
import 'scene_builder_ambiance_context.dart';

/// A scene complete with 3d [ambiances],.
class SceneBuilder extends StatefulWidget {
  /// Create an instance.
  const SceneBuilder({
    required this.ambiances,
    required this.builder,
    this.sourceGain = 0.7,
    this.fadeInTime,
    this.fadeOutTime,
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
  final Duration? fadeInTime;

  /// The fade out time.
  final Duration? fadeOutTime;

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
      await ambianceContext.handle.stop();
    }
    ambianceContexts.clear();
    final fadeInTime = widget.fadeInTime;
    final soLoud = SoLoud.instance;
    final gain = widget.sourceGain;
    for (final ambiance in widget.ambiances) {
      final handle = await soLoud.play3d(
        ambiance.source,
        ambiance.x,
        ambiance.y,
        ambiance.z,
        looping: true,
        volume: fadeInTime == null ? gain : 0.0,
      );
      handle.maybeFade(
        fadeTime: fadeInTime,
        to: gain,
      );
      if (mounted) {
        ambianceContexts.add(
          SceneBuilderAmbianceContext(
            sceneBuilderAmbiance: ambiance,
            handle: handle,
          ),
        );
      } else {
        await handle.stop();
      }
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    for (final ambianceContext in ambianceContexts) {
      ambianceContext.handle.stop(fadeOutTime: widget.fadeOutTime);
    }
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final future = loadAmbiances();
    return SimpleFutureBuilder(
      future: future,
      done: (final futureBuilderContext, final value) => widget.builder(
        futureBuilderContext,
        ambianceContexts,
      ),
      loading: () => widget.builder(context, []),
      error: ErrorListView.withPositional,
    );
  }
}
