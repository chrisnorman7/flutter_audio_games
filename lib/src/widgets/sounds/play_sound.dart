import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../../extensions.dart';
import '../../sounds/sound.dart';
import 'music/music.dart';

/// A widget which plays a sound when built.
///
/// If you want a widget which plays a looping sound when built, consider the
/// [Music] widget.
class PlaySound extends StatefulWidget {
  /// Create an instance.
  const PlaySound({
    required this.sound,
    required this.source,
    required this.child,
    super.key,
  });

  /// The sound to play.
  final Sound sound;

  /// The source to play [sound] through.
  final Source source;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Create state for this widget.
  @override
  PlaySoundState createState() => PlaySoundState();
}

/// State for [PlaySound].
class PlaySoundState extends State<PlaySound> {
  /// The generator to use.
  BufferGenerator? generator;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    loadSound();
  }

  /// Load the sound.
  Future<void> loadSound() async {
    final g = await context.playSound(
      sound: widget.sound,
      source: widget.source,
      destroy: false,
    );
    if (mounted) {
      generator = g;
    } else {
      g.destroy();
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    generator?.destroy();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => widget.child;
}
