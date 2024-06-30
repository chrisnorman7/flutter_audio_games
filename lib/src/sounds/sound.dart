import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:http/http.dart';

import 'loaded_sound.dart';
import 'sound_type.dart';

/// A single sound to play.
class Sound {
  /// Create an instance.
  const Sound({
    required this.path,
    required this.soundType,
    this.gain = 0.7,
  });

  /// The asset path to use.
  final String path;

  /// The type of the sound to play.
  final SoundType soundType;

  /// The gain to play [path] at.
  final double gain;

  /// Load this sound into memory.
  Future<LoadedSound> load({
    final bool looping = false,
    final AssetBundle? assetBundle,
    final LoadMode loadMode = LoadMode.memory,
    final Client? httpClient,
  }) async {
    final soLoud = SoLoud.instance;
    final AudioSource source;
    switch (soundType) {
      case SoundType.asset:
        source = await soLoud.loadAsset(
          path,
          assetBundle: assetBundle,
          mode: loadMode,
        );
      case SoundType.file:
        source = await soLoud.loadFile(
          path,
          mode: loadMode,
        );
      case SoundType.url:
        source = await soLoud.loadUrl(
          path,
          mode: loadMode,
          httpClient: httpClient,
        );
      case SoundType.tts:
        source = await soLoud.speechText(path);
    }
    return LoadedSound(sound: this, source: source);
  }
}
