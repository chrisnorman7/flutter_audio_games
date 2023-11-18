import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../gen/assets.gen.dart';
import '../levels/main_level.dart';
import '../providers.dart';

/// The main menu widget.
class MainMenu extends ConsumerWidget {
  /// Create an instance.
  const MainMenu({
    super.key,
  });

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final source = ref.watch(sourceProvider.call(context.synthizerContext));
    return AudioGameMenu(
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
      interfaceSoundsSource: source,
      musicSource: source,
      musicAssetPath: Assets.sounds.music.mainTheme,
      activateItemSoundAssetPath: Assets.sounds.menus.activate,
      selectItemSoundAssetPath: Assets.sounds.menus.select,
      musicFadeIn: 3.0,
      musicFadeOut: 4.0,
    );
  }
}
