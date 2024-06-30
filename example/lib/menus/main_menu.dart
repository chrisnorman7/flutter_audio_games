import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../gen/assets.gen.dart';
import '../levels/main_level.dart';
import '../providers.dart';

/// The main menu widget.
class MainMenu extends ConsumerStatefulWidget {
  /// Create an instance.
  const MainMenu({
    super.key,
  });

  /// Create state for this widget.
  @override
  MainMenuState createState() => MainMenuState();
}

/// State for [MainMenu].
class MainMenuState extends ConsumerState<MainMenu> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final musicSound = Assets.sounds.music.mainTheme.asSound(
      soundType: SoundType.asset,
    );
    final value = ref.watch(loadedSoundProvider(musicSound));
    return value.when(
      data: (final sound) => AudioGameMenu(
        title: 'Main Menu',
        menuItems: [
          AudioGameMenuItem(
            title: 'Play Game',
            onActivate: (final innerContext) {
              innerContext
                  .fadeMusicAndPushWidget((final context) => const MainLevel());
            },
          ),
          AudioGameMenuItem(
            title: 'Visit chrisnorman7 on GitHub',
            onActivate: (final innerContext) => launchUrl(
              Uri.parse('https://github.com/chrisnorman7/'),
            ),
          ),
        ],
        music: sound,
        activateItemSound: Assets.sounds.menus.activate.asSound(
          soundType: SoundType.asset,
        ),
        selectItemSound: Assets.sounds.menus.select.asSound(
          soundType: SoundType.asset,
        ),
        musicFadeInTime: const Duration(seconds: 3),
        musicFadeOutTime: const Duration(seconds: 4),
      ),
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }
}
