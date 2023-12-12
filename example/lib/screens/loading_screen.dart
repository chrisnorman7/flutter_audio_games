import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import '../gen/assets.gen.dart';
import '../providers.dart';

/// The loading screen.
class LoadingScreen extends ConsumerWidget {
  /// Create an instance.
  const LoadingScreen({
    super.key,
  });

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final source = ref.watch(sourceProvider(context.synthizerContext));
    context.playSound(
      assetPath: Assets.sounds.music.intro,
      source: source,
      destroy: true,
    );
    return const SimpleScaffold(
      title: 'Flutter Audio Game Example',
      body: Focus(
        autofocus: true,
        child: CircularProgressIndicator(
          semanticsLabel: 'Loading game...',
        ),
      ),
    );
  }
}
