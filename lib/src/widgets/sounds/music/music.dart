import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../../../extensions.dart';
import '../../../sounds/sound.dart';
import 'inherited_music.dart';

/// A widget that plays music.
class Music extends StatefulWidget {
  /// Create an instance.
  const Music({
    required this.music,
    required this.source,
    required this.child,
    this.fadeInLength,
    this.fadeOutLength,
    super.key,
  });

  /// Possibly return an instance from higher up the widget tree.
  static InheritedMusic? maybeOf(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedMusic>();

  /// Return an instance from higher up the widget tree.
  static InheritedMusic of(final BuildContext context) => maybeOf(context)!;

  /// The music to play.
  final Sound music;

  /// The source to play music through.
  final Source source;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The fade in length to use.
  final double? fadeInLength;

  /// The fade out time to use.
  final double? fadeOutLength;

  /// Create state for this widget.
  @override
  MusicState createState() => MusicState();
}

/// State for [Music].
class MusicState extends State<Music> {
  /// The generator to use.
  BufferGenerator? generator;

  /// Whether [fadeOut] has been used.
  late bool _faded;

  /// Fade in [generator].
  void fadeIn() {
    _faded = false;
    generator?.maybeFade(
      fadeLength: widget.fadeInLength,
      startGain: 0.0,
      endGain: widget.music.gain,
    );
  }

  /// Fade out [generator].
  void fadeOut() {
    _faded = true;
    generator?.maybeFade(
      fadeLength: widget.fadeOutLength,
      startGain: widget.music.gain,
      endGain: 0.0,
    );
  }

  /// Load the music.
  Future<void> _loadMusic() async {
    final Sound sound;
    if (widget.fadeInLength == null) {
      sound = widget.music;
    } else {
      sound = Sound(bufferReference: widget.music.bufferReference, gain: 0.0);
    }
    final g = await context.playSound(
      sound: sound,
      source: widget.source,
      destroy: false,
      linger: true,
      looping: true,
    );
    if (mounted) {
      generator = g;
      fadeIn();
    } else {
      generator = null;
      g.destroy();
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
    fadeOut();
    generator?.destroy();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    if (!_faded) {
      generator?.gain.value = widget.music.gain;
    }
    return InheritedMusic(
      fadeIn: fadeIn,
      fadeOut: fadeOut,
      setPlaybackPosition: (final position) =>
          generator?.playbackPosition.value = position,
      child: widget.child,
    );
  }
}
