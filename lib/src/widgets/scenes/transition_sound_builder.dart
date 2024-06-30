import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../sounds/loaded_sound.dart';

/// A screen for transitioning to [builder] while playing [sound].
class TransitionSoundBuilder extends StatelessWidget {
  /// Create an instance.
  const TransitionSoundBuilder({
    required this.builder,
    required this.sound,
    required this.loadingBuilder,
    this.duration,
    super.key,
  });

  /// How long until [builder] should be built.
  ///
  /// If [duration] is `null`, then the length of [sound] will be used.
  final Duration? duration;

  /// The builder to build after [duration].
  final WidgetBuilder builder;

  /// The sound to play.
  final LoadedSound sound;

  /// The builder which will build the loading screen.
  final Widget Function() loadingBuilder;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => TimedBuilders(
        duration: duration ?? SoLoud.instance.getLength(sound.source),
        builders: [
          (final innerContext) {
            sound.play(destroy: true);
            return loadingBuilder();
          },
          builder,
        ],
      );
}
