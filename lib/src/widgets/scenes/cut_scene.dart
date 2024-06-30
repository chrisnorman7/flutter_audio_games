import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../../sounds/sound.dart';
import '../sounds/play_sound.dart';

/// A cut scene.
class CutScene extends StatelessWidget {
  /// Create an instance.
  const CutScene({
    required this.sceneTitle,
    required this.sceneText,
    required this.duration,
    required this.builder,
    this.sound,
    this.source,
    super.key,
  });

  /// The sound to play for the scene.
  final Sound? sound;

  /// The source to play [sound] through.
  final Source? source;

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
            final a = sound;
            final s = source;
            final scaffold = SimpleScaffold(
              title: sceneTitle,
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
                sound: a,
                source: s,
                child: scaffold,
              );
            }
          },
          builder,
        ],
      );
}
