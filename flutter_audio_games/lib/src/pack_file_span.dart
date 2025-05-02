import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A span in a pack file which can be loaded from [assetKey].
class PackFileSpan {
  /// Create an instance.
  const PackFileSpan({
    required this.assetKey,
    required this.offset,
    required this.length,
  });

  /// The asset key where the pack file can be loaded from.
  final String assetKey;

  /// The offset where the span starts.
  final int offset;

  /// The length of the span.
  final int length;

  /// Convert this instance to a sound.
  SoundFromPackFile asSound({
    required final bool destroy,
    final double volume = 0.7,
    final AssetBundle? assetBundle,
    final bool looping = false,
    final LoadMode loadMode = LoadMode.memory,
    final Duration loopingStart = Duration.zero,
    final bool paused = false,
    final SoundPosition position = unpanned,
    final double relativePlaySpeed = 1.0,
  }) =>
      SoundFromPackFile(
        assetKey: assetKey,
        offset: offset,
        length: length,
        destroy: destroy,
        assetBundle: assetBundle,
        loadMode: loadMode,
        looping: looping,
        loopingStart: loopingStart,
        paused: paused,
        position: position,
        relativePlaySpeed: relativePlaySpeed,
        volume: volume,
      );
}
