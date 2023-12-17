import 'package:dart_synthizer/dart_synthizer.dart';
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
    required this.source,
    this.selectSound,
    this.activateSound,
    this.autofocus = false,
    this.looping = false,
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

  /// The source to play sounds through.
  ///
  /// This source will be used to play both [selectSound] and [activateSound].
  final Source source;

  /// Whether or not the [ListTile] should be autofocused.
  final bool autofocus;

  /// Whether or not [selectSound] should loop.
  ///
  /// If [looping] is `true`, [selectSound] will loop when this
  /// [AudioGameMenuItemListTile] receives focus.
  final bool looping;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final listTile = ListTile(
      autofocus: autofocus,
      title: Text(menuItem.title),
      onTap: () {
        final sound = activateSound;
        if (sound != null) {
          context.playSound(
            sound: sound,
            source: source,
            destroy: true,
          );
        }
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
        source: source,
        child: listTile,
      );
    }
    final sound = selectSound;
    if (sound == null) {
      return child;
    }
    return PlaySoundSemantics(
      sound: sound,
      source: source,
      looping: looping,
      child: child,
    );
  }
}
