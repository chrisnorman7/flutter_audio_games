/// The base class for sound positions.
sealed class SoundPosition {
  /// Allow subclasses to be constant.
  const SoundPosition();
}

/// Position for a panned sound.
class SoundPositionPanned implements SoundPosition {
  /// Create an instance.
  const SoundPositionPanned(this.pan);

  /// Return a panned position according to the position of [index] according to
  /// [maxIndex].
  ///
  /// This constructor is used if you want to pan a sound according to its
  /// position in a menu for example, where sounds further towards the end of
  /// the menu are panned more to the right.
  factory SoundPositionPanned.fromIndex(final int maxIndex, final int index) {
    assert(index <= maxIndex, '`index` cannot be greater than `maxIndex`.');
    if (maxIndex == 1) {
      return unpanned;
    }
    return SoundPositionPanned(((2 / (maxIndex - 1)) * index) - 1);
  }

  /// The pan for the sound.
  final double pan;
}

/// The position for an unpanned sound.
const unpanned = SoundPositionPanned(0.0);

/// Position for a 3d sound.
class SoundPosition3d implements SoundPosition {
  /// Create an instance.
  const SoundPosition3d(
    this.x,
    this.y,
    this.z, {
    this.velX = 0.0,
    this.velY = 0.0,
    this.velZ = 0.0,
    this.minDistance = 1,
    this.maxDistance = 10,
    this.tickWhenInaudible = false,
    this.killWhenInaudible = false,
  });

  /// The x coordinate.
  final double x;

  /// The y coordinate.
  final double y;

  /// THe z coordinate.
  final double z;

  /// The velocity x coordinate.
  final double velX;

  /// The velocity y coordinate.
  final double velY;

  /// The velocity z coordinate.
  final double velZ;

  /// The minimum distance at which the source will be heard.
  final double minDistance;

  /// The maximum distance at which this source will be heard.
  final double maxDistance;

  /// Whether to keep ticking this sound if it becomes inaudible.
  final bool tickWhenInaudible;

  /// Whether to kill this sound when it becomes inaudible.
  final bool killWhenInaudible;
}
