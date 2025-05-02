import 'dart:math';

import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

final _random = Random();

/// Useful extensions for lists.
extension ListX<E> on List<E> {
  /// Return a random element.
  ///
  /// This uses [Random.nextInt] to get a random index.
  E randomElement() => this[_random.nextInt(length)];
}

/// Useful methods on string lists.
extension ListStringX on List<String> {
  /// Return a sound list.
  List<Sound> asSoundList({
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

/// Useful methods for lists of sound handles.
extension ListSoundHandleX on List<SoundHandle> {
  /// Fade this handle to [fadeTo] over [fadeOutTime], run [f], then fade back
  /// up over [fadeInTime] to their original volumes.
  Future<T> runFaded<T>(
    final Future<T> Function() f, {
    final double fadeTo = 0.0,
    final Duration fadeOutTime = const Duration(seconds: 3),
    final Duration fadeInTime = const Duration(seconds: 3),
  }) async {
    final maxVolumes = map((final handle) {
      final volume = handle.volume.value;
      handle.volume.fade(fadeTo, fadeOutTime);
      return volume;
    });
    final result = await f();
    for (var i = 0; i < length; i++) {
      this[i].volume.fade(maxVolumes.elementAt(i), fadeInTime);
    }
    return result;
  }
}
