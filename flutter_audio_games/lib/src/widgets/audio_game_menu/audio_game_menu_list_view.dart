import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

/// The [ListView] that powers [AudioGameMenu]s.
class AudioGameMenuListView extends StatelessWidget {
  /// Create an instance.
  const AudioGameMenuListView({
    required this.menuItems,
    this.selectItemSound,
    this.activateItemSound,
    super.key,
  });

  /// The menu items to show.
  final List<AudioGameMenuItem> menuItems;

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

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => ProtectSounds(
    sounds: [selectItemSound, activateItemSound].whereType<Sound>().toList(),
    child: ListView.builder(
      itemBuilder:
          (final context, final index) => AudioGameMenuItemListTile(
            menuItem: menuItems[index],
            selectSound: selectItemSound,
            activateSound: activateItemSound,
            autofocus: index == 0,
          ),
      itemCount: menuItems.length,
      shrinkWrap: true,
    ),
  );
}
