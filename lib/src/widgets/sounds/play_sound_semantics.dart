import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../../../flutter_audio_games.dart';

/// A [Semantics] widget which plays a sound when focused.
///
/// Wrap any [Focus]able [Widget] in a [PlaySoundSemantics] to have it play a
/// sound when focused.
class PlaySoundSemantics extends StatefulWidget {
  /// Create an instance.
  const PlaySoundSemantics({
    required this.sound,
    required this.source,
    required this.child,
    this.looping = false,
    super.key,
  });

  /// The sound to play.
  final Sound sound;

  /// The source to play the sound through.
  final Source source;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Whether or not the sound should loop.
  final bool looping;

  /// Create state for this widget.
  @override
  PlaySoundSemanticsState createState() => PlaySoundSemanticsState();
}

/// State for [PlaySoundSemantics].
class PlaySoundSemanticsState extends State<PlaySoundSemantics> {
  /// The generator to use.
  BufferGenerator? generator;

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => Semantics(
        onDidGainAccessibilityFocus: () {
          stop();
          play();
        },
        onDidLoseAccessibilityFocus: stop,
        child: widget.child,
      );

  /// Play the sound.
  Future<void> play() async {
    final g = await context.playSound(
      sound: widget.sound,
      source: widget.source,
      destroy: false,
      looping: widget.looping,
    );
    widget.source.addGenerator(g);
    if (mounted) {
      generator = g;
      await context.findAncestorStateOfType<PlaySoundSemanticsState>()?.play();
    } else {
      g.destroy();
    }
  }

  /// Stop the sound.
  void stop() {
    generator?.destroy();
    generator = null;
    if (mounted) {
      context.findAncestorStateOfType<PlaySoundSemanticsState>()?.stop();
    }
  }
}
