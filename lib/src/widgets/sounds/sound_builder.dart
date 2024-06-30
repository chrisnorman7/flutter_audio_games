import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:http/http.dart';

import '../../sounds/loaded_sound.dart';
import '../../sounds/sound.dart';

/// A widget which loads the given [sound].
class SoundBuilder extends StatelessWidget {
  /// Create an instance.
  const SoundBuilder({
    required this.sound,
    required this.builder,
    this.assetBundle,
    this.loadMode = LoadMode.memory,
    this.httpClient,
    this.loading = LoadingWidget.new,
    this.error = ErrorListView.withPositional,
    super.key,
  });

  /// The sound to load.
  final Sound sound;

  /// The function to call to build the widget.
  final Widget Function(BuildContext context, LoadedSound loadedSound) builder;

  /// The asset bundle to load from.
  final AssetBundle? assetBundle;

  /// The mode to use when loading.
  final LoadMode loadMode;

  /// The HTTP client to use when loading URLs.
  final Client? httpClient;

  /// The loading widget to use.
  final Widget Function() loading;

  /// The error widget to use.
  final Widget Function(Object error, StackTrace? stackTrace) error;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final future = sound.load(
      assetBundle: assetBundle,
      httpClient: httpClient,
      loadMode: loadMode,
    );
    return SimpleFutureBuilder(
      future: future,
      done: (final futureContext, final loadedSound) {
        if (loadedSound == null) {
          return const LoadingWidget();
        }
        return builder(futureContext, loadedSound);
      },
      loading: loading,
      error: error,
    );
  }
}
