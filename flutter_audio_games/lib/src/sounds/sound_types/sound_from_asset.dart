import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A [Sound] loaded from [assetKey].
class SoundFromAsset extends LoadableSound {
  /// Create an instance.
  const SoundFromAsset({
    required this.assetKey,
    required super.destroy,
    this.assetBundle,
    super.loadMode,
    super.looping,
    super.volume,
    super.loopingStart,
    super.paused,
    super.position,
    super.relativePlaySpeed,
  });

  /// The asset key to use.
  final String assetKey;

  /// The asset bundle to use.
  final AssetBundle? assetBundle;

  /// Copy a sound.
  @override
  SoundFromAsset copyWith({
    final String? assetKey,
    final AssetBundle? assetBundle,
    final LoadMode? loadMode,
    final bool? destroy,
    final double? volume,
    final bool? looping,
    final Duration? loopingStart,
    final SoundPosition? position,
    final bool? paused,
    final double? relativePlaySpeed,
  }) =>
      SoundFromAsset(
        assetKey: assetKey ?? this.assetKey,
        assetBundle: assetBundle ?? this.assetBundle,
        loadMode: loadMode ?? this.loadMode,
        looping: looping ?? this.looping,
        destroy: destroy ?? this.destroy,
        loopingStart: loopingStart ?? this.loopingStart,
        paused: paused ?? this.paused,
        position: position ?? this.position,
        relativePlaySpeed: relativePlaySpeed ?? this.relativePlaySpeed,
        volume: volume ?? this.volume,
      );

  /// Return [assetKey].
  @override
  String get internalUri => assetKey;

  /// Load [assetKey].
  @override
  Future<AudioSource> load() => SoLoud.instance
      .loadAsset(assetKey, assetBundle: assetBundle, mode: loadMode);
}
