import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../../../sounds/sound.dart';
import 'music.dart';

/// A widget that possibly plays music through [source].
class MaybeMusic extends StatelessWidget {
  /// Create an instance.
  const MaybeMusic({
    required this.music,
    required this.source,
    required this.builder,
    this.fadeInLength,
    this.fadeOutLength,
    super.key,
  });

  /// The music to possibly play.
  ///
  /// If [music] is `null`, then no music will be played.
  final Sound? music;

  /// The source to play the music through.
  final Source source;

  /// The widget below this one in the tree.
  final WidgetBuilder builder;

  /// The fade in length to use.
  final double? fadeInLength;

  /// The fade out length to use.
  final double? fadeOutLength;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final sound = music;
    if (sound != null) {
      return Music(
        music: sound,
        source: source,
        fadeInLength: fadeInLength,
        fadeOutLength: fadeOutLength,
        child: Builder(builder: builder),
      );
    }
    return Builder(builder: builder);
  }
}
