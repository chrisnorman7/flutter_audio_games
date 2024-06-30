import 'dart:async';
import 'dart:math';

import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import '../flutter_audio_games.dart';

/// Useful extensions on build contexts.
extension FlutterAudioGamesBuildContextExtension on BuildContext {
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

  /// Play a [sound].
  FutureOr<BufferGenerator> playSound({
    required final Sound sound,
    required final Source source,
    required final bool destroy,
    final bool? linger,
    final bool looping = false,
  }) =>
      playBufferReference(
        bufferReference: sound.bufferReference,
        source: source,
        destroy: destroy,
        gain: sound.gain,
        linger: linger,
        looping: looping,
      );

  /// Stop a sound playing with this context.
  void stopPlaySoundSemantics() =>
      findAncestorStateOfType<PlaySoundSemanticsState>()?.stop();
}

/// Useful methods on generic points.
extension FlutterAudioGamesPointExtension<T extends num> on Point<T> {
  /// Return `true` if this point lies on a straight line between points [a] and
  /// [b].
  bool isOnLine(
    final Point<T> a,
    final Point<T> b,
  ) =>
      (distanceTo(b) + a.distanceTo(b)) == distanceTo(a);
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
extension FlutterAudioGamesGainExtension on GainMixin {
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

/// Useful string methods.
extension FlutterAudioGamesStringExtension on String {
  /// Return a sound, using this string as the path.
  ///
  /// If you want to turn a [List] of [String]s into a [SoundList], use the
  /// [FlutterAudioGamesListStringExtension.asSoundList] method.
  Sound asSound({
    final PathType pathType = PathType.asset,
    final double gain = 0.7,
  }) =>
      Sound(
        bufferReference: BufferReference(path: this, pathType: pathType),
        gain: gain,
      );
}

/// Useful methods on string lists.
extension FlutterAudioGamesListStringExtension on List<String> {
  /// Return a sound list.
  SoundList asSoundList({
    final PathType pathType = PathType.asset,
    final double gain = 0.7,
  }) =>
      SoundList(
        paths: this,
        pathType: pathType,
        gain: gain,
      );
}
