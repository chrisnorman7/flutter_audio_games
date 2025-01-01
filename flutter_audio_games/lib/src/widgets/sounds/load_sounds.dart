import 'package:backstreets_widgets/typedefs.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../../flutter_audio_games.dart';

/// A widget which loads [sounds] before rendering [child].
class LoadSounds extends StatelessWidget {
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

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final future = _loadSounds(context);
    return SimpleFutureBuilder(
      future: future,
      done: (final _, final __) => child,
      loading: loading,
      error: error,
    );
  }

  /// Load all [sounds].
  Future<void> _loadSounds(final BuildContext context) async {
    final sourceLoader = context.sourceLoader;
    for (final sound in sounds) {
      await sourceLoader.loadSound(sound);
    }
  }
}
