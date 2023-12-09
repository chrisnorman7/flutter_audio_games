import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

/// A widget which plays a sound when built.
class PlaySound extends StatefulWidget {
  /// Create an instance.
  const PlaySound({
    required this.assetPath,
    required this.source,
    required this.child,
    this.gain = 0.7,
    super.key,
  });

  /// The asset path to use.
  final String assetPath;

  /// The source to play [assetPath] through.
  final Source source;

  /// The gain to play [assetPath] at.
  final double gain;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Create state for this widget.
  @override
  PlaySoundState createState() => PlaySoundState();
}

/// State for [PlaySound].
class PlaySoundState extends State<PlaySound> {
  /// The generator to use.
  BufferGenerator? generator;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    loadSound();
  }

  /// Load the sound.
  Future<void> loadSound() async {
    final value = await context.playSound(
      assetPath: widget.assetPath,
      source: widget.source,
      gain: widget.gain,
    );
    if (mounted) {
      generator = value;
    } else {
      value.destroy();
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    generator?.configDeleteBehavior(linger: false);
    generator?.destroy();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => widget.child;
}
