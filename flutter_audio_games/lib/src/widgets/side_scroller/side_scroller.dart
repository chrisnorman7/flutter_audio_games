import 'dart:async';
import 'dart:math';

import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../../flutter_audio_games.dart';

/// A widget for showing a side scroller.
class SideScroller extends StatefulWidget {
  /// Create an instance.
  const SideScroller({
    required this.surfaces,
    this.loading = LoadingWidget.new,
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
    this.panDistance = 10,
    this.muteDistance = 20,
    super.key,
  })  : assert(surfaces.length > 0, 'The `surfaces` list must not be empty.'),
        assert(panDistance > 0, '`panDistance` must be greater than 0.'),
        assert(muteDistance > 0, '`muteDistance` must be greater than 0.');

  /// The surfaces the player can move on.
  final List<SideScrollerSurface> surfaces;

  /// The function to call to show a loading widget.
  final Widget Function() loading;

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

  /// The distance between the player and a sound when the sound will be panned,
  /// rather than attenuated.
  final double panDistance;

  /// The distance before a sound will be muted.
  ///
  /// The [muteDistance] will only be taken into account after the distance
  /// between the player and the sound is greater than [panDistance].
  final double muteDistance;

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

  /// The coordinates of the objects.
  late final List<Point<int>> _objectCoordinates;

  /// The sounds made by the objects on this level.
  late final List<SoundHandle> _objectSounds;

  /// Get the current surface.
  SideScrollerSurface get currentSurface => tiles[coordinates.x];

  /// The direction the player is moving.
  SideScrollerDirection? playerMovingDirection;

  /// Whether the sounds have been initialised.
  late bool _initSoundsCalled;

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
    _objectCoordinates = widget.objects
        .map((final object) => object.initialCoordinates)
        .toList();
    _objectSounds = [];
    _initSoundsCalled = false;
  }

  /// Returns the difference between `start.x`, and `end.x`.
  int distanceBetween(final Point<int> start, final Point<int> end) =>
      max(start.x, end.x) - min(start.x, end.x);

  /// Get a suitable pan for a sound at [position].
  double getSoundPan(final Point<int> position) {
    if (position == coordinates) {
      return 0.0;
    }
    final distance = distanceBetween(coordinates, position);
    if (distance <= widget.panDistance) {
      final panAdjust = 1.0 / widget.panDistance;
      final newPan = panAdjust * distance;
      if (position.x < coordinates.x) {
        return -newPan;
      }
      return newPan;
    }
    return 0.0;
  }

  /// Get a volume suitable for playing [sound] at [position].
  double getSoundVolume(final Sound sound, final Point<int> position) {
    if (position == coordinates) {
      return sound.volume;
    }
    final distance = distanceBetween(coordinates, position);
    if (distance <= widget.panDistance || distance >= widget.muteDistance) {
      return sound.volume;
    }
    return sound.volume / widget.muteDistance * (distance - widget.panDistance);
  }

  /// Initialise object sounds.
  Future<void> initSounds() async {
    final c = context;
    for (final soundHandle in _objectSounds) {
      await soundHandle.stop();
    }
    _objectSounds.clear();
    for (final object in widget.objects) {
      if (c.mounted) {
        final soundHandle = await c.playSound(
          object.ambiance.copyWith(
            volume: getSoundVolume(object.ambiance, object.initialCoordinates),
            position: SoundPositionPanned(
              getSoundPan(object.initialCoordinates),
            ),
          ),
        );
        if (c.mounted) {
          _objectSounds.add(soundHandle);
        } else {
          await soundHandle.stop();
          return;
        }
      } else {
        return;
      }
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    if (!_initSoundsCalled) {
      initSounds().then(
        (final _) => setState(() {
          _initSoundsCalled = true;
        }),
      );
      return widget.loading();
    }
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
  Future<void> adjustSounds() async {
    for (var i = 0; i < _objectCoordinates.length; i++) {
      final object = widget.objects[i];
      final soundHandle = _objectSounds[i];
      final position = _objectCoordinates[i];
      final sound = object.ambiance;
      soundHandle
        ..pan = getSoundPan(position)
        ..volume = getSoundVolume(sound, position);
    }
  }
}
