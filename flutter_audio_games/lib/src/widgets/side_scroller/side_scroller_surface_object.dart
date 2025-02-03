import 'dart:math';

import 'package:flutter_audio_games/flutter_audio_games.dart';

/// An object in a [SideScrollerSurface].
class SideScrollerSurfaceObject {
  /// Create an instance.
  const SideScrollerSurfaceObject({
    required this.name,
    required this.ambiance,
    this.initialCoordinates = const Point(0, 0),
    this.fadeVolume,
    this.fadePan,
  });

  /// The name of this object.
  ///
  /// The [name] is only used for debugging.
  final String name;

  /// The sound attached to this object.
  final Sound ambiance;

  /// The initial coordinates of this object.
  ///
  /// The `x` coordinate of the [Point] value is used for the left position of
  /// this object in the [SideScroller] level, relative to the start of the
  /// parent [SideScrollerSurface]. The `y` value is not currently used.
  final Point<int> initialCoordinates;

  /// How fast the [ambiance] volume should fade.
  ///
  /// If [fadeVolume] is `null`, then `surface.playerMoveSpeed` will be used.
  ///
  /// To have no fade, use [Duration.zero].
  final Duration? fadeVolume;

  /// How fast the [ambiance] pan should fade.
  ///
  /// If [fadePan] is `null`, then `surface.playerMoveSpeed` will be used.
  ///
  /// To have no fade, use [Duration.zero].
  final Duration? fadePan;
}
