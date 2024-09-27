import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

import '../../gen/assets.gen.dart';
import '../constants.dart';

/// The second level.
class SecondLevel extends StatelessWidget {
  /// Create an instance.
  const SecondLevel({
    required this.moveToFirstLevel,
    super.key,
  });

  /// The function to call to move back to the first level.
  final VoidCallback moveToFirstLevel;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => Music(
        sound: Assets.sounds.ambiances.prison.asSound(
          destroy: false,
          soundType: SoundType.asset,
          looping: true,
        ),
        fadeInTime: const Duration(seconds: 3),
        fadeOutTime: const Duration(seconds: 5),
        child: SimpleScaffold(
          title: 'Second Level',
          body: SideScroller(
            surfaces: [
              SideScrollerSurface(
                name: 'Only platform',
                objects: [
                  SideScrollerSurfaceObject(
                    name: 'Doorway back to the first level',
                    ambiance: Assets.sounds.ambiances.door.asSound(
                      destroy: false,
                      soundType: SoundType.asset,
                      looping: true,
                    ),
                  ),
                ],
                width: 20,
                onPlayerActivate: (final state) {
                  if (state.coordinates.x != 0) {
                    return;
                  }
                  moveToFirstLevel();
                },
                onPlayerMove: (final state) {
                  if (state.context.mounted) {
                    state.context.playRandomSound(
                      Assets.sounds.footsteps.porch.values.asSoundList(
                        destroy: true,
                        soundType: SoundType.asset,
                      ),
                      random,
                    );
                  }
                },
              ),
            ],
            onWall: (final state) => state.context.playSound(
              Assets.sounds.doors.wall.asSound(
                destroy: true,
                soundType: SoundType.asset,
              ),
            ),
          ),
        ),
      );
}
