import 'dart:math';

import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_audio_games/touch.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../gen/assets.gen.dart';
import '../zones.dart';

/// The main level.
class MainLevel extends StatefulWidget {
  /// Create an instance.
  const MainLevel({
    super.key,
  });

  /// Create state for this widget.
  @override
  MainLevelState createState() => MainLevelState();
}

/// State for [MainLevel].
class MainLevelState extends State<MainLevel> {
  /// The audio system to use.
  late final SoLoud audio;

  /// The player's coordinates.
  late Point<int> coordinates;

  /// Whether the player is firing.
  late bool firing;

  /// The direction the player is moving in.
  MovingDirection? movingDirection;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    audio = context.soLoud;
    coordinates = const Point(0, 0);
    firing = false;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final random = Random();
    final footsteps = Assets.sounds.footsteps.values.asSoundList(
      destroy: true,
      soundType: SoundType.asset,
    );
    final ambiance = Assets.sounds.ambiances.forest.asSound(
      destroy: false,
      soundType: SoundType.asset,
      looping: true,
    );
    final firingSound = Assets.sounds.weapons.rifle
        .asSound(destroy: true, soundType: SoundType.asset);
    return TickingTasks(
      tasks: [
        TickingTask(
          duration: const Duration(milliseconds: 500),
          onTick: () async {
            final direction = movingDirection;
            if (direction == null) {
              return;
            }
            if (mounted) {
              await context.playSound(footsteps.randomElement(random));
            }
            final int x;
            final int y;
            switch (direction) {
              case MovingDirection.forwards:
                y = 1;
                x = 0;
              case MovingDirection.backwards:
                y = -1;
                x = 0;
              case MovingDirection.left:
                x = -1;
                y = 0;
              case MovingDirection.right:
                x = 1;
                y = 0;
            }
            coordinates = Point(coordinates.x + x, coordinates.y + y);
            audio.set3dListenerPosition(
              coordinates.x.toDouble(),
              coordinates.y.toDouble(),
              0.0,
            );
          },
        ),
        TickingTask(
          duration: const Duration(seconds: 1),
          onTick: () async {
            if (firing) {
              if (mounted) {
                await context.playSound(firingSound);
              }
            }
          },
        ),
      ],
      child: AmbiancesBuilder(
        ambiances: [
          ambiance,
        ],
        fadeInTime: const Duration(seconds: 3),
        fadeOutTime: const Duration(seconds: 3),
        builder: (final ambiancesContext, final handles) => TouchSurface(
          rows: 2,
          columns: 3,
          child: const Text('Shoot some animals!'),
          onStart: (final zone) {
            if (zone == forwardZone) {
              movingDirection = MovingDirection.forwards;
            } else if (zone == backwardsZone) {
              movingDirection = MovingDirection.backwards;
            } else if (zone == leftZone) {
              movingDirection = MovingDirection.left;
            } else if (zone == rightZone) {
              movingDirection = MovingDirection.right;
            } else if (zone == fireZone) {
              firing = true;
            } else {
              Navigator.pop(ambiancesContext);
            }
          },
          onEnd: (final zone) {
            if (zone == fireZone) {
              firing = false;
            } else {
              movingDirection = null;
            }
          },
        ),
      ),
    );
  }
}
