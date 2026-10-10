import 'dart:async';

import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:material_ui/material_ui.dart';

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
  /// Whether audio is playing.
  late bool _playing;

  /// The timer to use.
  Timer? _timer;

  /// The sound handle of the currently-playing sound.
  SoundHandle? _soundHandle;

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
    _playing = false;
    _stop();
  }

  /// Build a widget.
  @override
  Widget build(BuildContext context) => FocusableActionDetector(
    enabled: false,
    onFocusChange: (value) {
      if (value && !_playing) {
        _playing = true;
        _restart();
      } else if (_playing) {
        _playing = false;
        _stop();
      }
    },
    child: MouseRegion(
      child: widget.child,
      onEnter: (_) {
        if (!_playing) {
          _playing = true;
          _restart();
        }
      },
      onExit: (_) {
        if (_playing) {
          _playing = false;
          _stop();
        }
      },
    ),
  );

  void _restart() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.interval, (timer) async {
      final handle = await context.playRandomSound(widget.sounds);
      await _soundHandle?.stop();
      _soundHandle = handle;
    });
  }

  /// Stop sounds from playing.
  void _stop() {
    _timer?.cancel();
    _timer = null;
    _soundHandle?.stop();
    _soundHandle = null;
  }
}
