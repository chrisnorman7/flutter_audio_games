import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../extensions.dart';
import '../../sounds/sound.dart';

/// A [Semantics] widget which plays a sound when focused.
///
/// Wrap any [Focus]able [Widget] in a [PlaySoundSemantics] to have it play a
/// sound when focused.
class PlaySoundSemantics extends StatefulWidget {
  /// Create an instance.
  const PlaySoundSemantics({
    required this.sound,
    required this.child,
    super.key,
  });

  /// The sound to play.
  final Sound sound;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Create state for this widget.
  @override
  PlaySoundSemanticsState createState() => PlaySoundSemanticsState();
}

/// State for [PlaySoundSemantics].
class PlaySoundSemanticsState extends State<PlaySoundSemantics> {
  /// Whether the sound is playing.
  late bool _playing;

  /// The sound handle to use.
  SoundHandle? handle;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _playing = false;
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _stop(recurse: false);
    _playing = false;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => FocusableActionDetector(
        enabled: false,
        onFocusChange: (final value) {
          if (value && !_playing) {
            _restart();
          } else if (_playing) {
            _stop();
          }
        },
        child: MouseRegion(
          child: widget.child,
          onEnter: (final _) {
            if (!_playing) {
              _restart();
            }
          },
          onExit: (final _) {
            if (_playing) {
              _stop();
            }
          },
        ),
      );

  /// Restart the sound.
  void _restart() {
    _stop();
    _play();
  }

  /// Play the sound.
  Future<void> _play() async {
    final h = await context.playSound(widget.sound);
    if (mounted) {
      handle = h;
      _playing = true;
      await context.findAncestorStateOfType<PlaySoundSemanticsState>()?._play();
    } else {
      await h?.stop();
    }
  }

  /// Stop the sound.
  ///
  /// If [recurse] is `true`, then this method will attempt to go up the tree
  /// and call [_stop] on the next [PlaySoundSemanticsState] instance.
  void _stop({final bool recurse = true}) {
    handle?.stop();
    handle = null;
    _playing = false;
    if (recurse && mounted) {
      context.findAncestorStateOfType<PlaySoundSemanticsState>()?._stop();
    }
  }
}
