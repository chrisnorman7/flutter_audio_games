import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../play_sound.dart';
import '../timed_builders.dart';

/// A cut scene.
class CutScene extends StatelessWidget {
  /// Create an instance.
  const CutScene({
    required this.sceneTitle,
    required this.sceneText,
    required this.duration,
    required this.builder,
    this.assetPath,
    this.source,
    this.gain = 0.7,
    super.key,
  });

  /// The asset path to play for the scene.
  final String? assetPath;

  /// The source to play [assetPath] through.
  final Source? source;

  /// The gain to play [assetPath] at.
  final double gain;

  /// The title of the scene.
  final String sceneTitle;

  /// The text of the scene.
  final String sceneText;

  /// How long to wait before pushing the [builder].
  final Duration duration;

  /// The widget to build after the scene has played out.
  final WidgetBuilder builder;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => TimedBuilders(
        duration: duration,
        builders: [
          (final context) {
            final a = assetPath;
            final s = source;
            final scaffold = Scaffold(
              appBar: AppBar(
                title: Text(sceneTitle),
              ),
              body: Focus(
                autofocus: true,
                child: Center(
                  child: Text(sceneText),
                ),
              ),
            );
            if (a == null || s == null) {
              return scaffold;
            } else {
              return PlaySound(
                assetPath: a,
                source: s,
                gain: gain,
                child: scaffold,
              );
            }
          },
          builder,
        ],
      );
}
