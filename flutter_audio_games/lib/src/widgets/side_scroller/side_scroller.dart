import 'dart:async';
import 'dart:math';

import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'side_scroller_direction.dart';
import 'side_scroller_surface.dart';

/// A widget for showing a side scroller.
class SideScroller extends StatefulWidget {
  /// Create an instance.
  const SideScroller({
    required this.surfaces,
    this.playerCoordinates = const Point(0, 0),
    this.playerDirection = SideScrollerDirection.right,
    this.playerMoving = false,
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
  final SideScrollerDirection playerDirection;

  /// Whether the player is moving when the level starts.
  final bool playerMoving;

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
  /// The player's coordinates.
  late Point<int> coordinates;

  /// The tiles for this surface.
  late final List<SideScrollerSurface> tiles;

  /// Get the current surface.
  SideScrollerSurface get currentSurface => tiles[coordinates.x];

  /// The direction the player is moving.
  late SideScrollerDirection playerMovingDirection;

  /// Whether the player is moving.
  bool get playerMoving => _playerMoveTimer != null;

  /// The movement timer.
  Timer? _playerMoveTimer;

  /// The time the player can next moved.
  DateTime? _playerNextMoved;

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
    if (widget.playerMoving) {
      startPlayerMoving(widget.playerDirection);
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _playerMoveTimer?.cancel();
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
    return GameShortcuts(
      autofocus: widget.autofocus,
      shortcuts: shortcuts,
      child: Text(
        'Keyboard area',
        style: widget.textStyle,
      ),
    );
  }

  /// Move the player.
  Future<void> movePlayer() async {
    final int x;
    final y = coordinates.y;
    final direction = playerMovingDirection;
    switch (direction) {
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
        stopPlayerMoving();
        await oldSurface.onPlayerLeave?.call(this);
        await newSurface.onPlayerMove?.call(this);
        await newSurface.onPlayerEnter?.call(this);
        await startPlayerMoving(playerMovingDirection);
      }
      await adjustSounds();
    }
  }

  /// Adjust all the playing sounds.
  Future<void> adjustSounds() async {}

  /// Start the player moving in the given [direction].
  Future<void> startPlayerMoving(final SideScrollerDirection direction) async {
    final now = DateTime.now();
    final nextMove = _playerNextMoved;
    if (nextMove != null && nextMove.isAfter(now)) {
      _playerNextMoved = null;
      print('Will wait ${nextMove.difference(now)}.');
      await Future.delayed(nextMove.difference(now));
      if (_playerNextMoved != null) {
        return;
      }
    }
    playerMovingDirection = direction;
    if (playerMoving) {
      return;
    }
    await movePlayer();
    if (!playerMoving) {
      _playerMoveTimer = Timer.periodic(
        currentSurface.playerMoveSpeed,
        (final _) => movePlayer(),
      );
    }
  }

  /// Stop the player moving.
  void stopPlayerMoving() {
    _playerNextMoved ??= DateTime.now().add(currentSurface.playerMoveSpeed);
    print(_playerNextMoved);
    print(DateTime.now().isBefore(_playerNextMoved!));
    _playerMoveTimer?.cancel();
    _playerMoveTimer = null;
  }
}
