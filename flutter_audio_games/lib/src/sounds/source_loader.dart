import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:http/http.dart';

import 'sound.dart';
import 'sound_type.dart';

/// A class for creating [AudioSource]s from [Sound]s.
class SourceLoader {
  /// Create an instance.
  SourceLoader({
    required this.soLoud,
    required this.assetBundle,
    this.httpClient,
  })  : _sounds = [],
        _sources = {};

  /// The so loud instance to work with.
  final SoLoud soLoud;

  /// The asset bundle to use.
  final AssetBundle assetBundle;

  /// The HTTP client to use.
  final Client? httpClient;

  /// The list of sounds which have been loaded, from oldest to newest.
  final List<Sound> _sounds;

  /// The loaded audio sources.
  final Map<Sound, AudioSource> _sources;

  /// Load [sound] into memory.
  Future<AudioSource> loadSound(final Sound sound) async {
    final s = _sources[sound];
    if (s != null) {
      return s;
    }
    final AudioSource source;
    try {
      switch (sound.soundType) {
        case SoundType.asset:
          source = await soLoud.loadAsset(
            sound.path,
            assetBundle: assetBundle,
            mode: sound.loadMode,
          );
        case SoundType.file:
          source = await soLoud.loadFile(
            sound.path,
            mode: sound.loadMode,
          );
        case SoundType.url:
          source = await soLoud.loadUrl(
            sound.path,
            mode: sound.loadMode,
            httpClient: httpClient,
          );
        case SoundType.tts:
          throw UnsupportedError(
            'You must use `soLoud` directly to convert text to speech.',
          );
      }
    } on SoLoudNotInitializedException {
      await soLoud.init();
      return loadSound(sound);
    }
    _sounds.add(sound);
    _sources[sound] = source;
    return source;
  }

  /// Dispose of a single [sound].
  Future<void> disposeSound(final Sound sound) async {
    final source = _sources[sound]!;
    await soLoud.disposeSource(source);
    _sounds.remove(sound);
    _sources.remove(sound);
  }

  /// Prune all unused sources.
  ///
  /// **Note**: This method may (and probably will) dispose of sources you don't
  /// want it to, like earcons for example. It is best to dispose of these
  /// yourself by using the [disposeSound] method.
  Future<void> disposeUnusedSources() async {
    for (final sound in List<Sound>.from(_sounds)) {
      final source = _sources[sound]!;
      if (source.handles.isEmpty) {
        await disposeSound(sound);
      }
    }
  }
}
