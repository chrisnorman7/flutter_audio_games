/// A single sound to play.
class Sound {
  /// Create an instance.
  const Sound({
    required this.assetPath,
    this.gain = 0.7,
  });

  /// The asset path to use.
  final String assetPath;

  /// The gain to play [assetPath] at.
  final double gain;
}
