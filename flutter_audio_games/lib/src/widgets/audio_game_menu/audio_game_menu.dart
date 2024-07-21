import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';

import '../../sounds/sound.dart';
import '../sounds/music/maybe_music.dart';
import '../sounds/music/music.dart';
import 'audio_game_menu_item.dart';
import 'audio_game_menu_item_list_tile.dart';

/// A menu in an audio game.
class AudioGameMenu extends StatelessWidget {
  /// Create an instance.
  const AudioGameMenu({
    required this.title,
    required this.menuItems,
    this.music,
    this.selectItemSound,
    this.activateItemSound,
    this.musicFadeInTime,
    this.musicFadeOutTime,
    this.textStyle = const TextStyle(fontSize: 20),
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

  /// The sound to play when activating an item in this menu.
  ///
  /// If [activateItemSound] is not `null`, the sound will be heard
  /// when activating menu items.
  final Sound? activateItemSound;

  /// The fade in time for [music].
  ///
  /// If [music] is `null`, [musicFadeInTime] has no effect.
  final Duration? musicFadeInTime;

  /// The fade out time for [music].
  ///
  /// If [music] is `null`, [musicFadeOutTime] has no effect.
  ///
  /// If [musicFadeOutTime] is `null`, the menu [music] will end when the menu
  /// is popped.
  final Duration? musicFadeOutTime;

  /// The text style to use.
  final TextStyle? textStyle;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final musicSound = music;
    return SimpleScaffold(
      title: title,
      body: MaybeMusic(
        music: musicSound,
        builder: builder,
        fadeInTime: musicFadeInTime,
        fadeOutTime: musicFadeOutTime,
      ),
    );
  }

  /// Build the widget.
  Widget builder(final BuildContext innerContext) => ListView.builder(
        itemBuilder: (final context, final index) => AudioGameMenuItemListTile(
          menuItem: menuItems[index],
          selectSound: selectItemSound,
          activateSound: activateItemSound,
          autofocus: index == 0,
          textStyle: textStyle,
        ),
        itemCount: menuItems.length,
        shrinkWrap: true,
      );
}
