import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:http/http.dart';

/// Manage the life cycle of [SoLoud].
///
/// This widget should be placed as close to the top of the widget tree as
/// possible, preferably above [MaterialApp].
class SoLoudScope extends StatefulWidget {
  /// Create an instance.
  const SoLoudScope({
    required this.child,
    this.httpClient,
    this.loggerName = 'SoLoudScope',
    this.device,
    this.automaticCleanup = false,
    this.sampleRate = 44100,
    this.bufferSize = 2048,
    this.channels = Channels.stereo,
    super.key,
  });

  /// Get the nearest state or `null`.
  static SoLoudScopeState? maybeOf(final BuildContext context) =>
      context.findAncestorStateOfType<SoLoudScopeState>();

  /// Get the nearest state.
  static SoLoudScopeState of(final BuildContext context) {
    final scope = maybeOf(context);
    if (scope == null) {
      throw StateError(
        // ignore: lines_longer_than_80_chars
        'No `SoLoudScope` was found. If you are calling this method from the top of your widget tree, consider wrapping the widget in a `Builder`.',
      );
    }
    return scope;
  }

  /// The HTTP client to use when loading sounds from urls.
  final Client? httpClient;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The name of the logger to use.
  final String loggerName;

  /// Passed to [SoLoud.init].
  final PlaybackDevice? device;

  /// Passed to [SoLoud.init].
  final bool automaticCleanup;

  /// Passed to [SoLoud.init].
  final int sampleRate;

  /// Passed to [SoLoud.init].
  final int bufferSize;

  /// Passed to [SoLoud.init].
  final Channels channels;

  /// Create state for this widget.
  @override
  SoLoudScopeState createState() => SoLoudScopeState();
}

/// State for [SoLoudScope].
class SoLoudScopeState extends State<SoLoudScope> {
  /// Automatic cleanup.
  bool get automaticCleanup => widget.automaticCleanup;

  /// The buffer size to use.
  int get bufferSize => widget.bufferSize;

  /// The channels to use.
  Channels get channels => widget.channels;

  /// The playback device to use.
  PlaybackDevice? get device => widget.device;

  /// The sample rate to use.
  int get sampleRate => widget.sampleRate;

  /// The so loud instance to use.
  SoLoud get soLoud => sourceLoader.soLoud;

  /// The source loader to use.
  late final SourceLoader sourceLoader;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    sourceLoader = SourceLoader(
      loggerName: widget.loggerName,
      playbackDevice: widget.device,
      automaticCleanup: widget.automaticCleanup,
      bufferSize: widget.bufferSize,
      channels: widget.channels,
      sampleRate: widget.sampleRate,
    );
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    sourceLoader.disposeUnusedSources();
    sourceLoader.soLoud.deinit();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => widget.child;
}
