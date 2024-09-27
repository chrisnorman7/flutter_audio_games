import 'dart:math';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../gen/assets.gen.dart';
import '../constants.dart';
import '../widgets/game_levels.dart';

/// The first level.
class FirstLevel extends StatefulWidget {
  /// Create an instance.
  const FirstLevel({
    required this.onMove,
    required this.moveToSecondLevel,
    required this.initialCoordinates,
    super.key,
  });

  /// The function to call to send the coordinates back to [GameLevels].
  final void Function(Point<int> coordinates) onMove;

  /// The function to call to move to the second level.
  final VoidCallback moveToSecondLevel;

  /// The coordinates to start the player at.
  final Point<int> initialCoordinates;

  @override
  State<FirstLevel> createState() => _FirstLevelState();
}

class _FirstLevelState extends State<FirstLevel> {
  /// The side scroller state to work with.
  SideScrollerState? _sideScrollerState;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final thing = SideScrollerSurfaceObject(
      name: 'Thing',
      ambiance: Assets.sounds.thing.breathing.asSound(
        destroy: false,
        soundType: SoundType.asset,
        looping: true,
      ),
    );
    return RandomTasks(
      tasks: [
        RandomTask(
          getDuration: () {
            final state = _sideScrollerState;
            if (state != null) {
              return Duration(milliseconds: state.random.nextInt(3000) + 500);
            }
            return const Duration(seconds: 2);
          },
          onTick: () {
            final state = _sideScrollerState;
            if (state == null) {
              return;
            }
            final position = state.getObjectCoordinates(thing);
            if (state.coordinates == position) {
              if (state.random.nextInt(5) == 0) {
                context.playSound(
                  Assets.sounds.thing.screech.asSound(
                    destroy: true,
                    soundType: SoundType.asset,
                  ),
                );
              }
            } else {
              final modifier = state.coordinates.x < position.x ? -1 : 1;
              final newPosition = Point(position.x + modifier, position.y);
              try {
                final surface = state.getSurfaceAt(newPosition);
                state.moveObject(thing, newPosition);
                context.playRandomSound(
                  surface.footstepSounds
                      .map(
                        (final sound) => sound.copyWith(
                          volume: state.getSoundVolume(sound, newPosition),
                          position: SoundPositionPanned(
                            state.getSoundPan(newPosition),
                          ),
                        ),
                      )
                      .toList(),
                  state.random,
                );
                // ignore: avoid_catching_errors
              } on RangeError {
                // Don't move the thing.
              }
            }
          },
        ),
      ],
      child: Music(
        sound: Assets.sounds.ambiances.forest.asSound(
          destroy: false,
          soundType: SoundType.asset,
          loadMode: LoadMode.disk,
          looping: true,
        ),
        fadeInTime: const Duration(seconds: 3),
        fadeOutTime: const Duration(seconds: 5),
        child: SimpleScaffold(
          title: 'First Level',
          body: SideScroller(
            surfaces: [
              SideScrollerSurface(
                name: 'Porch',
                footstepSounds:
                    Assets.sounds.footsteps.porch.values.asSoundList(
                  destroy: true,
                  soundType: SoundType.asset,
                ),
                onPlayerMove: (final state) {
                  _sideScrollerState = state;
                  widget.onMove(state.coordinates);
                },
                onPlayerEnter: (final state) => speak(
                  'You step up onto the porch.',
                ),
              ),
              SideScrollerSurface(
                name: 'Path',
                footstepSounds:
                    Assets.sounds.footsteps.stone.values.asSoundList(
                  destroy: true,
                  soundType: SoundType.asset,
                ),
                playerMoveSpeed: const Duration(seconds: 1),
                onPlayerEnter: (final state) => speak(
                  'You step onto the path.',
                ),
                onPlayerMove: (final state) {
                  widget.onMove(state.coordinates);
                },
                width: 20,
              ),
              SideScrollerSurface(
                name: 'Doorway to next level.',
                footstepSounds:
                    Assets.sounds.footsteps.porch.values.asSoundList(
                  destroy: true,
                  soundType: SoundType.asset,
                ),
                onPlayerActivate: (final state) => widget.moveToSecondLevel(),
                onPlayerMove: (final state) {
                  widget.onMove(state.coordinates);
                },
                width: 1,
                objects: [
                  SideScrollerSurfaceObject(
                    name: 'Audible alert',
                    ambiance: Assets.sounds.ambiances.door.asSound(
                      destroy: false,
                      soundType: SoundType.asset,
                      looping: true,
                    ),
                  ),
                  thing,
                ],
              ),
            ],
            extraShortcuts: [
              GameShortcut(
                title: 'Speak coordinates',
                shortcut: GameShortcutsShortcut.keyC,
                onStart: (final innerContext) {
                  final state = innerContext
                      .findAncestorStateOfType<SideScrollerState>()!;
                  speak('${state.coordinates.x}, ${state.coordinates.y}');
                },
              ),
            ],
            onWall: (final state) => state.context.playSound(
              Assets.sounds.doors.wall.asSound(
                destroy: true,
                soundType: SoundType.asset,
              ),
            ),
            playerCoordinates: widget.initialCoordinates,
          ),
        ),
      ),
    );
  }
}
