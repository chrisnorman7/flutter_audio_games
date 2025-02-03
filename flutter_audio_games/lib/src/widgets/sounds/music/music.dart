import 'dart:async';

import 'package:backstreets_widgets/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

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
  static InheritedMusic? maybeOf(final BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedMusic>();

  /// Return an instance from higher up the widget tree.
  static InheritedMusic of(final BuildContext context) => maybeOf(context)!;

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
  /// An error object.
  Object? _error;

  /// A stack trace to show.
  StackTrace? _stackTrace;

  /// The playing sound.
  SoundHandle? handle;

  /// Whether [fadeOut] has been used.
  late bool _faded;

  /// Fade in [handle].
  void fadeIn() {
    _faded = false;
    handle?.maybeFade(
      fadeTime: widget.fadeInTime,
      to: widget.sound.volume,
    );
  }

  /// Fade out [handle].
  void fadeOut() {
    _faded = true;
    handle?.maybeFade(fadeTime: widget.fadeOutTime, to: 0.0);
  }

  /// Load the music.
  Future<void> _loadMusic() async {
    final sound = widget.sound.copyWith(
      volume: widget.fadeInTime == null ? null : 0.0,
    );
    try {
      final h = await context.playSound(sound);
      if (mounted) {
        handle = h;
        if (widget.fadeInTime != null) {
          fadeIn();
        }
      } else {
        await h.stop();
        handle = null;
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
    _faded = false;
    WidgetsBinding.instance.addObserver(this);
    _loadMusic();
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    final h = handle;
    if (h != null) {
      h.stop(fadeOutTime: widget.fadeOutTime);
    }
    handle = null;
    WidgetsBinding.instance.removeObserver(this);
  }

  /// Pause and resume music.
  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      handle?.pause();
    } else if (state == AppLifecycleState.resumed) {
      handle?.unpause();
    }
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final error = _error;
    if (error != null) {
      return widget.error(error, _stackTrace);
    }
    final soLoud = context.soLoud;
    final h = handle;
    if (h == null) {
      return widget.loading();
    }
    if (h != null && !_faded) {
      h.volume.value = widget.sound.volume;
    }
    return InheritedMusic(
      fadeIn: fadeIn,
      fadeOut: fadeOut,
      setPlaybackPosition: (final position) {
        final h = handle;
        if (h != null) {
          soLoud.seek(h, position);
        }
      },
      child: widget.child,
    );
  }
}
