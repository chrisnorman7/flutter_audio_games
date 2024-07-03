import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../../extensions.dart';
import '../../../sounds/sound.dart';
import 'inherited_music.dart';

/// A widget that plays music.
class Music extends StatefulWidget {
  /// Create an instance.
  const Music({
    required this.sound,
    required this.child,
    this.fadeInTime,
    this.fadeOutTime,
    super.key,
  });

  /// Possibly return an instance from higher up the widget tree.
  static InheritedMusic? maybeOf(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedMusic>();

  /// Return an instance from higher up the widget tree.
  static InheritedMusic of(final BuildContext context) => maybeOf(context)!;

  /// The loaded sound.
  final Sound sound;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The fade in length to use.
  final Duration? fadeInTime;

  /// The fade out time to use.
  final Duration? fadeOutTime;

  /// Create state for this widget.
  @override
  MusicState createState() => MusicState();
}

/// State for [Music].
class MusicState extends State<Music> {
  /// The playing sound.
  SoundHandle? handle;

  /// Whether [fadeOut] has been used.
  late bool _faded;

  /// Fade in [handle].
  void fadeIn() {
    _faded = false;
    handle?.maybeFade(
      fadeTime: widget.fadeInTime,
      to: widget.sound.volume,
    );
  }

  /// Fade out [handle].
  void fadeOut() {
    _faded = true;
    handle?.maybeFade(fadeTime: widget.fadeOutTime, to: 0.0);
  }

  /// Load the music.
  Future<void> _loadMusic() async {
    final h = await context.playSound(
      widget.sound.copyWith(volume: widget.fadeInTime == null ? null : 0.0),
    );
    if (mounted) {
      handle = h;
      if (widget.fadeInTime != null) {
        fadeIn();
      }
    } else {
      await handle?.stop();
    }
  }

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _faded = false;
    _loadMusic();
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    final h = handle;
    if (h != null) {
      h.stop(fadeOutTime: widget.fadeOutTime);
    }
    handle = null;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final soLoud = SoLoud.instance;
    if (!_faded) {
      final h = handle;
      if (h != null) {
        soLoud.setVolume(h, widget.sound.volume);
      }
    }
    return InheritedMusic(
      fadeIn: fadeIn,
      fadeOut: fadeOut,
      setPlaybackPosition: (final position) {
        final h = handle;
        if (h != null) {
          soLoud.seek(h, position as Duration);
        }
      },
      child: widget.child,
    );
  }
}
