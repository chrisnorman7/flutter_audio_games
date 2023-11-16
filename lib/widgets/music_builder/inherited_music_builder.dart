import 'package:flutter/material.dart';

import 'music_builder.dart';

/// The inherited version of a [MusicBuilder].
class InheritedMusicBuilder extends InheritedWidget {
  /// Create an instance.
  const InheritedMusicBuilder({
    required this.fadeIn,
    required this.fadeOut,
    required this.setPlaybackPosition,
    required super.child,
    super.key,
  });

  /// The function to fade in the music.
  final VoidCallback fadeIn;

  /// The function to fade out the music.
  final VoidCallback fadeOut;

  /// The function to call to set the playback position.
  final ValueChanged<double> setPlaybackPosition;
  @override
  bool updateShouldNotify(covariant final InheritedMusicBuilder oldWidget) =>
      fadeIn != oldWidget.fadeIn || fadeOut != oldWidget.fadeOut;
}
