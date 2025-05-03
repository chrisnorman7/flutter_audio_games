import 'dart:math';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/typedefs.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_audio_games/touch.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// An [AudioGameMenu] which responds to touch.
class TouchMenu extends StatefulWidget {
  /// Create an instance.
  const TouchMenu({
    required this.title,
    required this.menuItems,
    this.error = ErrorScreen.withPositional,
    this.music,
    this.selectItemSound,
    this.activateItemSound,
    this.musicFadeInTime,
    this.musicFadeOutTime,
    this.canPop = false,
    this.backShortcut = GameShortcutsShortcut.escape,
    this.downShortcut = GameShortcutsShortcut.arrowDown,
    this.upShortcut = GameShortcutsShortcut.arrowUp,
    this.activateShortcut = GameShortcutsShortcut.enter,
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

  /// The function to call to show an error widget.
  final ErrorWidgetCallback error;

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

  /// The shortcut for popping this menu.
  ///
  /// If [canPop] is `false`, [backShortcut] will have no effect.
  final GameShortcutsShortcut backShortcut;

  /// The shortcut to move down in the menu.
  final GameShortcutsShortcut downShortcut;

  /// The shortcut to move up in the menu.
  final GameShortcutsShortcut upShortcut;

  /// The shortcut to activate a menu item.
  ///
  /// The current menu item can always be activated with
  /// [GameShortcutsShortcut.space].
  final GameShortcutsShortcut activateShortcut;

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
    final loader = context.sourceLoader;
    for (final menuItem in widget.menuItems) {
      final sound = menuItem.earcon;
      if (sound != null) {
        loader.disposeSound(sound);
      }
    }
    final music = widget.music;
    if (music != null) {
      loader.disposeSound(music);
    }
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
    final texts =
        widget.menuItems.map((final menuItem) => Text(menuItem.title)).toList();
    final musicSound = widget.music;
    final child = GameShortcuts(
      shortcuts: [
        if (widget.canPop)
          GameShortcut(
            title: 'Close the menu',
            shortcut: widget.backShortcut,
            onStart: Navigator.maybePop,
          ),
        GameShortcut(
          title: 'Move up in the menu',
          shortcut: widget.upShortcut,
          onStart: (final innerContext) => moveUp(),
        ),
        GameShortcut(
          title: 'Move down in the menu',
          shortcut: widget.downShortcut,
          onStart: (final innerContext) => moveDown(),
        ),
        GameShortcut(
          title: 'Activate the current menu item',
          shortcut: widget.activateShortcut,
          onStart: activateItem,
        ),
        GameShortcut(
          title: 'Activate the current menu item',
          shortcut: GameShortcutsShortcut.space,
          onStart: activateItem,
        ),
      ],
      child: Material(
        child: OrientationBuilder(
          builder: (final orientationContext, final orientation) {
            final size = MediaQuery.of(orientationContext).size;
            final ruler = size.longestSide;
            return Semantics(
              excludeSemantics: true,
              label:
                  'Swipe up and down to move through items in the menu or '
                  'turn off your screen reader.',
              customSemanticsActions: {
                for (final menuItem in widget.menuItems)
                  CustomSemanticsAction(label: menuItem.title): () {
                    orientationContext.maybePlaySound(widget.activateItemSound);
                    menuItem.onActivate(orientationContext);
                  },
              },
              child: Stack(
                children: [
                  switch (orientation) {
                    Orientation.portrait => Column(children: texts),
                    Orientation.landscape => Row(children: texts),
                  },
                  TouchMenuArea(
                    onDoubleTap: () => activateItem(orientationContext),
                    onPan: (final point) {
                      final double coordinate;
                      switch (orientation) {
                        case Orientation.portrait:
                          coordinate = point.y;
                        case Orientation.landscape:
                          coordinate = point.x;
                      }
                      final scale = coordinate / ruler;
                      final index =
                          (scale * (widget.menuItems.length - 1)).round();
                      setCurrentMenuItem(index);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
    return ProtectSounds(
      sounds:
          [
            ...widget.menuItems.map((final menuItem) => menuItem.earcon),
            widget.selectItemSound,
            widget.activateItemSound,
          ].whereType<Sound>().toList(),
      child: MaybeMusic(
        music: musicSound,
        fadeInTime: widget.musicFadeInTime,
        fadeOutTime: widget.musicFadeOutTime,
        error: widget.error,
        loading: () => child,
        child: Builder(builder: (final context) => child),
      ),
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
