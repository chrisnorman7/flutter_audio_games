import 'dart:typed_data';

import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A [Sound] from [buffer].
class SoundFromBuffer extends LoadableSound {
  /// Create an instance.
  const SoundFromBuffer({
    required this.path,
    required this.buffer,
    required super.destroy,
    super.loadMode,
    super.looping,
    super.volume,
    super.loopingStart,
    super.paused,
    super.position,
    super.relativePlaySpeed,
  });

  /// The path to use.
  final String path;

  /// The buffer to load from.
  final Uint8List buffer;

  @override
  SoundFromBuffer copyWith({
    String? path,
    Uint8List? buffer,
    LoadMode? loadMode,
    bool? destroy,
    double? volume,
    bool? looping,
    Duration? loopingStart,
    SoundPosition? position,
    bool? paused,
    double? relativePlaySpeed,
  }) => SoundFromBuffer(
    path: path ?? this.path,
    buffer: buffer ?? this.buffer,
    loadMode: loadMode ?? this.loadMode,
    destroy: destroy ?? this.destroy,
    looping: looping ?? this.looping,
    volume: volume ?? this.volume,
    loopingStart: loopingStart ?? this.loopingStart,
    paused: paused ?? this.paused,
    position: position ?? this.position,
    relativePlaySpeed: relativePlaySpeed ?? this.relativePlaySpeed,
  );

  /// Return [buffer] turned to a [String].
  @override
  String get internalUri => buffer.toString();

  /// Load the [buffer].
  @override
  Future<AudioSource> load() => SoLoud.instance.loadMem(
    path,
    buffer,
    mode: loadMode,
    autoDispose: destroy,
  );
}
