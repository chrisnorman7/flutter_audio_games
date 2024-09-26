import 'dart:async';
import 'dart:math';

import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../../flutter_audio_games.dart';

/// A widget for showing a side scroller.
class SideScroller extends StatefulWidget {
  /// Create an instance.
  const SideScroller({
    required this.surfaces,
    this.playerCoordinates = const Point(0, 0),
    this.playerDirection,
    this.textStyle,
    this.extraShortcuts = const [],
    this.onWall,
    this.autofocus = true,
    this.movePlayerRightKey = GameShortcutsShortcut.arrowRight,
    this.movePlayerLeftKey = GameShortcutsShortcut.arrowLeft,
    this.playerJumpKey = GameShortcutsShortcut.arrowUp,
    this.playerActivateKey = GameShortcutsShortcut.enter,
    super.key,
  }) : assert(surfaces.length > 0, 'The `surfaces` list must not be empty.');

  /// The surfaces the player can move on.
  final List<SideScrollerSurface> surfaces;

  /// The initial coordinates for the player.
  final Point<int> playerCoordinates;

  /// The direction the player starts facing in.
  final SideScrollerDirection? playerDirection;

  /// The text style to use.
  final TextStyle? textStyle;

  /// The extra shortcuts to add to the default set.
  final Iterable<GameShortcut> extraShortcuts;

  /// The function to call when hitting a wall.
  final SideScrollerSurfaceAction? onWall;

  /// Whether [GameShortcuts] should be autofocused.
  final bool autofocus;

  /// The key which will move the player right.
  final GameShortcutsShortcut movePlayerRightKey;

  /// The key which will move the player left.
  final GameShortcutsShortcut movePlayerLeftKey;

  /// The key which will make the player jump.
  final GameShortcutsShortcut playerJumpKey;

  /// The key which will activate the current surface.
  final GameShortcutsShortcut playerActivateKey;

  /// Create state for this widget.
  @override
  SideScrollerState createState() => SideScrollerState();
}

/// State for [SideScroller].
class SideScrollerState extends State<SideScroller> {
  /// The state of the [TimedCommands] widget.
  late TimedCommandsState _timedCommandsState;

  /// The player's coordinates.
  late Point<int> coordinates;

  /// The tiles for this surface.
  late final List<SideScrollerSurface> tiles;

  /// Get the current surface.
  SideScrollerSurface get currentSurface => tiles[coordinates.x];

  /// The direction the player is moving.
  SideScrollerDirection? playerMovingDirection;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    coordinates = widget.playerCoordinates;
    playerMovingDirection = widget.playerDirection;
    tiles = [];
    for (final surface in widget.surfaces) {
      for (var i = 0; i < surface.width; i++) {
        tiles.add(surface);
      }
    }
    currentSurface.onPlayerEnter?.call(this);
    playerMovingDirection = widget.playerDirection;
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final shortcuts = <GameShortcut>[
      ...widget.extraShortcuts,
      GameShortcut(
        title: 'Move left',
        shortcut: widget.movePlayerLeftKey,
        onStart: (final innerContext) => startPlayerMoving(
          SideScrollerDirection.left,
        ),
        onStop: (final innerContext) => stopPlayerMoving(),
      ),
      GameShortcut(
        title: 'Move right',
        shortcut: widget.movePlayerRightKey,
        onStart: (final innerContext) => startPlayerMoving(
          SideScrollerDirection.right,
        ),
        onStop: (final innerContext) => stopPlayerMoving(),
      ),
      GameShortcut(
        title: 'Jump',
        shortcut: widget.playerJumpKey,
        onStart: (final innerContext) => startPlayerMoving(
          SideScrollerDirection.jump,
        ),
        onStop: (final innerContext) => stopPlayerMoving(),
      ),
      GameShortcut(
        title: 'Activate the current surface',
        shortcut: widget.playerActivateKey,
        onStart: (final innerContext) => currentSurface.onPlayerActivate?.call(
          this,
        ),
      ),
    ];
    return TimedCommands(
      builder: (final context, final state) {
        _timedCommandsState = state;
        state.registerCommand(movePlayer, currentSurface.playerMoveSpeed);
        final direction = playerMovingDirection;
        if (direction != null) {
          startPlayerMoving(direction);
        }
        return GameShortcuts(
          autofocus: widget.autofocus,
          shortcuts: shortcuts,
          child: Text(
            'Keyboard area',
            style: widget.textStyle,
          ),
        );
      },
    );
  }

  /// Start the player moving.
  void startPlayerMoving(final SideScrollerDirection direction) {
    playerMovingDirection = direction;
    _timedCommandsState.startCommand(movePlayer);
  }

  /// Stop the player from moving.
  void stopPlayerMoving() {
    _timedCommandsState.stopCommand(movePlayer);
    playerMovingDirection = null;
  }

  /// Move the player.
  Future<void> movePlayer() async {
    final int x;
    final y = coordinates.y;
    final direction = playerMovingDirection;
    switch (direction) {
      case null:
        throw StateError(
          'Why is this command moving when there is no direction to move in?',
        );
      case SideScrollerDirection.left:
        x = coordinates.x - 1;
      case SideScrollerDirection.right:
        x = coordinates.x + 1;
      case SideScrollerDirection.jump:
        return;
    }
    if (x < 0 || x >= tiles.length) {
      return widget.onWall?.call(this);
    }
    final oldSurface = currentSurface;
    coordinates = Point(x, y);
    final newSurface = currentSurface;
    if (context.mounted) {
      if (oldSurface == newSurface) {
        newSurface.onPlayerMove?.call(this);
      } else {
        await oldSurface.onPlayerLeave?.call(this);
        await newSurface.onPlayerMove?.call(this);
        await newSurface.onPlayerEnter?.call(this);
        _timedCommandsState.setCommandInterval(
          movePlayer,
          newSurface.playerMoveSpeed,
        );
      }
      await adjustSounds();
    }
  }

  /// Adjust all the playing sounds.
  Future<void> adjustSounds() async {}
}
