import 'package:flutter_soloud/flutter_soloud.dart';

import 'sound.dart';

/// A class which represents a [sound] which has been loaded into a [source].
class LoadedSound {
  /// Create an instance.
  const LoadedSound({
    required this.sound,
    required this.source,
  });

  /// The loaded sound.
  final Sound sound;

  /// The source which [sound] has been loaded to.
  final AudioSource source;

  /// Play this sound.
  Future<SoundHandle> play({
    final bool looping = false,
    final Duration loopingStart = Duration.zero,
    final double pan = 0,
    final bool paused = false,
    final double? gain,
    final bool destroy = false,
  }) async {
    final soLoud = SoLoud.instance;
    final handle = await soLoud.play(
      source,
      looping: looping,
      volume: gain ?? sound.gain,
      loopingStartAt: loopingStart,
      pan: pan,
      paused: paused,
    );
    if (destroy) {
      final length = soLoud.getLength(source);
      soLoud.scheduleStop(handle, length);
    }
    return handle;
  }
}
