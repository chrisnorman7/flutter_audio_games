import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:logging/logging.dart';

/// A class for creating [AudioSource]s from [Sound]s.
class SourceLoader {
  /// Create an instance.
  SourceLoader({
    final String loggerName = 'SourceLoader',
    this.playbackDevice,
    this.automaticCleanup = false,
    this.sampleRate = 44100,
    this.bufferSize = 2048,
    this.channels = Channels.stereo,
  })  : _sounds = [],
        _protectedSounds = {},
        _sources = {},
        logger = Logger(loggerName);

  /// The list of sounds which have been loaded, from oldest to newest.
  final List<Sound> _sounds;

  /// The URIs of protected sounds.
  late final Set<String> _protectedSounds;

  /// The loaded audio sources.
  final Map<String, AudioSource> _sources;

  /// The logger to use.
  late final Logger logger;

  /// Passed to [SoLoud.init].
  final PlaybackDevice? playbackDevice;

  /// Passed to [SoLoud.init].
  final bool automaticCleanup;

  /// Passed to [SoLoud.init].
  final int sampleRate;

  /// Passed to [SoLoud.init].
  final int bufferSize;

  /// Passed to [SoLoud.init].
  final Channels channels;

  /// The So Loud instance to work with.
  SoLoud get soLoud => SoLoud.instance;

  /// Load [sound] into memory.
  Future<AudioSource> loadSound(final Sound sound) async {
    final uri = sound.internalUri;
    logger.info('Loading $uri.');
    final s = _sources[uri];
    if (s != null) {
      logger.info('$uri has already been loaded as $s.');
      return s;
    }
    final AudioSource source;
    try {
      source = await sound.load();
      logger.info('Loaded $uri as $source.');
      await disposeUnusedSources(count: 1);
    } on SoLoudNotInitializedException {
      logger.warning('The SoLoud library has not yet been initialised.');
      await soLoud.init(
        device: playbackDevice,
        automaticCleanup: automaticCleanup,
        bufferSize: bufferSize,
        channels: channels,
        sampleRate: sampleRate,
      );
      return loadSound(sound);
    }
    _sounds.add(sound);
    _sources[uri] = source;
    return source;
  }

  /// Dispose of a single [sound].
  Future<void> disposeSound(final Sound sound) async {
    final uri = sound.internalUri;
    logger.info('Disposing of sound $uri.');
    _sounds.remove(sound);
    final source = _sources.remove(uri);
    if (source == null) {
      logger.warning('No source found for $uri.');
    } else {
      logger.info('Disposing of source $uri.');
      await SoLoud.instance.disposeSource(source);
    }
  }

  /// Prune all unused sources.
  ///
  /// **Note**: This method may (and probably will) dispose of sources you don't
  /// want it to, like earcons for example. It is best to dispose of these
  /// yourself by using the [disposeSound] method.
  ///
  /// If [count] is not `null`, then no more than [count] sources will be
  /// disposed.
  Future<void> disposeUnusedSources({final int? count}) async {
    logger.info('Disposing of unused sources.');
    var disposed = 0;
    for (final sound in List<Sound>.from(_sounds)) {
      final uri = sound.internalUri;
      if (_protectedSounds.contains(uri)) {
        logger.info('Skipping over protected sound $uri.');
        continue;
      }
      final source = _sources[uri];
      if (source != null && source.handles.isEmpty) {
        await disposeSound(sound);
        disposed++;
        if (count != null && disposed >= count) {
          break;
        }
      }
    }
  }

  /// Protect [sound].
  ///
  /// **NOTE:**
  ///
  /// - Sounds are protected based on their type and path.
  /// - Protecting [sound] *will* prevent [disposeUnusedSources] from disposing
  ///   of it.
  /// - Protecting [sound] *will not* prevent [disposeSound] from disposing of
  ///   it.
  void protectSound(final Sound sound) {
    final uri = sound.internalUri;
    logger.info('Protecting sound $uri.');
    _protectedSounds.add(uri);
  }

  /// Unprotect [sound].
  ///
  /// Once [sound] has been unprotected, it will once again be disposed by
  /// [disposeUnusedSources] at the proper time.
  void unprotectSound(final Sound sound) {
    final uri = sound.internalUri;
    logger.info('Unprotecting sound $uri.');
    _protectedSounds.remove(uri);
  }
}
