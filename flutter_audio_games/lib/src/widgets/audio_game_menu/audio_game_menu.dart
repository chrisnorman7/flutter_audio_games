import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

/// A menu in an audio game.
class AudioGameMenu extends StatelessWidget {
  /// Create an instance.
  const AudioGameMenu({
    required this.title,
    required this.menuItems,
    this.error = ErrorScreen.withPositional,
    this.music,
    this.selectItemSound,
    this.activateItemSound,
    this.musicFadeInTime,
    this.musicFadeOutTime,
    super.key,
  });

  /// The title of the resulting [Scaffold] widget..
  final String title;

  /// The menu items in this menu.
  ///
  /// If the [menuItems] list is empty, then the menu will only show a title.
  final List<AudioGameMenuItem> menuItems;

  /// The function to call to show an error widget.
  final ErrorWidgetCallback error;

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

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final musicSound = music;
    final child = AudioGameMenuListView(
      menuItems: menuItems,
      selectItemSound: selectItemSound,
      activateItemSound: activateItemSound,
    );
    return ProtectSounds(
      sounds: [music].whereType<Sound>().toList(),
      child: SimpleScaffold(
        title: title,
        body: MaybeMusic(
          music: musicSound,
          error: error,
          loading: () => child,
          fadeInTime: musicFadeInTime,
          fadeOutTime: musicFadeOutTime,
          child: child,
        ),
      ),
    );
  }
}
