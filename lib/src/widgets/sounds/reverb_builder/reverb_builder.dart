import 'package:backstreets_widgets/typedefs.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import 'reverb_preset.dart';

/// A widget which creates a [GlobalFdnReverb] from [reverbPreset] and manages
/// its life cycle.
class ReverbBuilder extends StatefulWidget {
  /// Create an instance.
  const ReverbBuilder({
    required this.reverbPreset,
    required this.builder,
    super.key,
  });

  /// The reverb preset to use.
  final ReverbPreset reverbPreset;

  /// The widget builder to use.
  final BuildContextValueBuilder<GlobalFdnReverb> builder;

  /// Create state for this widget.
  @override
  ReverbBuilderState createState() => ReverbBuilderState();
}

/// State for [ReverbBuilder].
class ReverbBuilderState extends State<ReverbBuilder> {
  /// The reverb instance to pass to the builder.
  late final GlobalFdnReverb reverb;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    final preset = widget.reverbPreset;
    reverb = context.synthizerContext.createGlobalFdnReverb()
      ..meanFreePath.value = preset.meanFreePath
      ..t60.value = preset.t60
      ..lateReflectionsLfRolloff.value = preset.lateReflectionsLfRolloff
      ..lateReflectionsLfReference.value = preset.lateReflectionsLfReference
      ..lateReflectionsHfRolloff.value = preset.lateReflectionsHfRolloff
      ..lateReflectionsHfReference.value = preset.lateReflectionsHfReference
      ..lateReflectionsDiffusion.value = preset.lateReflectionsDiffusion
      ..lateReflectionsModulationDepth.value =
          preset.lateReflectionsModulationDepth
      ..lateReflectionsModulationFrequency.value =
          preset.lateReflectionsModulationFrequency
      ..lateReflectionsDelay.value = preset.lateReflectionsDelay
      ..gain.value = preset.gain
      ..configDeleteBehavior(linger: true);
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    reverb.destroy();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => Builder(
        builder: (final innerContext) => widget.builder(innerContext, reverb),
      );
}
