import 'dart:math';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../game_objects/player.dart';
import '../game_objects/zombie.dart';
import '../gen/assets.gen.dart';
import '../providers.dart';

/// The main level.
class MainLevel extends ConsumerStatefulWidget {
  /// Create an instance.
  const MainLevel({
    super.key,
  });

  /// Create state for this widget.
  @override
  MainLevelState createState() => MainLevelState();
}

/// State for [MainLevel].
class MainLevelState extends ConsumerState<MainLevel> {
  /// The sound of the gun.
  late final Sound fireSound;

  /// The player object.
  late final Player player;

  /// The zombies that are loaded.
  late final List<Zombie> zombies;

  /// Whether or not the player is shooting.
  late bool firing;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    fireSound = Assets.sounds.combat.gun.asSound(
      destroy: true,
      soundType: SoundType.asset,
    );
    player = Player();
    zombies = [];
    firing = false;
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    for (final zombie in zombies) {
      zombie.destroy();
    }
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    const fadeInTime = Duration(seconds: 1);
    const fadeOutTime = Duration(seconds: 3);
    final footstepSounds = Assets.sounds.footsteps.values.asSoundList(
      destroy: true,
      soundType: SoundType.asset,
    );
    final random = ref.watch(randomProvider);
    return AmbiancesBuilder(
      ambiances: [
        Assets.sounds.ambiances.fire.asSound(
          destroy: false,
          soundType: SoundType.asset,
          volume: 1.0,
          looping: true,
          position: const SoundPosition3d(5, 2, 0),
        ),
      ],
      builder: (final context, final ambiances) => TickingTasks(
        tasks: [
          TickingTask(
            onTick: () async {
              final direction = player.movingDirection;
              if (direction != null) {
                final double distance;
                final double bearing;
                switch (direction) {
                  case MovingDirection.forwards:
                    distance = 0.5;
                    bearing = player.heading;
                    break;
                  case MovingDirection.backwards:
                    distance = 0.1;
                    bearing = normaliseAngle(player.heading + 180);
                    break;
                  case MovingDirection.left:
                    distance = 0.2;
                    bearing = normaliseAngle(player.heading - 90);
                    break;
                  case MovingDirection.right:
                    distance = 0.2;
                    bearing = normaliseAngle(player.heading + 90);
                    break;
                }
                final coordinates = player.coordinates.pointInDirection(
                  bearing,
                  distance,
                );
                player.coordinates = coordinates;
                SoLoud.instance.set3dListenerPosition(
                  coordinates.x,
                  coordinates.y,
                  0,
                );
                final footstep = footstepSounds.randomElement(random);
                await context.playSound(footstep);
              }
            },
            duration: const Duration(milliseconds: 300),
          ),
          TickingTask(
            duration: const Duration(milliseconds: 50),
            onTick: () {
              final turning = player.turningDirection;
              if (turning != null) {
                final double amount;
                switch (turning) {
                  case TurningDirection.left:
                    amount = -5.0;
                    break;
                  case TurningDirection.right:
                    amount = 5.0;
                    break;
                }
                player.heading = normaliseAngle(player.heading + amount);
                SoLoud.instance.set3dListenerOrientation(player.heading);
              }
            },
          ),
          TickingTask(
            onTick: fireWeapon,
            duration: const Duration(milliseconds: 200),
          ),
        ],
        child: RandomTasks(
          tasks: [
            RandomTask(
              getDuration: () => Duration(seconds: random.nextInt(5) + 5),
              onTick: () {
                if (zombies.length < 10) {
                  addZombie();
                  return;
                }
                final zombie = zombies.randomElement(random);
                zombie.playSound(
                  context: context,
                  sound: zombie.saying,
                );
              },
            ),
            RandomTask(
              getDuration: () => Duration(seconds: random.nextInt(5) + 1),
              onTick: () async {
                if (zombies.isEmpty) {
                  return;
                }
                final zombie = zombies.randomElement(random);
                if (zombie.coordinates.distanceTo(player.coordinates) > 0.5) {
                  final angle =
                      zombie.coordinates.angleBetween(player.coordinates);
                  zombie.move(
                    zombie.coordinates.pointInDirection(
                      angle,
                      max(
                        0.5,
                        zombie.coordinates.distanceTo(player.coordinates),
                      ),
                    ),
                  );
                  final footstepSound = footstepSounds.randomElement(random);
                  await zombie.playSound(
                    context: context,
                    sound: footstepSound,
                  );
                }
              },
            ),
          ],
          child: Music(
            sound: Assets.sounds.ambiances.mainLevel.asSound(
              destroy: false,
              soundType: SoundType.asset,
              looping: true,
            ),
            fadeInTime: fadeInTime,
            fadeOutTime: fadeOutTime,
            child: Builder(
              builder: (final context) => SimpleScaffold(
                title: 'Main Level',
                body: GameShortcuts(
                  shortcuts: [
                    GameShortcut(
                      title: 'Walk forwards',
                      shortcut: GameShortcutsShortcut.keyW,
                      onStart: (final _) =>
                          player.movingDirection = MovingDirection.forwards,
                      onStop: stopPlayerMoving,
                    ),
                    GameShortcut(
                      title: 'Move backwards',
                      shortcut: GameShortcutsShortcut.keyS,
                      onStart: (final _) =>
                          player.movingDirection = MovingDirection.backwards,
                      onStop: stopPlayerMoving,
                    ),
                    GameShortcut(
                      title: 'Sidestep left',
                      shortcut: GameShortcutsShortcut.keyA,
                      onStart: (final _) =>
                          player.movingDirection = MovingDirection.left,
                      onStop: stopPlayerMoving,
                    ),
                    GameShortcut(
                      title: 'Sidestep right',
                      shortcut: GameShortcutsShortcut.keyD,
                      onStart: (final _) =>
                          player.movingDirection = MovingDirection.right,
                      onStop: stopPlayerMoving,
                    ),
                    GameShortcut(
                      title: 'Turn left',
                      shortcut: GameShortcutsShortcut.arrowLeft,
                      onStart: (final _) =>
                          player.turningDirection = TurningDirection.left,
                      onStop: stopPlayerTurning,
                    ),
                    GameShortcut(
                      title: 'Turn right',
                      shortcut: GameShortcutsShortcut.arrowRight,
                      onStart: (final _) =>
                          player.turningDirection = TurningDirection.right,
                      onStop: stopPlayerTurning,
                    ),
                    GameShortcut(
                      title: 'Fire weapon',
                      shortcut: GameShortcutsShortcut.space,
                      onStart: (final _) => firing = true,
                      onStop: (final _) => firing = false,
                    ),
                    GameShortcut(
                      title: 'Get help',
                      shortcut: GameShortcutsShortcut.slash,
                      shiftKey: true,
                      onStart: (final innerContext) {
                        final shortcuts =
                            GameShortcuts.maybeOf(innerContext)?.shortcuts ??
                                [];
                        pushWidget(
                          context: innerContext,
                          builder: (final builderContext) =>
                              GameShortcutsHelpScreen(
                            shortcuts: shortcuts,
                          ),
                        );
                      },
                    ),
                  ],
                  child: const Center(
                    child: Text('Keyboard area'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      fadeInTime: fadeInTime,
      fadeOutTime: fadeOutTime,
    );
  }

  /// Add a zombie.
  Future<void> addZombie() async {
    final zombieSayings = Assets.sounds.zombies.sayings.values.asSoundList(
      destroy: true,
      soundType: SoundType.asset,
    );
    final breathing = Assets.sounds.zombies.breathing.values.asSoundList(
      destroy: false,
      soundType: SoundType.asset,
      looping: true,
    );
    final random = ref.read(randomProvider);
    final angle = random.nextDouble() * 360;
    final distance = random.nextDouble() * 50.0;
    final coordinates = player.coordinates.pointInDirection(
      angle,
      distance,
    );
    final breath = breathing.randomElement(random);
    final ambianceHandle = await context.playSound(
      breath.copyWith(
        position: SoundPosition3d(coordinates.x, coordinates.y, 0.0),
      ),
    );
    if (mounted) {
      final zombie = Zombie(
        coordinates: coordinates,
        ambiance: breath,
        ambianceHandle: ambianceHandle!,
        saying: zombieSayings.randomElement(random),
        hitPoints: random.nextInt(50),
      );
      zombies.add(zombie);
    } else {
      await ambianceHandle?.stop();
    }
  }

  /// Stop the player moving.
  void stopPlayerMoving(final BuildContext innerContext) =>
      player.movingDirection = null;

  /// Stop the player turning.
  void stopPlayerTurning(final BuildContext innerContext) =>
      player.turningDirection = null;

  /// Fire the player's weapon.
  Future<void> fireWeapon() async {
    final random = ref.read(randomProvider);
    if (firing) {
      await context.playSound(fireSound);
      final coordinates = player.coordinates;
      final bearing = player.heading;
      for (final zombie in zombies) {
        final angle = normaliseAngle(
          bearing - coordinates.angleBetween(zombie.coordinates),
        );
        if (angle >= 350 || angle <= 10) {
          final hitSound = Assets.sounds.zombies.hits.values
              .randomElement(
                random,
              )
              .asSound(destroy: true, soundType: SoundType.asset);
          if (mounted) {
            await zombie.playSound(
              context: context,
              sound: hitSound,
            );
          }
          zombie.hitPoints -= random.nextInt(5);
          if (zombie.hitPoints <= 0) {
            if (mounted) {
              final deathSound = Assets.sounds.zombies.death.values
                  .randomElement(random)
                  .asSound(destroy: true, soundType: SoundType.asset);
              await zombie.playSound(
                context: context,
                sound: deathSound,
              );
            }
            zombie.destroy();
            zombies.remove(zombie);
          }
          break;
        }
      }
    }
  }
}
