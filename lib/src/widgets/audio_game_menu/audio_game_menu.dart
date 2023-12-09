import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../sounds/music/music.dart';
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
    this.selectItemSoundGame = 0.7,
    this.selectItemSoundLooping = false,
    this.activateSoundGain = 0.7,
    this.musicFadeIn,
    this.musicFadeOut,
    super.key,
  });

  /// The title of the resulting [Scaffold] widget..
  final String title;

  /// The menu items in this menu.
  ///
  /// If the [menuItems] list is empty, then the menu will only show a title.
  final List<AudioGameMenuItem> menuItems;

  /// The asset path for music.
  ///
  /// If [musicAssetPath] is not `null`, then a [Music] widget will be added to
  /// the widget tree.
  final String? musicAssetPath;

  /// The gain for music.
  ///
  /// If [musicAssetPath] is `null`, [musicGain] will have no effect.
  final double musicGain;

  /// The asset path for the sound to use when selecting an item in this menu.
  ///
  /// If [selectItemSoundAssetPath] is not `null`, then the sound will be heard
  /// when moving to a menu item with the keyboard, or touching it on the
  /// screen.
  final String? selectItemSoundAssetPath;

  /// The gain for the select sound.
  ///
  /// If [selectItemSoundAssetPath] is `null`, [selectItemSoundGame] has no
  /// effect.
  final double selectItemSoundGame;

  /// Whether or not select sounds should loop.
  ///
  /// If [selectItemSoundLooping] is `true`, and [selectItemSoundAssetPath] is
  /// not `null`, then the sound which is heard when moving to a menu item will
  /// loop.
  final bool selectItemSoundLooping;

  /// The asset path for the sound to use when activating an item in this menu.
  ///
  /// If [activateItemSoundAssetPath] is not `null`, the sound will be heard
  /// when activating menu items.
  final String? activateItemSoundAssetPath;

  /// The gain for the activate sound.
  ///
  /// If [activateItemSoundAssetPath] is `null`, [activateSoundGain] will have
  /// no effect.
  final double activateSoundGain;

  /// The source to play menu sounds through.
  ///
  /// This source only applies to [selectItemSoundAssetPath], and
  /// [activateItemSoundAssetPath].
  final Source interfaceSoundsSource;

  /// The source to play music through.
  ///
  /// This source applies to [musicAssetPath].
  final Source musicSource;

  /// The fade in time for music.
  ///
  /// If [musicAssetPath] is `null`, [musicFadeIn] has no effect.
  ///
  /// If [musicFadeIn] is `null`, the menu music will begin playing at
  /// [musicGain] right away.
  final double? musicFadeIn;

  /// The music fade out time.
  ///
  /// If [musicAssetPath] is `null`, [musicFadeOut] has no effect.
  ///
  /// If [musicFadeOut] is `null`, the menu music will end when the menu is
  /// popped..
  final double? musicFadeOut;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final music = musicAssetPath;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: music == null
          ? Builder(builder: builder)
          : Music(
              assetPath: music,
              source: musicSource,
              fadeInLength: musicFadeIn,
              fadeOutLength: musicFadeOut,
              gain: musicGain,
              child: Builder(builder: builder),
            ),
    );
  }

  /// Build the widget.
  Widget builder(final BuildContext innerContext) => ListView.builder(
        itemBuilder: (final context, final index) => AudioGameMenuItemListTile(
          menuItem: menuItems[index],
          selectSoundAssetPath: selectItemSoundAssetPath,
          activateSoundAssetPath: activateItemSoundAssetPath,
          source: interfaceSoundsSource,
          autofocus: index == 0,
          activateSoundGain: activateSoundGain,
          looping: selectItemSoundLooping,
          selectSoundGain: selectItemSoundGame,
        ),
        itemCount: menuItems.length,
        shrinkWrap: true,
      );
}
