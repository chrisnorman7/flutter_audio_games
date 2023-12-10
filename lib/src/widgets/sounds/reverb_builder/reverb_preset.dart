/// A reverb preset.
class ReverbPreset {
  /// Create a preset.
  const ReverbPreset({
    required this.name,
    this.meanFreePath = 0.1,
    this.t60 = 0.3,
    this.lateReflectionsLfRolloff = 1.0,
    this.lateReflectionsLfReference = 200.0,
    this.lateReflectionsHfRolloff = 0.5,
    this.lateReflectionsHfReference = 500.0,
    this.lateReflectionsDiffusion = 1.0,
    this.lateReflectionsModulationDepth = 0.01,
    this.lateReflectionsModulationFrequency = 0.5,
    this.lateReflectionsDelay = 0.03,
    this.gain = 0.5,
  });

  /// The name of this preset.
  final String name;

  /// The mean free path of the simulated environment.
  final double meanFreePath;

  /// The T60 of the reverb.
  final double t60;

  /// A multiplicative factor on T60 for the low frequency band.
  final double lateReflectionsLfRolloff;

  /// Where the low band of the feedback equalizer ends.
  final double lateReflectionsLfReference;

  /// A multiplicative factor on T60 for the high frequency band.
  final double lateReflectionsHfRolloff;

  /// Where the high band of the equalizer starts.
  final double lateReflectionsHfReference;

  /// Controls the diffusion of the late reflections as a percent.
  final double lateReflectionsDiffusion;

  /// The depth of the modulation of the delay lines on the feedback path in
  /// seconds.
  final double lateReflectionsModulationDepth;

  /// The frequency of the modulation of the delay lines in the feedback paths.
  final double lateReflectionsModulationFrequency;

  /// The delay of the late reflections relative to the input in seconds.
  final double lateReflectionsDelay;

  /// The gain of the reverb.
  final double gain;
}
