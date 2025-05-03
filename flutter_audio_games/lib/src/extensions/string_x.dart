import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// Useful string methods.
extension StringX on String {
  /// Return a sound, using this string as an asset key.
  ///
  /// If you want to turn a [List] of [String]s into a [List] of
  /// [SoundFromAsset]s, use the [ListStringX.asSoundList] method.
  SoundFromAsset asSound({
    required final bool destroy,
    final AssetBundle? assetBundle,
    final LoadMode loadMode = LoadMode.memory,
    final double volume = 0.7,
    final bool looping = false,
    final Duration loopingStart = Duration.zero,
    final SoundPosition position = unpanned,
    final bool paused = false,
    final double relativePlaySpeed = 1.0,
  }) => SoundFromAsset(
    assetKey: this,
    destroy: destroy,
    volume: volume,
    looping: looping,
    loopingStart: loopingStart,
    position: position,
    paused: paused,
    relativePlaySpeed: relativePlaySpeed,
    assetBundle: assetBundle,
    loadMode: loadMode,
  );
}
