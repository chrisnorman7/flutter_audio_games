import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../../touch.dart';

/// A [TouchSurface] built from [commands].
class TouchSurfaceBuilder extends StatelessWidget {
  /// Create an instance.
  const TouchSurfaceBuilder({
    required this.commands,
    this.textStyle,
    this.autofocus = true,
    this.canRequestFocus = true,
    this.focusNode,
    this.extraShortcuts = const [],
    super.key,
  });

  /// The commands to use.
  ///
  /// Each list in [commands] will generate a new [Row] widget.
  final List<List<GameShortcut>> commands;

  /// The text style to use.
  final TextStyle? textStyle;

  /// Whether the [GameShortcuts] widget should be autofocused.
  final bool autofocus;

  /// Whether the [GameShortcuts] should be able to request focus.
  final bool canRequestFocus;

  /// The focus node to use.
  final FocusNode? focusNode;

  /// Any extra shortcuts to add.
  ///
  /// You can use [extraShortcuts] to add shortcuts which should be accessible
  /// from the keyboard but not the touch screen.
  final List<GameShortcut> extraShortcuts;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => GameShortcuts(
        shortcuts: [
          for (final commandList in commands) ...commandList,
          ...extraShortcuts,
        ],
        autofocus: autofocus,
        canRequestFocus: canRequestFocus,
        focusNode: focusNode,
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
                          description: command.title,
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
