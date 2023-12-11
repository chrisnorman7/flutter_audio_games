import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import '../../../extensions.dart';
import 'ambiance.dart';

/// A widget which plays [ambiances].
class Ambiances extends StatefulWidget {
  /// Create an instance.
  const Ambiances({
    required this.ambiances,
    required this.source,
    required this.child,
    this.fadeIn,
    this.fadeOut,
    super.key,
  });

  /// The ambiances to play.
  final List<Ambiance> ambiances;

  /// The source to play [ambiances] through.
  final Source source;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The fade in time.
  final double? fadeIn;

  /// The fade out time.
  final double? fadeOut;

  /// Create state for this widget.
  @override
  AmbiancesState createState() => AmbiancesState();
}

/// State for [Ambiances].
class AmbiancesState extends State<Ambiances> {
  /// The ambiance generators.
  late final List<BufferGenerator> generators;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    generators = [];
  }

  /// Load the ambiances.
  Future<void> loadAmbiances() async {
    for (final generator in generators) {
      generator
        ..configDeleteBehavior(linger: false)
        ..destroy();
    }
    generators.clear();
    for (final ambiance in widget.ambiances) {
      if (mounted) {
        final generator = await context.playSound(
          assetPath: ambiance.assetPath,
          source: widget.source,
          destroy: false,
          gain: ambiance.gain,
        );
        generator
          ..looping.value = true
          ..maybeFade(
            fadeLength: widget.fadeIn,
            startGain: 0.0,
            endGain: ambiance.gain,
          );
        widget.source.addGenerator(generator);
        if (mounted) {
          generators.add(generator);
        } else {
          generator.destroy();
        }
      }
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    for (var i = 0; i < widget.ambiances.length; i++) {
      final ambiance = widget.ambiances[i];
      generators[i]
        ..looping.value = false
        ..maybeFade(
          fadeLength: widget.fadeOut,
          startGain: ambiance.gain,
          endGain: 0.0,
        )
        ..destroy();
    }
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final future = loadAmbiances();
    return SimpleFutureBuilder(
      future: future,
      done: (final context, final value) => widget.child,
      loading: (final context) => widget.child,
      error: ErrorListView.withPositional,
    );
  }
}
