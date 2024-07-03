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
    this.orientation = Orientation.landscape,
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

  /// The orientation of this menu.
  final Orientation orientation;

  /// Create state for this widget.
  @override
  TouchMenuState createState() => TouchMenuState();
}

/// State for [TouchMenu].
class TouchMenuState extends State<TouchMenu> {
  /// The currently-selected menu item.
  AudioGameMenuItem? currentMenuItem;

  /// The sounds that are playing.
  late final List<SoundHandle> soundHandles;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
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
      ..forEach(SoLoud.instance.stop)
      ..clear();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final musicSound = widget.music;
    return MaybeMusic(
      music: musicSound,
      builder: (final innerContext) => TouchSurface(
        rows: widget.orientation == Orientation.portrait
            ? widget.menuItems.length
            : 1,
        columns: widget.orientation == Orientation.landscape
            ? widget.menuItems.length
            : 1,
        onMove: (final coordinates) async {
          final int index;
          switch (widget.orientation) {
            case Orientation.portrait:
              index = coordinates.x;
            case Orientation.landscape:
              index = coordinates.y;
          }
          final menuItem = widget.menuItems[index];
          if (menuItem != currentMenuItem) {
            stopSounds();
            currentMenuItem = menuItem;
            for (final sound in [menuItem.earcon, widget.selectItemSound]) {
              if (sound != null && mounted) {
                final handle = await context.playSound(sound);
                if (handle != null) {
                  soundHandles.add(handle);
                }
              }
            }
            setState(() {});
          }
        },
        child: GestureDetector(
          onDoubleTap: () {
            innerContext.maybePlaySound(widget.activateItemSound);
            currentMenuItem?.onActivate(innerContext);
          },
          child: Text(currentMenuItem?.title ?? widget.title),
        ),
      ),
      fadeInTime: widget.musicFadeInTime,
      fadeOutTime: widget.musicFadeOutTime,
    );
  }
}
