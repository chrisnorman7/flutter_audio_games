import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';

import 'sound.dart';
import 'sound_type.dart';

/// The type for functions which load sources from sounds.
typedef LoadSound = Future<AudioSource> Function(
  SourceLoader sourceLoader,
  Sound sound,
);

/// The default custom loader.
Future<AudioSource> defaultLoadCustomSound(
  final SourceLoader sourceLoader,
  final Sound sound,
) async {
  throw UnimplementedError('No custom sound loader has been set.');
}

/// A class for creating [AudioSource]s from [Sound]s.
class SourceLoader {
  /// Create an instance.
  SourceLoader({
    required this.assetBundle,
    this.httpClient,
    this.loadCustomSound = defaultLoadCustomSound,
    final String loggerName = 'SourceLoader',
  })  : _sounds = [],
        _sources = {},
        logger = Logger(loggerName);

  /// The asset bundle to use.
  final AssetBundle assetBundle;

  /// The HTTP client to use.
  final Client? httpClient;

  /// The function to use to load custom sounds.
  final LoadSound loadCustomSound;

  /// The list of sounds which have been loaded, from oldest to newest.
  final List<Sound> _sounds;

  /// The loaded audio sources.
  final Map<Sound, AudioSource> _sources;

  /// The logger to use.
  late final Logger logger;

  /// The So Loud instance to work with.
  SoLoud get soLoud => SoLoud.instance;

  /// Load [sound] from [buffer].
  ///
  /// This method uses `SoLoud.instance.loadMem`.
  Future<AudioSource> loadSoundBuffer(
    final Sound sound,
    final Uint8List buffer,
  ) async {
    final uri = sound.internalUri;
    logger.info('Loading $uri.');
    final s = _sources[sound];
    if (s != null) {
      logger.info('$uri has already been loaded as $s.');
      return s;
    }
    return soLoud.loadMem(sound.path, buffer);
  }

  /// Load [sound] into memory.
  Future<AudioSource> loadSound(final Sound sound) async {
    final uri = sound.internalUri;
    logger.info('Loading $uri.');
    final s = _sources[sound];
    if (s != null) {
      logger.info('$uri has already been loaded as $s.');
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
        case SoundType.custom:
          source = await loadCustomSound(this, sound);
      }
      logger.info('Loaded $uri as $source.');
    } on SoLoudNotInitializedException {
      logger.warning('The SoLoud library has not yet been initialised.');
      await soLoud.init();
      return loadSound(sound);
    }
    if (sound.soundType != SoundType.custom) {
      _sounds.add(sound);
      _sources[sound] = source;
    }
    return source;
  }

  /// Dispose of a single [sound].
  Future<void> disposeSound(final Sound sound) async {
    logger.info('Disposing of ${sound.internalUri}.');
    final source = _sources[sound]!;
    await soLoud.disposeSource(source);
    _sounds.remove(sound);
    final s = _sources.remove(sound);
    if (s != null) {
      logger.info('Disposing of source $s.');
      await SoLoud.instance.disposeSource(s);
    } else {
      logger.warning('No source found.');
    }
  }

  /// Prune all unused sources.
  ///
  /// **Note**: This method may (and probably will) dispose of sources you don't
  /// want it to, like earcons for example. It is best to dispose of these
  /// yourself by using the [disposeSound] method.
  Future<void> disposeUnusedSources() async {
    logger.info('Disposing of unused sources.');
    for (final sound in List<Sound>.from(_sounds)) {
      final source = _sources[sound]!;
      if (source.handles.isEmpty) {
        await disposeSound(sound);
      }
    }
  }
}
