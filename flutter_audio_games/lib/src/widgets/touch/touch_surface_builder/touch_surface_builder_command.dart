import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/src/widgets/touch/touch_surface_builder/touch_surface_builder.dart'
    show TouchSurfaceBuilder;
import 'package:flutter_audio_games/touch.dart' show TouchSurfaceBuilder;

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
