import 'package:flutter/material.dart';

import 'audio_game_menu.dart';

/// A menu item in an [AudioGameMenu].
class AudioGameMenuItem {
  /// Create an instance.
  const AudioGameMenuItem({
    required this.title,
    required this.onActivate,
  });

  /// The title of this menu item.
  final String title;

  /// The function to call when this menu item is activated.
  final void Function(BuildContext innerContext) onActivate;
}
