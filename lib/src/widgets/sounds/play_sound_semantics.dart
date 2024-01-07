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

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    stop(recurse: false);
  }

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
  ///
  /// If [recurse] is `true`, then this method will attempt to go up the tree
  /// and call [stop] on the next [PlaySoundSemanticsState] instance.
  void stop({final bool recurse = true}) {
    generator?.destroy();
    generator = null;
    if (recurse && mounted) {
      context.findAncestorStateOfType<PlaySoundSemanticsState>()?.stop();
    }
  }
}
