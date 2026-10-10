import 'dart:math';

import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:material_ui/material_ui.dart';

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
  List<SoundFromAsset> asSoundList({
    required bool destroy,
    AssetBundle? assetBundle,
    LoadMode loadMode = LoadMode.memory,
    double volume = 0.7,
    bool looping = false,
    Duration loopingStart = Duration.zero,
    SoundPosition position = unpanned,
    bool paused = false,
    double relativePlaySpeed = 1.0,
  }) => map(
    (string) => string.asSound(
      destroy: destroy,
      assetBundle: assetBundle,
      loadMode: loadMode,
      volume: volume,
      looping: looping,
      loopingStart: loopingStart,
      position: position,
      paused: paused,
      relativePlaySpeed: relativePlaySpeed,
    ),
  ).toList();
}

/// Useful methods for lists of sound handles.
extension ListSoundHandleX on List<SoundHandle> {
  /// Fade this handle to [fadeTo] over [fadeOutTime], run [f], then fade back
  /// up over [fadeInTime] to their original volumes.
  Future<T> runFaded<T>(
    Future<T> Function() f, {
    double fadeTo = 0.0,
    Duration fadeOutTime = const Duration(seconds: 3),
    Duration fadeInTime = const Duration(seconds: 3),
  }) async {
    final maxVolumes = map((handle) {
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
