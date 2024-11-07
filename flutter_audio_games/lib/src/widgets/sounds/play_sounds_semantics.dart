import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../../flutter_audio_games.dart';

/// A widget which plays a random sound from [sounds] every [interval] when
/// selected.
class PlaySoundsSemantics extends StatefulWidget {
  /// Create an instance.
  const PlaySoundsSemantics({
    required this.sounds,
    required this.interval,
    required this.child,
    super.key,
  });

  /// The sounds to play.
  final List<Sound> sounds;

  /// How often a sound from [sounds] should play.
  final Duration interval;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Create state for this widget.
  @override
  PlaySoundsSemanticsState createState() => PlaySoundsSemanticsState();
}

/// State for [PlaySoundsSemantics].
class PlaySoundsSemanticsState extends State<PlaySoundsSemantics> {
  /// The timer to use.
  Timer? _timer;

  /// The sound handle of the currently-playing sound.
  SoundHandle? _soundHandle;

  /// The random number generator to use.
  late final Random random;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    random = Random();
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    stop();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => Semantics(
        onDidGainAccessibilityFocus: () {
          _timer?.cancel();
          _timer = Timer.periodic(
            widget.interval,
            (final timer) async {
              final handle = await context.playRandomSound(
                widget.sounds,
                random,
              );
              await _soundHandle?.stop();
              _soundHandle = handle;
            },
          );
        },
        onDidLoseAccessibilityFocus: stop,
        child: widget.child,
      );

  /// Stop sounds from playing.
  void stop() {
    _timer?.cancel();
    _timer = null;
    _soundHandle?.stop();
    _soundHandle = null;
  }
}
