import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_audio_games/touch.dart';
import 'package:url_launcher/url_launcher.dart';

import '../gen/assets.gen.dart';

/// The main menu to use.
class MainMenu extends StatelessWidget {
  /// Create an instance.
  const MainMenu({
    super.key,
  });

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => TouchMenu(
        title: 'Main Menu',
        menuItems: [
          AudioGameMenuItem(
            title: 'Launch flutter.dev',
            onActivate: (final innerContext) => launchUrl(
              Uri.parse('https://flutter.dev'),
            ),
          ),
          AudioGameMenuItem(
            title: 'Launch dart.dev',
            onActivate: (final innerContext) => launchUrl(
              Uri.parse('https://dart.dev'),
            ),
          ),
          AudioGameMenuItem(
            title: 'Launch chrisnorman7 on GitHub',
            onActivate: (final innerContext) => launchUrl(
              Uri.parse('https://github.com/chrisnorman7/'),
            ),
          ),
        ],
        activateItemSound: Assets.sounds.menus.activate.asSound(
          destroy: true,
          soundType: SoundType.asset,
        ),
        selectItemSound: Assets.sounds.menus.select.asSound(
          destroy: false,
          soundType: SoundType.asset,
        ),
        music: Assets.sounds.music.mainTheme.asSound(
          destroy: false,
          soundType: SoundType.asset,
          looping: true,
        ),
        musicFadeInTime: const Duration(seconds: 2),
        musicFadeOutTime: const Duration(seconds: 4),
      );
}
