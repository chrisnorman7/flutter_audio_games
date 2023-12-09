import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import '../sounds/play_sound_semantics.dart';
import 'audio_game_menu.dart';
import 'audio_game_menu_item.dart';

/// A [ListTile] for use in an [AudioGameMenu] widget.
class AudioGameMenuItemListTile extends StatelessWidget {
  /// Create an instance.
  const AudioGameMenuItemListTile({
    required this.menuItem,
    required this.source,
    this.selectSoundAssetPath,
    this.activateSoundAssetPath,
    this.selectSoundGain = 0.7,
    this.activateSoundGain = 0.7,
    this.autofocus = false,
    this.looping = false,
    super.key,
  });

  /// The menu item to represent.
  final AudioGameMenuItem menuItem;

  /// The asset path for the select sound.
  ///
  /// If [selectSoundAssetPath] is not `null`, then the given sound will be
  /// heard when this [AudioGameMenuItemListTile] receives focus.
  final String? selectSoundAssetPath;

  /// The gain for the select sound.
  ///
  /// If [selectSoundAssetPath] is `null`, [selectSoundGain] will have no
  /// effect.
  final double selectSoundGain;

  /// The asset path for the activate sound.
  ///
  /// If [activateSoundAssetPath] is not `null`, the given sound will play when
  /// this [AudioGameMenuItemListTile] is activated.
  final String? activateSoundAssetPath;

  /// The gain for the activate sound.
  ///
  /// If [activateSoundAssetPath] is `null`, [activateSoundGain] will have no
  /// effect.
  final double activateSoundGain;

  /// The source to play sounds through.
  ///
  /// This source will be used to play both [selectSoundAssetPath] and
  /// [activateSoundAssetPath].
  final Source source;

  /// Whether or not the [ListTile] should be autofocused.
  final bool autofocus;

  /// Whether or not the select sound should loop.
  ///
  /// If this value is `true`, [selectSoundAssetPath] will loop when this
  /// [AudioGameMenuItemListTile] receives focus.
  final bool looping;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final listTile = ListTile(
      autofocus: autofocus,
      title: Text(menuItem.title),
      onTap: () {
        final activateSound = activateSoundAssetPath;
        if (activateSound != null) {
          context.playSound(
            assetPath: activateSound,
            source: source,
            gain: activateSoundGain,
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
        soundAssetPath: earcon,
        source: source,
        gain: menuItem.earconGain,
        child: listTile,
      );
    }
    final selectSound = selectSoundAssetPath;
    if (selectSound == null) {
      return child;
    }
    return PlaySoundSemantics(
      soundAssetPath: selectSound,
      source: source,
      gain: selectSoundGain,
      looping: looping,
      child: child,
    );
  }
}
