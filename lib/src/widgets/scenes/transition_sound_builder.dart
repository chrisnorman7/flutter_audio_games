import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../../extensions.dart';
import '../../sounds/sound.dart';

/// A screen for transitioning to [builder] while playing [sound].
class TransitionSoundBuilder extends StatelessWidget {
  /// Create an instance.
  const TransitionSoundBuilder({
    required this.duration,
    required this.builder,
    required this.sound,
    required this.source,
    required this.loadingBuilder,
    super.key,
  });

  /// How long until [builder] should be built.
  final Duration duration;

  /// The builder to build after [duration].
  final WidgetBuilder builder;

  /// The sound to play.
  final Sound sound;

  /// The source to play [sound] through.
  final Source source;

  /// The builder which will build the loading screen.
  final WidgetBuilder loadingBuilder;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => TimedBuilders(
        duration: duration,
        builders: [
          (final innerContext) {
            innerContext.playSound(
              sound: sound,
              source: source,
              destroy: true,
            );
            return Builder(builder: loadingBuilder);
          },
          builder,
        ],
      );
}
