import 'package:backstreets_widgets/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:url_launcher/url_launcher.dart';

/// A screen which shows game credits.
class GameCredits extends StatelessWidget {
  /// Create an instance.
  const GameCredits({
    required this.credits,
    required this.error,
    this.title = 'Credits',
    this.music,
    this.selectItemSound,
    this.activateItemSound,
    this.musicFadeInTime,
    this.musicFadeOutTime,
    super.key,
  });

  /// The credits to show.
  final List<GameCredit> credits;

  /// The function to call to show an error widget.
  final ErrorWidgetCallback error;

  /// The title of this menu.
  final String title;

  /// The music to play for this menu.
  final Sound? music;

  /// The sound to play when selecting an item in this menu.
  final Sound? selectItemSound;

  /// The sound to play when activating an item in this menu.
  final Sound? activateItemSound;

  /// The fade in time for [music].
  final Duration? musicFadeInTime;

  /// The fade out time for [music].
  final Duration? musicFadeOutTime;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => AudioGameMenu(
    title: title,
    menuItems:
        credits
            .map(
              (final credit) => AudioGameMenuItem(
                title: credit.name,
                onActivate:
                    (final innerContext) => launchUrl(Uri.parse(credit.url)),
                earcon: credit.earcon,
              ),
            )
            .toList(),
    selectItemSound: selectItemSound,
    activateItemSound: activateItemSound,
    music: music,
    musicFadeInTime: musicFadeInTime,
    musicFadeOutTime: musicFadeOutTime,
    error: error,
  );
}
