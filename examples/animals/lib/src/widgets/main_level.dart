// ignore_for_file: avoid_print

import 'dart:math';

import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_audio_games/touch.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../gen/assets.gen.dart';
import '../animal.dart';
import '../zones.dart';

/// The main level.
class MainLevel extends StatefulWidget {
  /// Create an instance.
  const MainLevel({
    this.maxAnimals = 5,
    this.gunRange = 20,
    super.key,
  });

  /// The maximum number of animals that can be spawned.
  final int maxAnimals;

  /// The range on the gun.
  final int gunRange;

  /// Create state for this widget.
  @override
  MainLevelState createState() => MainLevelState();
}

/// State for [MainLevel].
class MainLevelState extends State<MainLevel> {
  /// The audio system to use.
  late final SoLoud audio;

  /// The player's coordinates.
  late Point<double> coordinates;

  /// Whether the player is firing.
  late bool firing;

  /// The direction the player is moving in.
  MovingDirection? movingDirection;

  /// The animals which have been loaded.
  late final List<Animal> animals;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    audio = context.soLoud;
    coordinates = const Point(0, 0);
    firing = false;
    animals = [];
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    for (final animal in animals) {
      animal.soundHandle.stop();
    }
    animals.clear();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final audio = context.soLoud;
    final random = Random();
    final rangeSeed = widget.gunRange;
    final footsteps = Assets.sounds.footsteps.values.asSoundList(
      destroy: true,
      soundType: SoundType.asset,
    );
    final laughs = Assets.sounds.laughter.values.asSoundList(
      destroy: true,
      soundType: SoundType.asset,
    );
    final animalSounds = Assets.sounds.animals.values.asSoundList(
      destroy: false,
      soundType: SoundType.asset,
      looping: true,
    );
    return TickingTasks(
      tasks: [
        // Movement.
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
              coordinates.x,
              coordinates.y,
              0.0,
            );
          },
        ),

        /// Shooting.
        TickingTask(
          duration: const Duration(milliseconds: 300),
          onTick: () async {
            if (firing && mounted) {
              await context.playSound(
                Assets.sounds.weapons.rifle.asSound(
                  destroy: true,
                  soundType: SoundType.asset,
                ),
              );
              for (final animal in animals) {
                final distanceTo = animal.coordinates.distanceTo(coordinates);
                if (distanceTo <= widget.gunRange) {
                  await animal.soundHandle.stop();
                  animals.remove(animal);
                  if (context.mounted) {
                    await context.playSound(laughs.randomElement(random));
                  }
                  break;
                } else {
                  print('Distance: ${distanceTo.floor()}');
                }
              }
            }
          },
        ),
      ],
      child: RandomTasks(
        tasks: [
          // Move an animal.
          RandomTask(
            getDuration: () => Duration(seconds: random.nextInt(5) + 1),
            onTick: () async {
              if (animals.isEmpty) {
                return;
              }
              final animal = animals.randomElement(random);
              print(
                'Old distance: ${coordinates.distanceTo(animal.coordinates)}',
              );
              final angle = animal.coordinates.angleBetween(coordinates);
              final newCoordinates = animal.coordinates.pointInDirection(
                angle,
                random.nextDouble() * 3,
              );
              print('New distance: ${coordinates.distanceTo(newCoordinates)}');
              animal.coordinates = newCoordinates;
              audio.set3dSourcePosition(
                animal.soundHandle,
                newCoordinates.x,
                newCoordinates.y,
                0.0,
              );
              await context.playSound(
                footsteps.randomElement(random).copyWith(
                      destroy: true,
                      position: SoundPosition3d(
                        newCoordinates.x,
                        newCoordinates.y,
                        0.0,
                      ),
                    ),
              );
            },
          ),
          // Spawn a new animal.
          RandomTask(
            getDuration: () {
              final seconds = random.nextInt(5) + 3;
              return Duration(seconds: seconds);
            },
            onTick: () async {
              if (mounted && animals.length < widget.maxAnimals) {
                final animalCoordinates = Point(
                  (random.nextInt(rangeSeed) - widget.gunRange).toDouble(),
                  (random.nextInt(rangeSeed) - widget.gunRange).toDouble(),
                );
                final sound = animalSounds.randomElement(random).copyWith(
                      position: SoundPosition3d(
                        animalCoordinates.x,
                        animalCoordinates.y,
                        0.0,
                      ),
                    );
                if (context.mounted) {
                  final soundHandle = await context.playSound(sound);
                  final animal = Animal(
                    coordinates: animalCoordinates,
                    soundHandle: soundHandle,
                  );
                  animals.add(animal);
                }
              }
            },
          ),
        ],
        child: AmbiancesBuilder(
          ambiances: [
            Assets.sounds.ambiances.forest.asSound(
              destroy: false,
              soundType: SoundType.asset,
              looping: true,
            ),
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
      ),
    );
  }
}
