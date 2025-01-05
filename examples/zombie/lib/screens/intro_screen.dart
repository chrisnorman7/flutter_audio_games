import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time/time.dart';

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
    return TimedBuilders(
      duration: 2.seconds,
      builders: [
        (final _) => PlaySound(sound: sound, child: const LoadingScreen()),
        (final _) => const MainMenu(),
      ],
    );
  }
}
