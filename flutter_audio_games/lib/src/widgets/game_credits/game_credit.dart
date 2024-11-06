import '../../sounds/sound.dart';

/// A credit in a game.
class GameCredit {
  /// Create an instance.
  const GameCredit({
    required this.name,
    required this.url,
    this.earcon,
  });

  /// The text of the credit.
  final String name;

  /// The URL of the credit.
  final String url;

  /// The earcon to use.
  final Sound? earcon;
}
