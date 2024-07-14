import 'dart:math';

import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../../flutter_audio_games.dart';
import '../../../touch.dart';

/// An [AudioGameMenu] which responds to touch.
class TouchMenu extends StatefulWidget {
  /// Create an instance.
  const TouchMenu({
    required this.title,
    required this.menuItems,
    this.music,
    this.selectItemSound,
    this.activateItemSound,
    this.musicFadeInTime,
    this.musicFadeOutTime,
    this.canPop = false,
    super.key,
  });

  /// The title of this menu.
  ///
  /// The [title] will be shown on screen visually.
  final String title;

  /// The menu items in this menu.
  ///
  /// If the [menuItems] list is empty, then the menu will only show a title.
  final List<AudioGameMenuItem> menuItems;

  /// The music to play for this menu.
  ///
  /// If [music] is not `null`, then a [Music] widget will be added to the
  /// widget tree.
  final Sound? music;

  /// The sound to play when selecting an item in this menu.
  ///
  /// If [selectItemSound] is not `null`, then the sound will be heard
  /// when moving to a menu item with the keyboard, or touching it on the
  /// screen.
  final Sound? selectItemSound;

  /// The sound to play when activating an item in this menu.
  ///
  /// If [activateItemSound] is not `null`, the sound will be heard
  /// when activating menu items.
  final Sound? activateItemSound;

  /// The fade in time for [music].
  ///
  /// If [music] is `null`, [musicFadeInTime] has no effect.
  final Duration? musicFadeInTime;

  /// The fade out time for [music].
  ///
  /// If [music] is `null`, [musicFadeOutTime] has no effect.
  ///
  /// If [musicFadeOutTime] is `null`, the menu [music] will end when the menu
  /// is popped.
  final Duration? musicFadeOutTime;

  /// Allows the blocking of back gestures.
  final bool canPop;

  /// Create state for this widget.
  @override
  TouchMenuState createState() => TouchMenuState();
}

/// State for [TouchMenu].
class TouchMenuState extends State<TouchMenu> {
  /// The index of the currently-selected menu item.
  late int menuItemIndex;

  /// The sounds that are playing.
  late final List<SoundHandle> soundHandles;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    menuItemIndex = -1;
    soundHandles = [];
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    stopSounds();
  }

  /// Stop all the currently playing [soundHandles].
  void stopSounds() {
    soundHandles
      ..forEach(context.soLoud.stop)
      ..clear();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final musicSound = widget.music;
    return MaybeMusic(
      music: musicSound,
      builder: (final _) => OrientationBuilder(
        builder: (final orientationContext, final orientation) => GameShortcuts(
          shortcuts: [
            if (widget.canPop)
              const GameShortcut(
                title: 'Close the menu',
                shortcut: GameShortcutsShortcut.escape,
                onStart: Navigator.maybePop,
              ),
            GameShortcut(
              title: 'Move up in the menu',
              shortcut: GameShortcutsShortcut.arrowUp,
              onStart: (final innerContext) => moveUp(),
            ),
            GameShortcut(
              title: 'Move down in the menu',
              shortcut: GameShortcutsShortcut.arrowDown,
              onStart: (final innerContext) => moveDown(),
            ),
            GameShortcut(
              title: 'Activate the current menu item',
              shortcut: GameShortcutsShortcut.enter,
              onStart: activateItem,
            ),
            GameShortcut(
              title: 'Activate the current menu item',
              shortcut: GameShortcutsShortcut.space,
              onStart: activateItem,
            ),
          ],
          child: GestureDetector(
            onDoubleTap: () => activateItem(orientationContext),
            child: TouchSurface(
              columns: orientation == Orientation.portrait
                  ? widget.menuItems.length
                  : 1,
              rows: orientation == Orientation.landscape
                  ? widget.menuItems.length
                  : 1,
              onTouch: (final coordinates, final event) async {
                if (event == TouchAreaEvent.release) {
                  return;
                }
                final int index;
                switch (orientation) {
                  case Orientation.portrait:
                    index = coordinates.x;
                  case Orientation.landscape:
                    index = coordinates.y;
                }
                await setCurrentMenuItem(index);
              },
              areaDescriptions: {
                for (var i = 0; i < widget.menuItems.length; i++)
                  Point(
                    orientation == Orientation.portrait ? i : 0,
                    orientation == Orientation.portrait ? 0 : i,
                  ): widget.menuItems[i].title,
              },
            ),
          ),
        ),
      ),
      fadeInTime: widget.musicFadeInTime,
      fadeOutTime: widget.musicFadeOutTime,
    );
  }

  /// Activate the current menu item.
  void activateItem(final BuildContext innerContext) {
    if (menuItemIndex < 0) {
      return;
    }
    final menuItem = widget.menuItems[menuItemIndex];
    innerContext.maybePlaySound(widget.activateItemSound);
    menuItem.onActivate(innerContext);
  }

  /// Change the current menu item.
  Future<void> setCurrentMenuItem(final int index) async {
    if (index != menuItemIndex) {
      stopSounds();
      menuItemIndex = index;
      final menuItem = widget.menuItems[index];
      for (final sound in [menuItem.earcon, widget.selectItemSound]) {
        if (sound != null && mounted) {
          final handle = await context.playSound(sound);
          soundHandles.add(handle);
        }
      }
      setState(() {});
    }
  }

  /// Move up through the menu.
  Future<void> moveUp() async {
    final index = max(0, menuItemIndex - 1);
    await setCurrentMenuItem(index);
  }

  /// Move down through the menu.
  Future<void> moveDown() async {
    final index = min(menuItemIndex + 1, widget.menuItems.length - 1);
    await setCurrentMenuItem(index);
  }
}
