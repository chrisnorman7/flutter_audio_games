import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:http/http.dart';

/// A [Sound] loaded from [url].
class SoundFromUrl extends LoadableSound {
  /// Create an instance.
  const SoundFromUrl({
    required this.url,
    required super.destroy,
    this.client,
    super.loadMode,
    super.looping,
    super.volume,
    super.loopingStart,
    super.paused,
    super.position,
    super.relativePlaySpeed,
  });

  /// The URL to load from.
  final String url;

  /// The HTTP client to use.
  final Client? client;

  @override
  SoundFromUrl copyWith({
    final String? url,
    final Client? client,
    final LoadMode? loadMode,
    final bool? destroy,
    final double? volume,
    final bool? looping,
    final Duration? loopingStart,
    final SoundPosition? position,
    final bool? paused,
    final double? relativePlaySpeed,
  }) =>
      SoundFromUrl(
        url: url ?? this.url,
        destroy: destroy ?? this.destroy,
        client: client ?? this.client,
        looping: looping ?? this.looping,
        volume: volume ?? this.volume,
        loopingStart: loopingStart ?? this.loopingStart,
        paused: paused ?? this.paused,
        position: position ?? this.position,
        relativePlaySpeed: relativePlaySpeed ?? this.relativePlaySpeed,
        loadMode: loadMode ?? this.loadMode,
      );

  /// Returns [url].
  @override
  String get internalUri => url;

  /// Load [url].
  @override
  Future<AudioSource> load() => SoLoud.instance.loadUrl(
        url,
        httpClient: client,
        mode: loadMode,
      );
}
