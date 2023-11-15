import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../music_builder/music_builder.dart';
import 'audio_game_menu_item.dart';
import 'audio_game_menu_item_list_tile.dart';

/// A menu in an audio game.
class AudioGameMenu extends StatelessWidget {
  /// Create an instance.
  const AudioGameMenu({
    required this.title,
    required this.menuItems,
    required this.interfaceSoundsSource,
    required this.musicSource,
    this.musicAssetPath,
    this.selectItemSoundAssetPath,
    this.activateItemSoundAssetPath,
    this.musicGain = 0.7,
    this.selectSoundGame = 0.7,
    this.selectItemSoundLooping = false,
    this.activateSoundGain = 0.7,
    this.musicFadeIn,
    this.musicFadeOut,
    super.key,
  });

  /// The title of this menu.
  final String title;

  /// The menu items in this menu.
  final List<AudioGameMenuItem> menuItems;

  /// The asset path for music.
  final String? musicAssetPath;

  /// The gain for music.
  final double musicGain;

  /// The asset path for the sound to use when selecting an item in this menu.
  final String? selectItemSoundAssetPath;

  /// The gain for the select sound.
  final double selectSoundGame;

  /// Whether or not select sounds should loop.
  final bool selectItemSoundLooping;

  /// The asset path for the sound to use when activating an item in this menu.
  final String? activateItemSoundAssetPath;

  /// The gain for the activate sound.
  final double activateSoundGain;

  /// The source to play interface sounds through.
  final Source interfaceSoundsSource;

  /// The source to play music through.
  final Source musicSource;

  /// The fade in time for music.
  final double? musicFadeIn;

  /// The music fade out time.
  final double? musicFadeOut;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final music = musicAssetPath;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: music == null
          ? Builder(builder: builder)
          : MusicBuilder(
              assetPath: music,
              source: musicSource,
              fadeInLength: musicFadeIn,
              fadeOutLength: musicFadeOut,
              gain: musicGain,
              builder: builder,
            ),
    );
  }

  /// Build the widget.
  Widget builder(final BuildContext innerContext) => ListView(
        children: [
          for (var i = 0; i < menuItems.length; i++)
            AudioGameMenuItemListTile(
              menuItem: menuItems[i],
              selectSoundAssetPath: selectItemSoundAssetPath,
              activateSoundAssetPath: activateItemSoundAssetPath,
              source: interfaceSoundsSource,
              autofocus: i == 0,
              activateSoundGain: activateSoundGain,
              looping: selectItemSoundLooping,
              selectSoundGame: selectSoundGame,
            ),
        ],
      );
}
