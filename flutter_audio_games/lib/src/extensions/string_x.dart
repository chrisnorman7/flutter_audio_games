import 'package:flutter_audio_games/flutter_audio_games.dart';

/// Useful string methods.
extension StringX on String {
  /// Return a sound, using this string as the path.
  ///
  /// If you want to turn a [List] of [String]s into a [List] of [Sound]s, use
  /// the [ListStringX.asSoundList] method.
  Sound asSound({
    required final bool destroy,
    final double volume = 0.7,
    final bool looping = false,
    final Duration loopingStart = Duration.zero,
    final SoundPosition position = unpanned,
    final bool paused = false,
    final double relativePlaySpeed = 1.0,
  }) =>
      throw UnimplementedError();
}
