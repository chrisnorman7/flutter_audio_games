import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
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
  /// The music to play.
  late LoadedSound musicSound;

  /// The activate sound to use.
  late LoadedSound activateSound;

  /// The select sound to use.
  late LoadedSound selectSound;

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final future = loadSounds();
    return SimpleFutureBuilder(
      future: future,
      done: (final context, final value) {
        if (value ?? false) {
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
            music: musicSound,
            activateItemSound: activateSound,
            selectItemSound: selectSound,
            musicFadeInTime: const Duration(seconds: 3),
            musicFadeOutTime: const Duration(seconds: 4),
          );
        }
        return const LoadingScreen();
      },
      loading: LoadingScreen.new,
      error: ErrorScreen.withPositional,
    );
  }

  /// Load sounds.
  Future<bool> loadSounds() async {
    final music = Assets.sounds.music.mainTheme.asSound(
      soundType: SoundType.asset,
    );
    musicSound = await ref.read(loadedSoundProvider(music).future);
    final activate = Assets.sounds.menus.activate.asSound(
      soundType: SoundType.asset,
    );
    activateSound = await ref.read(loadedSoundProvider(activate).future);
    final select = Assets.sounds.menus.select.asSound(
      soundType: SoundType.asset,
    );
    selectSound = await ref.read(loadedSoundProvider(select).future);
    return true;
  }
}
