import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../../../extensions.dart';
import '../../../sounds/sound.dart';

/// A widget which plays [ambiances].
class AmbiancesBuilder extends StatefulWidget {
  /// Create an instance.
  const AmbiancesBuilder({
    required this.ambiances,
    required this.source,
    required this.builder,
    this.fadeIn,
    this.fadeOut,
    super.key,
  });

  /// The ambiances to play.
  final List<Sound> ambiances;

  /// The source to play [ambiances] through.
  final Source source;

  /// The widget below this widget in the tree.
  final Widget Function(BuildContext context, List<BufferGenerator> generators)
      builder;

  /// The fade in time.
  final double? fadeIn;

  /// The fade out time.
  final double? fadeOut;

  /// Create state for this widget.
  @override
  AmbiancesBuilderState createState() => AmbiancesBuilderState();
}

/// State for [AmbiancesBuilder].
class AmbiancesBuilderState extends State<AmbiancesBuilder> {
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
    final fadeIn = widget.fadeIn;
    for (final ambiance in widget.ambiances) {
      if (mounted) {
        final sound = fadeIn == null
            ? ambiance
            : Sound(
                bufferReference: ambiance.bufferReference,
                gain: 0.0,
              );
        final generator = await context.playSound(
          sound: sound,
          source: widget.source,
          destroy: false,
          linger: true,
          looping: true,
        );
        generator.maybeFade(
          fadeLength: fadeIn,
          startGain: 0.0,
          endGain: ambiance.gain,
        );
        if (mounted) {
          widget.source.addGenerator(generator);
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
      done: (final context, final value) => widget.builder(context, generators),
      loading: () => widget.builder(context, []),
      error: ErrorListView.withPositional,
    );
  }
}
