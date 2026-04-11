import 'package:flutter_soloud/flutter_soloud.dart';

/// A [source] and [handle] which have been loaded.
class LoadedSound {
  /// Create an instance.
  const LoadedSound({required this.source, required this.handle});

  /// The loaded audio source.
  final AudioSource source;

  /// The sound handle.
  final SoundHandle handle;
}
