import 'package:flutter/material.dart';

import 'music.dart';

/// The inherited version of a [Music].
///
/// Instances of [InheritedMusic] will be dealt with when using
/// [Music.maybeOf()] or [Music.of()].
class InheritedMusic extends InheritedWidget {
  /// Create an instance.
  const InheritedMusic({
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
  final ValueChanged<Duration> setPlaybackPosition;

  /// Whether to notify listeners.
  @override
  bool updateShouldNotify(covariant final InheritedMusic oldWidget) =>
      fadeIn != oldWidget.fadeIn ||
      fadeOut != oldWidget.fadeOut ||
      setPlaybackPosition != oldWidget.setPlaybackPosition;
}
