import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

/// A widget which uses [PlaySoundSemantics] to play [sound] if [sound] is not
/// `null`.
class MaybePlaySoundSemantics extends StatelessWidget {
  /// Create an instance.
  const MaybePlaySoundSemantics({
    required this.sound,
    required this.child,
    super.key,
  });

  /// The sound to play.
  final Sound? sound;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final s = sound;
    if (s == null) {
      return child;
    }
    return PlaySoundSemantics(
      sound: s,
      child: child,
    );
  }
}
