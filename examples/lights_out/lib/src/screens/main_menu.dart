import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:url_launcher/url_launcher.dart';

import 'lights_out_screen.dart';

/// The main menu.
class MainMenu extends StatelessWidget {
  /// Create an instance.
  const MainMenu({
    super.key,
  });

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => AudioGameMenu(
        title: 'Lights Out',
        menuItems: [
          AudioGameMenuItem(
            title: 'Play Game',
            onActivate: (final innerContext) => innerContext
                .fadeMusicAndPushWidget((final _) => const LightsOutScreen()),
          ),
          AudioGameMenuItem(
            title: 'Game Description',
            onActivate: (final _) => launchUrl(
              Uri.parse(
                'https://en.wikipedia.org/wiki/Lights_Out_(game)',
              ),
            ),
          ),
          AudioGameMenuItem(
            title: 'Visit GitHub',
            onActivate: (final _) => launchUrl(
              Uri.parse(
                'https://github.com/chrisnorman7/flutter_audio_games',
              ),
            ),
          ),
        ],
      );
}
