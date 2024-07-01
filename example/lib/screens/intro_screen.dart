import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../gen/assets.gen.dart';
import '../menus/main_menu.dart';

/// The intro screen.
class IntroScreen extends ConsumerWidget {
  /// Create an instance.
  const IntroScreen({
    super.key,
  });

  /// Build a widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final sound = Assets.sounds.music.intro.asSound(
      destroy: true,
      soundType: SoundType.asset,
    );
    return TransitionSoundBuilder(
      duration: const Duration(seconds: 2),
      builder: (final context) => const MainMenu(),
      sound: sound,
      loadingBuilder: LoadingScreen.new,
    );
  }
}
