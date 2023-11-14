import 'package:flutter/material.dart';

import '../widgets/music_builder/music_builder.dart';
import '../widgets/random_task_builder/random_task_builder.dart';
import '../widgets/ticking_builder/ticking_builder.dart';

/// Useful extensions on build contexts.
extension FlutterAudioGamesBuildExtensions on BuildContext {
  /// Pause and resume a [TickingBuilder] while pushing a widget [builder].
  Future<void> pauseTickingBuilderAndPushWidget(
    final WidgetBuilder builder,
  ) async {
    TickingBuilder.maybeOf(this)?.pause();
    await Navigator.of(this).push(MaterialPageRoute(builder: builder));
    TickingBuilder.maybeOf(this)?.resume();
  }

  /// Pause and resume a [RandomTaskBuilder] while pushing a widget [builder].
  Future<void> pauseRandomTaskBuilderAndPushWidget(
    final WidgetBuilder builder,
  ) async {
    RandomTaskBuilder.maybeOf(this)?.pause();
    await Navigator.of(this).push(MaterialPageRoute(builder: builder));
    RandomTaskBuilder.maybeOf(this)?.resume();
  }

  /// Push a widget [builder], fading any [MusicBuilder] out and back in again.
  Future<void> fadeMusicAndPushWidget(final WidgetBuilder builder) async {
    MusicBuilder.maybeOf(this)?.fadeOut();
    await Navigator.push(
      this,
      MaterialPageRoute(
        builder: builder,
      ),
    );
    MusicBuilder.maybeOf(this)?.fadeIn();
  }
}
