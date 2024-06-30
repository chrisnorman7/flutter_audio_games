import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../gen/assets.gen.dart';
import '../menus/main_menu.dart';
import '../providers.dart';

/// The intro screen.
class IntroScreen extends ConsumerWidget {
  /// Create an instance.
  const IntroScreen({
    super.key,
  });

  /// Build a widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(
      loadedSoundProvider(
        Assets.sounds.music.intro.asSound(
          soundType: SoundType.asset,
          gain: 1.0,
        ),
      ),
    );
    return value.when(
      data: (final sound) => TransitionSoundBuilder(
        duration: const Duration(seconds: 2),
        builder: (final context) => const MainMenu(),
        sound: sound,
        loadingBuilder: LoadingScreen.new,
      ),
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }
}
