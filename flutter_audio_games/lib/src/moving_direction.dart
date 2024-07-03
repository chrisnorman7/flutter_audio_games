/// Possible movement directions.
///
/// This enumeration doesn't aim to be the most extensive collection of possible
/// movement directions, but it covers the standard wasd cases.
enum MovingDirection {
  /// The player is moving forward.
  forwards,

  /// The player is moving backwards.
  backwards,

  /// The player is sidestepping left.
  left,

  /// The player is sidestepping right.
  right,
}
