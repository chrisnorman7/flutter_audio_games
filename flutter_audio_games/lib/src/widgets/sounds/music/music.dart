import 'dart:async';

import 'package:backstreets_widgets/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// The inherited version of a [Music].
///
/// Instances of [MusicProvider] will be dealt with when using
/// [Music.maybeOf()] or [Music.of()].
class MusicProvider extends InheritedWidget {
  /// Create an instance.
  const MusicProvider({
    required this.fadeIn,
    required this.fadeOut,
    required this.setPlaybackPosition,
    required super.child,
    super.key,
  });

  /// The function to fade in the music.
  final VoidCallback fadeIn;

  /// The function to fade out the music.
  final VoidCallback fadeOut;

  /// The function to call to set the playback position.
  final ValueChanged<Duration> setPlaybackPosition;

  /// Whether to notify listeners.
  @override
  bool updateShouldNotify(final MusicProvider oldWidget) =>
      fadeIn != oldWidget.fadeIn ||
      fadeOut != oldWidget.fadeOut ||
      setPlaybackPosition != oldWidget.setPlaybackPosition;
}

/// A widget that plays music.
class Music extends StatefulWidget {
  /// Create an instance.
  const Music({
    required this.sound,
    required this.child,
    required this.error,
    required this.loading,
    this.fadeInTime,
    this.fadeOutTime,
    super.key,
  });

  /// Possibly return an instance from higher up the widget tree.
  static MusicProvider? maybeOf(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MusicProvider>();

  /// Return an instance from higher up the widget tree.
  static MusicProvider of(final BuildContext context) => maybeOf(context)!;

  /// The loaded sound.
  final Sound sound;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The function to call to show an error widget.
  final ErrorWidgetCallback error;

  /// The function to call to show a loading widget.
  final Widget Function() loading;

  /// The fade in length to use.
  final Duration? fadeInTime;

  /// The fade out time to use.
  final Duration? fadeOutTime;

  /// Create state for this widget.
  @override
  MusicState createState() => MusicState();
}

/// State for [Music].
class MusicState extends State<Music> with WidgetsBindingObserver {
  /// Whether the music has been loaded.
  late bool _musicLoading;

  /// An error object.
  Object? _error;

  /// A stack trace to show.
  StackTrace? _stackTrace;

  /// The playing sound.
  SoundHandle? _handle;

  /// Whether [fadeOut] has been used.
  late bool _faded;

  /// Fade in [_handle].
  void fadeIn() {
    _faded = false;
    _handle?.maybeFade(fadeTime: widget.fadeInTime, to: widget.sound.volume);
  }

  /// Fade out [_handle].
  void fadeOut() {
    _faded = true;
    _handle?.maybeFade(fadeTime: widget.fadeOutTime, to: 0.0);
  }

  /// Load the music.
  Future<void> _loadMusic() async {
    final sound = widget.sound.copyWith(
      volume: widget.fadeInTime == null ? null : 0.0,
    );
    try {
      final h = await context.playSound(sound);
      if (mounted) {
        setState(() {
          _handle = h;
        });
        if (widget.fadeInTime != null) {
          fadeIn();
        }
      } else {
        await h.stop();
        _handle = null;
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      setState(() {
        _error = e;
        _stackTrace = s;
      });
    }
  }

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _musicLoading = false;
    _faded = false;
    WidgetsBinding.instance.addObserver(this);
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _handle?.stop(fadeOutTime: widget.fadeOutTime);
    _handle = null;
    WidgetsBinding.instance.removeObserver(this);
  }

  /// Pause and resume music.
  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _handle?.pause();
    } else if (state == AppLifecycleState.resumed) {
      _handle?.unpause();
    }
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final error = _error;
    if (error != null) {
      return widget.error(error, _stackTrace);
    }
    if (!_musicLoading) {
      _musicLoading = true;
      _loadMusic();
    }
    final soLoud = context.soLoud;
    final handle = _handle;
    if (handle == null) {
      return widget.loading();
    }
    if (handle != null && !_faded) {
      handle.volume.value = widget.sound.volume;
    }
    return MusicProvider(
      fadeIn: fadeIn,
      fadeOut: fadeOut,
      setPlaybackPosition: (final position) {
        final h = _handle;
        if (h != null) {
          soLoud.seek(h, position);
        }
      },
      child: widget.child,
    );
  }
}
