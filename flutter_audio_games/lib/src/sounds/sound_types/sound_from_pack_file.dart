import 'package:flutter/services.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A [Sound] from a pack file loaded from [assetKey].
class SoundFromPackFile extends SoundFromAsset {
  /// Create an instance.
  const SoundFromPackFile({
    required super.assetKey,
    required this.offset,
    required this.length,
    required super.destroy,
    super.volume,
    super.assetBundle,
    super.looping,
    super.loadMode,
    super.loopingStart,
    super.paused,
    super.position,
    super.relativePlaySpeed,
  });

  /// The starting offset.
  final int offset;

  /// The length of the sound.
  final int length;

  /// Include [offset] and [length] in the [assetKey].
  @override
  String get internalUri => '$assetKey:$offset:$length';

  /// Load this sound.
  @override
  Future<AudioSource> load() async {
    final b = assetBundle ?? rootBundle;
    final buffer = await b.load(assetKey);
    return SoLoud.instance.loadMem(
      internalUri,
      buffer.buffer.asUint8List(offset, length),
      mode: loadMode,
    );
  }

  /// Copy this instance.
  @override
  SoundFromAsset copyWith({
    final int? offset,
    final int? length,
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
      SoundFromPackFile(
        assetKey: assetKey ?? this.assetKey,
        offset: offset ?? this.offset,
        length: length ?? this.length,
        destroy: destroy ?? this.destroy,
        volume: volume ?? this.volume,
        assetBundle: assetBundle ?? this.assetBundle,
        looping: looping ?? this.looping,
        loadMode: loadMode ?? this.loadMode,
        loopingStart: loopingStart ?? this.loopingStart,
        paused: paused ?? this.paused,
        position: position ?? this.position,
        relativePlaySpeed: relativePlaySpeed ?? this.relativePlaySpeed,
      );
}
