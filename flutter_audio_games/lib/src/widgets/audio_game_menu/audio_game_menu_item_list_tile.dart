import 'package:flutter/material.dart';

import '../../extensions.dart';
import '../../sounds/sound.dart';
import '../sounds/play_sound_semantics.dart';
import 'audio_game_menu.dart';
import 'audio_game_menu_item.dart';

/// A [ListTile] for use in an [AudioGameMenu] widget.
class AudioGameMenuItemListTile extends StatelessWidget {
  /// Create an instance.
  const AudioGameMenuItemListTile({
    required this.menuItem,
    this.selectSound,
    this.activateSound,
    this.autofocus = false,
    this.textStyle = const TextStyle(fontSize: 20),
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

  /// The text style to use.
  final TextStyle? textStyle;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final listTile = ListTile(
      autofocus: autofocus,
      title: Text(
        menuItem.title,
        style: textStyle,
      ),
      onTap: () {
        context.maybePlaySound(activateSound);
        menuItem.onActivate(context);
      },
    );
    final earcon = menuItem.earcon;
    final Widget child;
    if (earcon == null) {
      child = listTile;
    } else {
      child = PlaySoundSemantics(
        sound: earcon,
        child: listTile,
      );
    }
    final sound = selectSound;
    if (sound == null) {
      return child;
    }
    return PlaySoundSemantics(
      sound: sound,
      child: child,
    );
  }
}
