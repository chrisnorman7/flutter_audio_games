import 'package:flutter/material.dart';

import '../flutter_audio_games.dart';

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
