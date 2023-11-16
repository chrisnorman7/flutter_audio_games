import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import 'inherited_music.dart';

/// A widget that plays music.
class Music extends StatefulWidget {
  /// Create an instance.
  const Music({
    required this.assetPath,
    required this.source,
    required this.child,
    this.gain = 0.7,
    this.fadeInLength,
    this.fadeOutLength,
    super.key,
  });

  /// Possibly return an instance from higher up the widget tree.
  static InheritedMusic? maybeOf(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedMusic>();

  /// Return an instance from higher up the widget tree.
  static InheritedMusic of(final BuildContext context) => maybeOf(context)!;

  /// The asset path to use for the music.
  final String assetPath;

  /// The source to play music through.
  final Source source;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The gain to use.
  final double gain;

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

  /// Fade in [generator].
  void fadeIn() {
    final fadeIn = widget.fadeInLength;
    if (fadeIn != null) {
      generator?.fade(fadeLength: fadeIn, startGain: 0.0, endGain: widget.gain);
    } else {
      generator?.gain.value = widget.gain;
    }
  }

  /// Fade out [generator].
  void fadeOut() {
    final fadeLength = widget.fadeOutLength;
    if (fadeLength != null) {
      generator?.fade(
        fadeLength: fadeLength,
        startGain: widget.gain,
        endGain: 0.0,
      );
    }
  }

  /// ]]
  /// Load the music.
  Future<void> loadMusic() async {
    final g = context.synthizerContext.createBufferGenerator()
      ..looping.value = true
      ..configDeleteBehavior(linger: true)
      ..gain.value = 0.0;
    widget.source.addGenerator(g);
    final buffer = await context.bufferCache.getBuffer(
      context,
      widget.assetPath,
    );
    g.buffer.value = buffer;
    if (mounted) {
      generator = g;
      fadeIn();
    } else {
      g.destroy();
    }
  }

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    loadMusic();
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
  Widget build(final BuildContext context) => InheritedMusic(
        fadeIn: fadeIn,
        fadeOut: fadeOut,
        setPlaybackPosition: (final value) =>
            generator?.playbackPosition.value = value,
        child: widget.child,
      );
}