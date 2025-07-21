import 'dart:math';

import 'package:flutter_audio_games/flutter_audio_games.dart';

/// Useful methods on generic points.
extension PointX<T extends num> on Point<T> {
  /// Return `true` if this point lies on a straight line between points [a] and
  /// [b].
  bool isOnLine(final Point<T> a, final Point<T> b) =>
      (distanceTo(b) + a.distanceTo(b)) == distanceTo(a);

  /// Returns a [SoundPosition3d] from `this` [Point].
  ///
  /// This getter assumes that the listener orientation is default. That is, the
  /// coordinates system is still right handed.
  SoundPosition3d get soundPosition3d =>
      SoundPosition3d(x.toDouble(), 0, y.toDouble());
}

/// Useful methods for points.
///
/// This extension is mostly copied from [Ziggurat](https://pub.dev/packages/ziggurat).
extension PointDoubleX on Point<double> {
  /// Return a floored version of this point. That is a point made up of
  /// [x] and [y], both floored with [double.floor].
  Point<int> floor() => Point<int>(x.floor(), y.floor());

  /// Return a rounded version of `this` [Point].
  Point<int> round() => Point<int>(x.round(), y.round());

  /// Return the angle between `this` and [other].
  ///
  /// This function provided by a good friend who wished to remain nameless.
  double angleBetween(final Point<double> other) {
    // Check if the points are on top of each other and output something
    // reasonable.
    if (x == other.x && y == other.y) {
      return 0.0;
    }
    // If y1 and y2 are the same, we'll end up dividing by 0, and that's bad.
    if (y == other.y) {
      if (other.x > x) {
        return 90.0;
      } else {
        return 270.0;
      }
    }
    final angle = atan2(other.x - x, other.y - y);
    // Convert result from radians to degrees. If you want minutes and seconds
    // as well it's tough.
    final degrees = angle * 180 / pi;
    // Ensure the angle is between 0 and 360.
    return normaliseAngle(degrees);
  }

  /// Return the coordinates that lie [distance] at [bearing] °.
  Point<double> pointInDirection(final double bearing, final double distance) {
    final rad = angleToRad(bearing);
    return Point<double>(x + (distance * sin(rad)), y + (distance * cos(rad)));
  }
}

/// Useful methods for points.
///
/// This extension is mostly copied from [Ziggurat](https://pub.dev/packages/ziggurat).
extension PointIntX on Point<int> {
  /// Return a version of this point with the points converted to doubles.
  Point<double> toDouble() => Point<double>(x.toDouble(), y.toDouble());

  /// The point to the north of this point.
  Point<int> get north => Point(x, y + 1);

  /// The point to the northeast of this point.
  Point<int> get northeast => Point(x + 1, y + 1);

  /// The point to the east of this point.
  Point<int> get east => Point(x + 1, y);

  /// The point to the southeast of this point.
  Point<int> get southeast => Point(x + 1, y - 1);

  /// The point to the south of this point.
  Point<int> get south => Point(x, y - 1);

  /// The point to the southwest of this point.
  Point<int> get southwest => Point(x - 1, y - 1);

  /// The point to the west of this point.
  Point<int> get west => Point(x - 1, y);

  /// The point to the northwest of this point.
  Point<int> get northwest => Point(x - 1, y + 1);
}
