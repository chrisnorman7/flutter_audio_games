import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import 'inherited_music_builder.dart';

/// A widget that plays music.
class MusicBuilder extends StatefulWidget {
  /// Create an instance.
  const MusicBuilder({
    required this.assetPath,
    required this.source,
    required this.builder,
    this.gain = 0.7,
    this.fadeInLength,
    this.fadeOutLength,
    super.key,
  });

  /// Possibly return an instance from higher up the widget tree.
  static InheritedMusicBuilder? maybeOf(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedMusicBuilder>();

  /// Return an instance from higher up the widget tree.
  static InheritedMusicBuilder of(final BuildContext context) =>
      maybeOf(context)!;

  /// The asset path to use for the music.
  final String assetPath;

  /// The source to play music through.
  final Source source;

  /// The widget below this one in the tree.
  final WidgetBuilder builder;

  /// The gain to use.
  final double gain;

  /// The fade in length to use.
  final double? fadeInLength;

  /// The fade out time to use.
  final double? fadeOutLength;

  /// Create state for this widget.
  @override
  MusicBuilderState createState() => MusicBuilderState();
}

/// State for [MusicBuilder].
class MusicBuilderState extends State<MusicBuilder> {
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
    final buffer = await context.bufferCache.getBuffer(
      context,
      widget.assetPath,
    );
    if (mounted) {
      final g = context.synthizerContext.createBufferGenerator(
        buffer: buffer,
      )
        ..looping.value = true
        ..configDeleteBehavior(linger: true);
      widget.source.addGenerator(g);
      generator = g;
      fadeIn();
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
  Widget build(final BuildContext context) => InheritedMusicBuilder(
        fadeIn: fadeIn,
        fadeOut: fadeOut,
        child: Builder(builder: widget.builder),
      );
}
