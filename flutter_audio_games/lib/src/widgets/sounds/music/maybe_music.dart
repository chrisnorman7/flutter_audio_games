import 'package:backstreets_widgets/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

/// A widget that possibly plays music.
class MaybeMusic extends StatelessWidget {
  /// Create an instance.
  const MaybeMusic({
    required this.music,
    required this.child,
    required this.error,
    required this.loading,
    this.fadeInTime,
    this.fadeOutTime,
    super.key,
  });

  /// The music to possibly play.
  ///
  /// If [music] is `null`, then no music will be played.
  final Sound? music;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The function to call to show an error widget.
  final ErrorWidgetCallback error;

  /// The function to call to show a loading widget.
  final Widget Function() loading;

  /// The fade in length to use.
  final Duration? fadeInTime;

  /// The fade out length to use.
  final Duration? fadeOutTime;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final sound = music;
    if (sound != null) {
      return Music(
        sound: sound,
        fadeInTime: fadeInTime,
        fadeOutTime: fadeOutTime,
        error: error,
        loading: loading,
        child: child,
      );
    }
    return child;
  }
}
