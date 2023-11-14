import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import '../gen/assets.gen.dart';
import '../providers.dart';

/// The loaindg screen.
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
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Audio Game Example'),
      ),
      body: const Focus(
        autofocus: true,
        child: CircularProgressIndicator(
          semanticsLabel: 'Loading game...',
        ),
      ),
    );
  }
}
