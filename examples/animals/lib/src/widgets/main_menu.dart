import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_audio_games/touch.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../gen/assets.gen.dart';
import 'main_level.dart';

/// The main menu.
class MainMenu extends StatelessWidget {
  /// Create an instance.
  const MainMenu({
    super.key,
  });

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final music = Assets.sounds.music.mainTheme.asSound(
      destroy: false,
      soundType: SoundType.asset,
      looping: true,
    );
    final select = Assets.sounds.menus.select.asSound(
      destroy: true,
      soundType: SoundType.asset,
    );
    final activate = Assets.sounds.menus.activate.asSound(
      destroy: true,
      soundType: SoundType.asset,
    );
    return TouchMenu(
      title: 'Main Menu',
      menuItems: [
        AudioGameMenuItem(
          title: 'Play game',
          onActivate: (final innerContext) =>
              innerContext.fadeMusicAndPushWidget(
            (final context) => const MainLevel(),
          ),
          earcon: Assets.sounds.speech.playGame.asSound(
            destroy: false,
            soundType: SoundType.asset,
          ),
        ),
        AudioGameMenuItem(
          title: 'Visit GitHub',
          onActivate: (final innerContext) => launchUrl(
            Uri.parse('https://github.com/chrisnorman7/flutter_audio_games'),
          ),
          earcon: Assets.sounds.speech.visitGithub.asSound(
            destroy: false,
            soundType: SoundType.asset,
          ),
        ),
      ],
      music: music,
      selectItemSound: select,
      activateItemSound: activate,
      musicFadeInTime: const Duration(seconds: 4),
      musicFadeOutTime: const Duration(seconds: 2),
    );
  }
}
