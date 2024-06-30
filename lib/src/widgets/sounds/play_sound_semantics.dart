import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../extensions.dart';
import '../../sounds/loaded_sound.dart';

/// A [Semantics] widget which plays a sound when focused.
///
/// Wrap any [Focus]able [Widget] in a [PlaySoundSemantics] to have it play a
/// sound when focused.
class PlaySoundSemantics extends StatefulWidget {
  /// Create an instance.
  const PlaySoundSemantics({
    required this.sound,
    required this.child,
    this.looping = false,
    super.key,
  });

  /// The sound to play.
  final LoadedSound sound;

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
  /// The sound handle to use.
  SoundHandle? handle;

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
    final h = await widget.sound.play(destroy: false, looping: widget.looping);
    if (mounted) {
      handle = h;
      await context.findAncestorStateOfType<PlaySoundSemanticsState>()?.play();
    } else {
      await h.stop();
    }
  }

  /// Stop the sound.
  ///
  /// If [recurse] is `true`, then this method will attempt to go up the tree
  /// and call [stop] on the next [PlaySoundSemanticsState] instance.
  void stop({final bool recurse = true}) {
    handle?.stop();
    handle = null;
    if (recurse && mounted) {
      context
          .findAncestorStateOfType<PlaySoundSemanticsState>()
          ?.stop(recurse: recurse);
    }
  }
}
