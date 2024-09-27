import 'dart:math';

import '../../sounds/sound.dart';
import 'side_scroller.dart';
import 'side_scroller_surface.dart';

/// An object in a [SideScrollerSurface].
class SideScrollerSurfaceObject {
  /// Create an instance.
  const SideScrollerSurfaceObject({
    required this.name,
    required this.ambiance,
    this.initialCoordinates = const Point(0, 0),
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
}
