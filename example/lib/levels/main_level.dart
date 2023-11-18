import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  /// The reverb send.
  late final GlobalFdnReverb reverb;

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
    player = Player();
    zombies = [];
    final synthizerContext = context.synthizerContext;
    reverb = synthizerContext.createGlobalFdnReverb();
    synthizerContext.configRoute(
      ref.read(sourceProvider(synthizerContext)),
      reverb,
    );
    firing = false;
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    for (final zombie in zombies) {
      zombie.destroy();
    }
    reverb.destroy();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    reverb.t60.value = 1.0;
    final synthizerContext = context.synthizerContext;
    final source = ref.watch(sourceProvider(synthizerContext));
    final random = ref.watch(randomProvider);
    return TickingTasks(
      tasks: [
        TickingTask(
          onTick: () {
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
              synthizerContext.position.value = Double3(
                coordinates.x,
                coordinates.y,
                0.0,
              );
              context.playSound(
                assetPath: Assets.sounds.footsteps.values.randomElement(random),
                source: source,
              );
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
              synthizerContext.orientation.value =
                  player.heading.angleToDouble6();
            }
          },
        ),
        TickingTask(
          onTick: () => fireWeapon(source),
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
              context.playSound(
                assetPath: zombie.saying,
                source: zombie.source,
              );
            },
          ),
          RandomTask(
            getDuration: () => Duration(seconds: random.nextInt(5) + 1),
            onTick: () {
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
                    max(0.5, zombie.coordinates.distanceTo(player.coordinates)),
                  ),
                );
                context.playSound(
                  assetPath:
                      Assets.sounds.footsteps.values.randomElement(random),
                  source: zombie.source,
                );
              }
            },
          ),
        ],
        child: Music(
          assetPath: Assets.sounds.ambiances.mainLevel,
          source: source,
          fadeOutLength: 3.0,
          child: Builder(
            builder: (final context) => Scaffold(
              appBar: AppBar(title: const Text('Main Level')),
              body: GameShortcuts(
                shortcuts: [
                  GameShortcut(
                    title: 'Walk forwards',
                    key: LogicalKeyboardKey.keyW,
                    onStart: () =>
                        player.movingDirection = MovingDirection.forwards,
                    onStop: stopPlayerMoving,
                  ),
                  GameShortcut(
                    title: 'Move backwards',
                    key: LogicalKeyboardKey.keyS,
                    onStart: () =>
                        player.movingDirection = MovingDirection.backwards,
                    onStop: stopPlayerMoving,
                  ),
                  GameShortcut(
                    title: 'Sidestep left',
                    key: LogicalKeyboardKey.keyA,
                    onStart: () =>
                        player.movingDirection = MovingDirection.left,
                    onStop: stopPlayerMoving,
                  ),
                  GameShortcut(
                    title: 'Sidestep right',
                    key: LogicalKeyboardKey.keyD,
                    onStart: () =>
                        player.movingDirection = MovingDirection.right,
                    onStop: stopPlayerMoving,
                  ),
                  GameShortcut(
                    title: 'Turn left',
                    key: LogicalKeyboardKey.arrowLeft,
                    onStart: () =>
                        player.turningDirection = TurningDirection.left,
                    onStop: stopPlayerTurning,
                  ),
                  GameShortcut(
                    title: 'Turn right',
                    key: LogicalKeyboardKey.arrowRight,
                    onStart: () =>
                        player.turningDirection = TurningDirection.right,
                    onStop: stopPlayerTurning,
                  ),
                  GameShortcut(
                    title: 'Fire weapon',
                    key: LogicalKeyboardKey.space,
                    onStart: () => firing = true,
                    onStop: () => firing = false,
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
    );
  }

  /// Add a zombie.
  Future<void> addZombie() async {
    final random = ref.read(randomProvider);
    final angle = random.nextDouble() * 360;
    final distance = random.nextDouble() * 50.0;
    final coordinates = player.coordinates.pointInDirection(
      angle,
      distance,
    );
    final synthizerContext = context.synthizerContext;
    final source = synthizerContext.createSource3D(
      x: coordinates.x,
      y: coordinates.y,
    )..configDeleteBehavior(linger: true);
    synthizerContext.configRoute(source, reverb);
    final generator = synthizerContext.createBufferGenerator()
      ..looping.value = true;
    source.addGenerator(generator);
    final breathing = Assets.sounds.zombies.breathing.values.randomElement(
      random,
    );
    final buffer = await context.bufferCache.getBuffer(context, breathing);
    if (mounted) {
      generator.buffer.value = buffer;
      final zombie = Zombie(
        coordinates: coordinates,
        source: source,
        ambiance: breathing,
        ambianceGenerator: generator,
        saying: Assets.sounds.zombies.sayings.values.randomElement(random),
        hitPoints: random.nextInt(50),
      );
      zombies.add(zombie);
    } else {
      source.destroy();
      generator.destroy();
    }
  }

  /// Stop the player moving.
  void stopPlayerMoving() => player.movingDirection = null;

  /// Stop the player turning.
  void stopPlayerTurning() => player.turningDirection = null;

  /// Fire the player's weapon.
  Future<void> fireWeapon(final Source source) async {
    final random = ref.read(randomProvider);
    if (firing) {
      await context.playSound(
        assetPath: Assets.sounds.combat.gun,
        source: source,
      );
      final coordinates = player.coordinates;
      final bearing = player.heading;
      for (final zombie in zombies) {
        final angle = normaliseAngle(
          bearing - coordinates.angleBetween(zombie.coordinates),
        );
        if (angle >= 350 || angle <= 10) {
          if (mounted) {
            await context.playSound(
              assetPath:
                  Assets.sounds.zombies.hits.values.randomElement(random),
              source: zombie.source,
            );
            zombie.hitPoints -= random.nextInt(5);
            if (zombie.hitPoints <= 0) {
              if (mounted) {
                await context.playSound(
                  assetPath:
                      Assets.sounds.zombies.death.values.randomElement(random),
                  source: zombie.source,
                );
              }
              zombie.destroy();
              zombies.remove(zombie);
            }
          }
          break;
        }
      }
    }
  }
}
