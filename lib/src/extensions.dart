import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/music_builder/music_builder.dart';
import '../widgets/random_task_builder/random_task_builder.dart';
import '../widgets/ticking_builder/ticking_builder.dart';
import 'maths.dart';

/// Useful extensions on build contexts.
extension FlutterAudioGamesBuildContextExtensions on BuildContext {
  /// Pause and resume a [TickingBuilder] while pushing a widget [builder].
  Future<void> pauseTickingBuilderAndPushWidget(
    final WidgetBuilder builder,
  ) async {
    TickingBuilder.maybeOf(this)?.pause();
    await Navigator.of(this).push(MaterialPageRoute(builder: builder));
    TickingBuilder.maybeOf(this)?.resume();
  }

  /// Pause and resume a [RandomTaskBuilder] while pushing a widget [builder].
  Future<void> pauseRandomTaskBuilderAndPushWidget(
    final WidgetBuilder builder,
  ) async {
    RandomTaskBuilder.maybeOf(this)?.pause();
    await Navigator.of(this).push(MaterialPageRoute(builder: builder));
    RandomTaskBuilder.maybeOf(this)?.resume();
  }

  /// Push a widget [builder], fading any [MusicBuilder] out and back in again.
  Future<void> fadeMusicAndPushWidget(final WidgetBuilder builder) async {
    MusicBuilder.maybeOf(this)?.fadeOut();
    await Navigator.push(
      this,
      MaterialPageRoute(
        builder: builder,
      ),
    );
    MusicBuilder.maybeOf(this)?.fadeIn();
  }
}

/// Useful methods for points.
extension FlutterAudioGamesPointDoubleExtension on Point<double> {
  /// Return a floored version of this point.
  Point<int> floor() => Point<int>(x.floor(), y.floor());

  /// Return the angle between `this` and [other].
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
}

/// Useful methods for points.
extension FlutterAudioGamesPointIntExtension on Point<int> {
  /// Return a version of this point with the points converted to doubles.
  Point<double> toDouble() => Point<double>(x.toDouble(), y.toDouble());
}
