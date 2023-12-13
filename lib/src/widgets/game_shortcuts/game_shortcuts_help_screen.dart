import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'game_shortcut.dart';

/// A widget which shows game shortcuts.
class GameShortcutsHelpScreen extends StatelessWidget {
  /// Create an instance.
  const GameShortcutsHelpScreen({
    required this.shortcuts,
    this.title = 'Keyboard Shortcuts',
    this.controlKey = 'CTRL',
    this.shiftKey = 'SHIFT',
    this.altKey = 'ALT',
    super.key,
  });

  /// The shortcuts to show.
  final List<GameShortcut> shortcuts;

  /// The title of the resulting screen.
  final String title;

  /// The name of the control key.
  final String controlKey;

  /// The title of the shift key.
  final String shiftKey;

  /// The title of the alt key.
  final String altKey;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => Cancel(
        child: SimpleScaffold(
          title: 'Keyboard Shortcuts Help',
          body: ListView.builder(
            itemBuilder: (final context, final index) {
              final shortcut = shortcuts[index];
              final keys = [
                if (shortcut.controlKey) controlKey,
                if (shortcut.shiftKey) shiftKey,
                if (shortcut.altKey) altKey,
                shortcut.key.keyLabel,
              ];
              return CopyListTile(
                title: keys.join('+'),
                subtitle: shortcut.title,
                autofocus: index == 0,
              );
            },
            itemCount: shortcuts.length,
          ),
        ),
      );
}
