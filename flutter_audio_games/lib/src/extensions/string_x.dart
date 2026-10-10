import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:material_ui/material_ui.dart';

/// Useful string methods.
extension StringX on String {
  /// Return a sound, using this string as an asset key.
  ///
  /// If you want to turn a [List] of [String]s into a [List] of
  /// [SoundFromAsset]s, use the [ListStringX.asSoundList] method.
  SoundFromAsset asSound({
    required bool destroy,
    AssetBundle? assetBundle,
    LoadMode loadMode = LoadMode.memory,
    double volume = 0.7,
    bool looping = false,
    Duration loopingStart = Duration.zero,
    SoundPosition position = unpanned,
    bool paused = false,
    double relativePlaySpeed = 1.0,
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
