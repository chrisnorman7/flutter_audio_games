import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

/// A [ListTile] for use in an [AudioGameMenu] widget.
class AudioGameMenuItemListTile extends StatelessWidget {
  /// Create an instance.
  const AudioGameMenuItemListTile({
    required this.menuItem,
    this.selectSound,
    this.activateSound,
    this.autofocus = false,
    super.key,
  });

  /// The menu item to represent.
  final AudioGameMenuItem menuItem;

  /// The select sound.
  ///
  /// If [selectSound] is not `null`, then [selectSound] will be heard when this
  /// [AudioGameMenuItemListTile] receives focus.
  final Sound? selectSound;

  /// The activate sound.
  ///
  /// If [activateSound] is not `null`, [activateSound] will play when this
  /// [AudioGameMenuItemListTile] is activated.
  final Sound? activateSound;

  /// Whether or not the [ListTile] should be autofocused.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => ProtectSounds(
        sounds: [menuItem.earcon].whereType<Sound>().toList(),
        child: MaybePlaySoundSemantics(
          sound: menuItem.earcon,
          child: MaybePlaySoundSemantics(
            sound: selectSound,
            child: ListTile(
              autofocus: autofocus,
              title: Text(menuItem.title),
              onTap: () {
                context.maybePlaySound(activateSound);
                menuItem.onActivate(context);
              },
            ),
          ),
        ),
      );
}
