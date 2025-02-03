import 'package:backstreets_widgets/typedefs.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

/// A menu item in an [AudioGameMenu].
class AudioGameMenuItem {
  /// Create an instance.
  const AudioGameMenuItem({
    required this.title,
    required this.onActivate,
    this.earcon,
  });

  /// The title of this menu item.
  final String title;

  /// The function to call when this menu item is activated.
  final ContextCallback onActivate;

  /// The path of an asset reference that will play when this menu item is
  /// selected. This sound will play in addition to the usual menu select sound.
  final Sound? earcon;
}
