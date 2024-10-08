import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'touch_surface_builder.dart';

/// A command in a [TouchSurfaceBuilder].
class TouchSurfaceBuilderCommand extends GameShortcut {
  /// Create an instance.
  const TouchSurfaceBuilderCommand({
    required super.title,
    required super.shortcut,
    this.child,
    super.onStart,
    super.onStop,
    super.controlKey = false,
    super.altKey = false,
    super.shiftKey = false,
  });

  /// The child widget to show.
  final Widget? child;
}
