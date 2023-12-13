import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import 'music.dart';

/// A widget that possibly plays music through [source].
class MaybeMusic extends StatelessWidget {
  /// Create an instance.
  const MaybeMusic({
    required this.assetPath,
    required this.source,
    required this.builder,
    this.gain = 0.7,
    this.fadeInLength,
    this.fadeOutLength,
    super.key,
  });

  /// The asset path to play.
  ///
  /// If [assetPath] is `null`, then no music will be played.
  final String? assetPath;

  /// The source to play the music through.
  final Source source;

  /// The widget below this one in the tree.
  final WidgetBuilder builder;

  /// The fade in length to use.
  final double? fadeInLength;

  /// The fade out length to use.
  final double? fadeOutLength;

  /// The gain to use.
  final double gain;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final path = assetPath;
    if (path != null) {
      return Music(
        assetPath: path,
        source: source,
        gain: gain,
        fadeInLength: fadeInLength,
        fadeOutLength: fadeOutLength,
        child: Builder(builder: builder),
      );
    }
    return Builder(builder: builder);
  }
}
