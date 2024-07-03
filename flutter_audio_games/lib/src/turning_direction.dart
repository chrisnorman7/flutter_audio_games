/// Possible turning directions.
///
/// This enumeration only aims to cover those cases where the player can turn
/// left or right. For anything more complicated, consider using degrees
/// directly.
enum TurningDirection {
  /// The playing is turning left (anticlockwise).
  left,

  /// The player is turning right (clockwise).
  right,
}
