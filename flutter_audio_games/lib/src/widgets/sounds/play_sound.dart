import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A widget which plays a sound when built.
///
/// If you want a widget which plays a looping sound when built, consider the
/// [Music] widget.
class PlaySound extends StatefulWidget {
  /// Create an instance.
  const PlaySound({required this.sound, required this.child, super.key});

  /// The loaded sound.
  final Sound sound;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Create state for this widget.
  @override
  PlaySoundState createState() => PlaySoundState();
}

/// State for [PlaySound].
class PlaySoundState extends State<PlaySound> {
  /// The sound handle to use.
  SoundHandle? handle;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    loadSound();
  }

  /// Load the sound.
  Future<void> loadSound() async {
    final h = await context.playSound(widget.sound);
    if (mounted) {
      handle = h;
    } else {
      await h?.stop();
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    handle?.stop();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => widget.child;
}
