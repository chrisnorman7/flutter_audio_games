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
class FirstLevel extends StatelessWidget {
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

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => Music(
        sound: Assets.sounds.ambiances.forest.asSound(
          destroy: false,
          soundType: SoundType.asset,
          loadMode: LoadMode.disk,
          looping: true,
        ),
        fadeInTime: const Duration(seconds: 3),
        fadeOutTime: const Duration(seconds: 5),
        child: SimpleScaffold(
          title: 'Forest Path',
          body: SideScroller(
            surfaces: [
              SideScrollerSurface(
                name: 'Porch',
                onPlayerActivate: (final state) => speak(
                  'You open and close an imaginary door.',
                ),
                onPlayerMove: (final state) {
                  onMove(state.coordinates);
                  if (state.context.mounted) {
                    final footstepSounds =
                        Assets.sounds.footsteps.porch.values.asSoundList(
                      destroy: true,
                      soundType: SoundType.asset,
                    );
                    state.context.playRandomSound(footstepSounds, random);
                  }
                },
                onPlayerEnter: (final state) => speak(
                  'You step up onto the porch.',
                ),
              ),
              SideScrollerSurface(
                name: 'Path',
                playerMoveSpeed: const Duration(seconds: 1),
                onPlayerEnter: (final state) => speak(
                  'You step onto the path.',
                ),
                onPlayerMove: (final state) {
                  onMove(state.coordinates);
                  if (state.context.mounted) {
                    final footstepSounds =
                        Assets.sounds.footsteps.stone.values.asSoundList(
                      destroy: true,
                      soundType: SoundType.asset,
                    );
                    state.context.playRandomSound(footstepSounds, random);
                  }
                },
                width: 20,
              ),
              SideScrollerSurface(
                name: 'Doorway to next level.',
                onPlayerActivate: (final state) => moveToSecondLevel(),
                onPlayerEnter: (final state) => speak(
                  'You walk up to the door.',
                ),
                onPlayerMove: (final state) {
                  onMove(state.coordinates);
                  state.context.playRandomSound(
                    Assets.sounds.footsteps.porch.values.asSoundList(
                      destroy: true,
                      soundType: SoundType.asset,
                    ),
                    random,
                  );
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
            playerCoordinates: initialCoordinates,
          ),
        ),
      );
}
