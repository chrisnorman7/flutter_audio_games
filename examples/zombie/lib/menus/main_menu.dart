import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:url_launcher/url_launcher.dart';

import '../gen/assets.gen.dart';
import '../levels/main_level.dart';

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
    final music = Assets.sounds.music.mainTheme.asSound(
      destroy: false,
      soundType: SoundType.asset,
      looping: true,
      loadMode: LoadMode.disk,
      volume: 0.2,
    );
    final activateItemSound = Assets.sounds.menus.activate.asSound(
      destroy: true,
      soundType: SoundType.asset,
    );
    final selectItemSound = Assets.sounds.menus.select.asSound(
      destroy: false,
      soundType: SoundType.asset,
    );
    return AudioGameMenu(
      title: 'Main Menu',
      menuItems: [
        AudioGameMenuItem(
          title: 'Play Game',
          onActivate: (final innerContext) {
            innerContext.fadeMusicAndPushWidget(
              (final context) => const MainLevel(),
            );
          },
        ),
        AudioGameMenuItem(
          title: 'Visit chrisnorman7 on GitHub',
          onActivate: (final innerContext) => launchUrl(
            Uri.parse('https://github.com/chrisnorman7/'),
          ),
        ),
      ],
      music: music,
      activateItemSound: activateItemSound,
      selectItemSound: selectItemSound,
      musicFadeInTime: const Duration(seconds: 3),
      musicFadeOutTime: const Duration(seconds: 4),
    );
  }
}
