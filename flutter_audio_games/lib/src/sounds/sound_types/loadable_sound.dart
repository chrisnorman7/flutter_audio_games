import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A [Sound] with a [loadMode].
abstract class LoadableSound extends Sound {
  /// Create an instance.
  const LoadableSound({
    required super.destroy,
    this.loadMode = LoadMode.memory,
    super.volume,
    super.looping,
    super.loopingStart,
    super.position,
    super.paused,
    super.relativePlaySpeed,
  });

  /// The load mode to use.
  final LoadMode loadMode;
}
