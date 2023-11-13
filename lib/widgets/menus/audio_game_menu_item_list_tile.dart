import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import '../play_sound_semantics.dart';
import 'audio_game_menu.dart';
import 'audio_game_menu_item.dart';

/// A [ListTile] for use in an [AudioGameMenu].
class AudioGameMenuItemListTile extends StatelessWidget {
  /// Create an instance.
  const AudioGameMenuItemListTile({
    required this.menuItem,
    required this.selectSoundAssetPath,
    required this.activateSoundAssetPath,
    required this.source,
    this.selectSoundGame = 0.7,
    this.activateSoundGain = 0.7,
    this.autofocus = false,
    this.looping = false,
    super.key,
  });

  /// The menu item to represent.
  final AudioGameMenuItem menuItem;

  /// The asset path for the select sound.
  final String selectSoundAssetPath;

  /// The gain for the select sound.
  final double selectSoundGame;

  /// The asset path for the activate sound.
  final String activateSoundAssetPath;

  /// The gain for the activate sound.
  final double activateSoundGain;

  /// The source to play sounds through.
  final Source source;

  /// Whether or not the [ListTile] should be autofocused.
  final bool autofocus;

  /// Whether or not the select sound should loop.
  final bool looping;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => PlaySoundSemantics(
        soundAssetPath: selectSoundAssetPath,
        source: source,
        gain: selectSoundGame,
        looping: looping,
        child: ListTile(
          autofocus: autofocus,
          title: Text(menuItem.title),
          onTap: () {
            context.playSound(
              assetPath: activateSoundAssetPath,
              source: source,
              gain: activateSoundGain,
            );
            menuItem.onActivate(context);
          },
        ),
      );
}
