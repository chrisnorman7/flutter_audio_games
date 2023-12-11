import 'dart:math';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import 'maths.dart';
import 'widgets/audio_game_menu/audio_game_menu.dart';
import 'widgets/sounds/music/music.dart';
import 'widgets/tasks/random_tasks/random_tasks.dart';
import 'widgets/tasks/ticking/ticking.dart';

/// Useful extensions on build contexts.
extension FlutterAudioGamesBuildContextExtensions on BuildContext {
  /// Pause and resume a [Ticking] while pushing a widget [builder].
  ///
  /// This method is useful when implementing a pause menu for example.
  Future<void> pauseTickingBuilderAndPushWidget(
    final WidgetBuilder builder,
  ) async {
    Ticking.maybeOf(this)?.pause();
    await Navigator.of(this).push(MaterialPageRoute(builder: builder));
    Ticking.maybeOf(this)?.resume();
  }

  /// Pause and resume a [RandomTasks] while pushing a widget [builder].
  ///
  /// This method is useful when implementing a pause menu for example.
  Future<void> pauseRandomTaskBuilderAndPushWidget(
    final WidgetBuilder builder,
  ) async {
    RandomTasks.maybeOf(this)?.pause();
    await Navigator.of(this).push(MaterialPageRoute(builder: builder));
    RandomTasks.maybeOf(this)?.resume();
  }

  /// Push a widget [builder], fading any [Music] out and back in again.
  ///
  /// This method is useful when pushing a widget over a [AudioGameMenu] for
  /// example.
  ///
  /// If [restartMusic] is `true`, then the playback position will be reset
  /// before fading back in.
  Future<void> fadeMusicAndPushWidget(
    final WidgetBuilder builder, {
    final bool restartMusic = true,
  }) async {
    Music.maybeOf(this)?.fadeOut();
    await Navigator.push(
      this,
      MaterialPageRoute(
        builder: builder,
      ),
    );
    final inheritedMusic = Music.maybeOf(this);
    if (restartMusic) {
      inheritedMusic?.setPlaybackPosition(0.0);
    }
    inheritedMusic?.fadeIn();
  }
}

/// Useful methods for points.
///
/// This extension is mostly copied from [Ziggurat](https://pub.dev/packages/ziggurat).
extension FlutterAudioGamesPointDoubleExtension on Point<double> {
  /// Return a floored version of this point. That is a point made up of
  /// [x] and [y], both floored with [double.floor].
  Point<int> floor() => Point<int>(x.floor(), y.floor());

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
  Point<double> pointInDirection(
    final double bearing,
    final double distance,
  ) {
    final rad = angleToRad(bearing);
    return Point<double>(x + (distance * sin(rad)), y + (distance * cos(rad)));
  }
}

/// Useful methods for points.
///
/// This extension is mostly copied from [Ziggurat](https://pub.dev/packages/ziggurat).
extension FlutterAudioGamesPointIntExtension on Point<int> {
  /// Return a version of this point with the points converted to doubles.
  Point<double> toDouble() => Point<double>(x.toDouble(), y.toDouble());
}

/// Useful extensions for lists.
extension FlutterAudioGamesListExtension<E> on List<E> {
  /// Return a random element.
  ///
  /// This uses [Random.nextInt] to get a random index.
  E randomElement(final Random random) => this[random.nextInt(length)];
}

/// Useful methods.
extension FlutterAudioGamesGainExtensions on GainMixin {
  /// Maybe fade from [startGain] to [endGain].
  void maybeFade({
    required final double? fadeLength,
    required final double startGain,
    required final double endGain,
  }) {
    if (fadeLength != null) {
      fade(fadeLength: fadeLength, startGain: startGain, endGain: endGain);
    } else {
      gain.value = endGain;
    }
  }
}
