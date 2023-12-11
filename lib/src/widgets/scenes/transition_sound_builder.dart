import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import 'timed_builders.dart';

/// A screen for transitioning to [builder] while playing [sound].
class TransitionSoundBuilder extends StatelessWidget {
  /// Create an instance.
  const TransitionSoundBuilder({
    required this.duration,
    required this.builder,
    required this.sound,
    required this.source,
    required this.loadingBuilder,
    this.gain = 0.7,
    super.key,
  });

  /// How long until [builder] should be built.
  final Duration duration;

  /// The builder to build after [duration].
  final WidgetBuilder builder;

  /// The sound to play.
  final String sound;

  /// The source to play [sound] through.
  final Source source;

  /// The builder which will build the loading screen.
  final WidgetBuilder loadingBuilder;

  /// The gain of [sound].
  final double gain;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => TimedBuilders(
        duration: duration,
        builders: [
          (final innerContext) {
            innerContext.playSound(
              assetPath: sound,
              source: source,
              destroy: true,
              gain: gain,
            );
            return Builder(builder: loadingBuilder);
          },
          builder,
        ],
      );
}
