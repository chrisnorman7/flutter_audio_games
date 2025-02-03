import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// Possible states for [PlaySoundSemanticsState].
enum _PossibleStates {
  /// Nothing.
  nothing,

  /// Loading.
  loading,

  /// Playing.
  playing,
}

/// A [Semantics] widget which plays a sound when focused.
///
/// Wrap any [Focus]able [Widget] in a [PlaySoundSemantics] to have it play a
/// sound when focused.
class PlaySoundSemantics extends StatefulWidget {
  /// Create an instance.
  const PlaySoundSemantics({
    required this.sound,
    required this.child,
    this.autofocus = false,
    this.descendantsAreFocusable = true,
    this.descendantsAreTraversable = true,
    super.key,
  });

  /// The sound to play.
  final Sound sound;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Whether the [FocusableActionDetector] should be autofocused.
  final bool autofocus;

  /// Whether the [FocusableActionDetector] descendents should be focusable.
  final bool descendantsAreFocusable;

  /// Whether the descendents of the [FocusableActionDetector] are traversable.
  final bool descendantsAreTraversable;

  /// Create state for this widget.
  @override
  PlaySoundSemanticsState createState() => PlaySoundSemanticsState();
}

/// State for [PlaySoundSemantics].
class PlaySoundSemanticsState extends State<PlaySoundSemantics> {
  /// The current state of the player.
  late _PossibleStates _state;

  /// The sound handle to use.
  SoundHandle? handle;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _state = _PossibleStates.nothing;
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _stop(recurse: false);
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => FocusableActionDetector(
        enabled: false,
        autofocus: widget.autofocus,
        descendantsAreFocusable: widget.descendantsAreFocusable,
        descendantsAreTraversable: widget.descendantsAreTraversable,
        onFocusChange: (final value) {
          if (value) {
            _restart();
          } else {
            _stop();
          }
        },
        child: MouseRegion(
          child: widget.child,
          onEnter: (final _) {
            if (_state == _PossibleStates.nothing ||
                _state == _PossibleStates.playing) {
              _restart();
            }
          },
          onExit: (final _) {
            _stop();
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
    if (_state != _PossibleStates.nothing) {
      return;
    }
    _state = _PossibleStates.loading;
    final h = await context.playSound(widget.sound);
    if (mounted) {
      handle = h;
      _state = _PossibleStates.playing;
      await context.findAncestorStateOfType<PlaySoundSemanticsState>()?._play();
    } else {
      _state = _PossibleStates.nothing;
      await h?.stop();
    }
  }

  /// Stop the sound.
  ///
  /// If [recurse] is `true`, then this method will attempt to go up the tree
  /// and call [_stop] on the next [PlaySoundSemanticsState] instance.
  Future<void> _stop({final bool recurse = true}) async {
    final h = handle;
    if (h != null) {
      _state = _PossibleStates.nothing;
      handle = null;
      await h.stop();
    }
    if (recurse && mounted) {
      await context.findAncestorStateOfType<PlaySoundSemanticsState>()?._stop();
    }
  }
}
