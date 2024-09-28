import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../../../touch.dart';
import 'touch_surface_command.dart';

/// A [TouchSurface] built from [commands].
class TouchSurfaceBuilder extends StatelessWidget {
  /// Create an instance.
  const TouchSurfaceBuilder({
    required this.commands,
    this.textStyle,
    super.key,
  });

  /// The commands to use.
  ///
  /// Each list in [commands] will generate a new [Row] widget.
  final List<List<TouchSurfaceCommand>> commands;

  /// The text style to use.
  final TextStyle? textStyle;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final shortcuts = <GameShortcut>[];
    for (final commandList in commands) {
      for (final command in commandList) {
        shortcuts.add(
          GameShortcut(
            title: command.description,
            shortcut: command.shortcut,
            onStart: command.onStart,
            onStop: command.onStop,
          ),
        );
      }
    }
    return GameShortcuts(
      shortcuts: shortcuts,
      autofocus: false,
      canRequestFocus: false,
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final row in commands)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final command in row)
                      TouchArea(
                        description: command.description,
                        onTouch: (final event) {
                          switch (event) {
                            case TouchAreaEvent.touch:
                              command.onStart?.call(context);
                            case TouchAreaEvent.release:
                              command.onStop?.call(context);
                          }
                        },
                        textStyle: textStyle,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
