import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The loading screen.
class LoadingScreen extends ConsumerWidget {
  /// Create an instance.
  const LoadingScreen({
    super.key,
  });

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) =>
      const SimpleScaffold(
        title: 'Flutter Audio Game Example',
        body: Focus(
          autofocus: true,
          child: CircularProgressIndicator(
            semanticsLabel: 'Loading game...',
          ),
        ),
      );
}
