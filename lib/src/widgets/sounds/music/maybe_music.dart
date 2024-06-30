import 'package:flutter/material.dart';

import '../../../sounds/loaded_sound.dart';
import 'music.dart';

/// A widget that possibly plays music.
class MaybeMusic extends StatelessWidget {
  /// Create an instance.
  const MaybeMusic({
    required this.music,
    required this.builder,
    this.fadeInTime,
    this.fadeOutTime,
    super.key,
  });

  /// The music to possibly play.
  ///
  /// If [music] is `null`, then no music will be played.
  final LoadedSound? music;

  /// The widget below this one in the tree.
  final WidgetBuilder builder;

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
        child: Builder(builder: builder),
      );
    }
    return Builder(builder: builder);
  }
}
