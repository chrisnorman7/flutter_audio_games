import 'package:backstreets_widgets/screens.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../../sounds/sound.dart';
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
    this.music,
    this.selectItemSound,
    this.activateItemSound,
    this.selectItemSoundLooping = false,
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

  /// The music to play for this menu.
  ///
  /// If [music] is not `null`, then a [Music] widget will be added to the
  /// widget tree.
  final Sound? music;

  /// The sound to play when selecting an item in this menu.
  ///
  /// If [selectItemSound] is not `null`, then the sound will be heard
  /// when moving to a menu item with the keyboard, or touching it on the
  /// screen.
  final Sound? selectItemSound;

  /// Whether or not select sounds should loop.
  ///
  /// If [selectItemSoundLooping] is `true`, and [selectItemSound] is
  /// not `null`, then the sound which is heard when moving to a menu item will
  /// loop.
  final bool selectItemSoundLooping;

  /// The sound to play when activating an item in this menu.
  ///
  /// If [activateItemSound] is not `null`, the sound will be heard
  /// when activating menu items.
  final Sound? activateItemSound;

  /// The source to play menu sounds through.
  ///
  /// This source only applies to [selectItemSound], and
  /// [activateItemSound].
  final Source interfaceSoundsSource;

  /// The source to play [music] through.
  final Source musicSource;

  /// The fade in time for [music].
  ///
  /// If [music] is `null`, [musicFadeIn] has no effect.
  final double? musicFadeIn;

  /// The fade out time for [music].
  ///
  /// If [music] is `null`, [musicFadeOut] has no effect.
  ///
  /// If [musicFadeOut] is `null`, the menu [music] will end when the menu is
  /// popped.
  final double? musicFadeOut;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final musicSound = music;
    return SimpleScaffold(
      title: title,
      body: musicSound == null
          ? Builder(builder: builder)
          : Music(
              music: musicSound,
              source: musicSource,
              fadeInLength: musicFadeIn,
              fadeOutLength: musicFadeOut,
              child: Builder(builder: builder),
            ),
    );
  }

  /// Build the widget.
  Widget builder(final BuildContext innerContext) => ListView.builder(
        itemBuilder: (final context, final index) => AudioGameMenuItemListTile(
          menuItem: menuItems[index],
          selectSound: selectItemSound,
          activateSound: activateItemSound,
          source: interfaceSoundsSource,
          autofocus: index == 0,
          looping: selectItemSoundLooping,
        ),
        itemCount: menuItems.length,
        shrinkWrap: true,
      );
}
