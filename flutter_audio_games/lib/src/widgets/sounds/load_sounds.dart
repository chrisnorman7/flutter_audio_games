import 'package:backstreets_widgets/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

/// A widget which loads [sounds] before rendering [child].
class LoadSounds extends StatefulWidget {
  /// Create an instance.
  const LoadSounds({
    required this.sounds,
    required this.loading,
    required this.error,
    required this.child,
    super.key,
  });

  /// The sounds to load.
  final List<Sound> sounds;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The function to call to show a loading widget.
  final Widget Function() loading;

  /// The function to call to show an error widget.
  final ErrorWidgetCallback error;

  @override
  State<LoadSounds> createState() => LoadSoundsState();
}

/// State for [LoadSounds].
class LoadSoundsState extends State<LoadSounds> {
  /// Whether the sounds have been loaded.
  late bool _loaded;

  /// Any error that occurred.
  Object? _error;

  /// A stack trace to go with [_error].
  StackTrace? _stackTrace;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _loaded = false;
    _loadSounds();
  }

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final error = _error;
    if (error != null) {
      return widget.error(error, _stackTrace);
    } else if (_loaded) {
      return widget.child;
    } else {
      return widget.loading();
    }
  }

  /// Load all sounds.
  Future<void> _loadSounds() async {
    final sourceLoader = context.sourceLoader;
    try {
      for (final sound in widget.sounds) {
        await sourceLoader.loadSound(sound);
      }
      setState(() {
        _loaded = true;
      });
      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      setState(() {
        _error = e;
        _stackTrace = s;
      });
    }
  }
}
