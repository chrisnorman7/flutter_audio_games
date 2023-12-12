import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import '../gen/assets.gen.dart';
import '../menus/main_menu.dart';
import '../providers.dart';
import 'loading_screen.dart';

/// The intro screen.
class IntroScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const IntroScreen({
    super.key,
  });

  /// Create state for this widget.
  @override
  IntroScreenState createState() => IntroScreenState();
}

/// State for [IntroScreen].
class IntroScreenState extends ConsumerState<IntroScreen> {
  /// The audio source.
  late final DirectSource source;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    final synthizerContext = context.synthizerContext
      ..defaultPannerStrategy.value = PannerStrategy.hrtf;
    source = ref.read(sourceProvider(synthizerContext))..gain.value = 0.5;
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    source.destroy();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final source = ref.watch(sourceProvider(context.synthizerContext));
    return TransitionSoundBuilder(
      duration: const Duration(seconds: 2),
      loadingBuilder: (final context) => const LoadingScreen(),
      builder: (final context) => const MainMenu(),
      sound: Assets.sounds.music.intro,
      source: source,
    );
  }
}
