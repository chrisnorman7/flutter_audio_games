import 'sound.dart';

/// The type of a [Sound].
enum SoundType {
  /// The sound should be loaded from an asset.
  asset,

  /// The sound should be loaded from a file.
  file,

  /// The sound should be loaded from a url.
  url,

  /// The sound should be loaded in a custom way.
  ///
  /// How this sound will be loaded is up to `SourceLoader.loadCustomSound`.
  custom,
}
