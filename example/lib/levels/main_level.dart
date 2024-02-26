import 'dart:math';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

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
    final footstepSounds = Assets.sounds.footsteps.values.asSoundList();
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
                sound: footstepSounds.getSound(random: random),
                source: source,
                destroy: true,
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
                sound: zombie.saying,
                source: zombie.source,
                destroy: true,
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
                  sound: footstepSounds.getSound(random: random),
                  source: zombie.source,
                  destroy: true,
                );
              }
            },
          ),
        ],
        child: Music(
          music: Assets.sounds.ambiances.mainLevel.asSound(),
          source: source,
          fadeOutLength: 3.0,
          child: Builder(
            builder: (final context) => SimpleScaffold(
              title: 'Main Level',
              body: GameShortcuts(
                shortcuts: [
                  GameShortcut(
                    title: 'Walk forwards',
                    key: PhysicalKeyboardKey.keyW,
                    onStart: (final _) =>
                        player.movingDirection = MovingDirection.forwards,
                    onStop: stopPlayerMoving,
                  ),
                  GameShortcut(
                    title: 'Move backwards',
                    key: PhysicalKeyboardKey.keyS,
                    onStart: (final _) =>
                        player.movingDirection = MovingDirection.backwards,
                    onStop: stopPlayerMoving,
                  ),
                  GameShortcut(
                    title: 'Sidestep left',
                    key: PhysicalKeyboardKey.keyA,
                    onStart: (final _) =>
                        player.movingDirection = MovingDirection.left,
                    onStop: stopPlayerMoving,
                  ),
                  GameShortcut(
                    title: 'Sidestep right',
                    key: PhysicalKeyboardKey.keyD,
                    onStart: (final _) =>
                        player.movingDirection = MovingDirection.right,
                    onStop: stopPlayerMoving,
                  ),
                  GameShortcut(
                    title: 'Turn left',
                    key: PhysicalKeyboardKey.arrowLeft,
                    onStart: (final _) =>
                        player.turningDirection = TurningDirection.left,
                    onStop: stopPlayerTurning,
                  ),
                  GameShortcut(
                    title: 'Turn right',
                    key: PhysicalKeyboardKey.arrowRight,
                    onStart: (final _) =>
                        player.turningDirection = TurningDirection.right,
                    onStop: stopPlayerTurning,
                  ),
                  GameShortcut(
                    title: 'Fire weapon',
                    key: PhysicalKeyboardKey.space,
                    onStart: (final _) => firing = true,
                    onStop: (final _) => firing = false,
                  ),
                  GameShortcut(
                    title: 'Get help',
                    key: PhysicalKeyboardKey.slash,
                    shiftKey: true,
                    onStart: (final innerContext) {
                      final shortcuts =
                          GameShortcuts.maybeOf(innerContext)?.shortcuts ?? [];
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
    );
  }

  /// Add a zombie.
  Future<void> addZombie() async {
    final zombieSayings = Assets.sounds.zombies.sayings.values.asSoundList();
    final breathing = Assets.sounds.zombies.breathing.values.asSoundList();
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
    )
      ..configDeleteBehavior(linger: true)
      ..addInput(reverb);
    final breath = breathing.getSound(random: random);
    final generator = await context.playSound(
      sound: breath,
      source: source,
      destroy: false,
      linger: true,
      looping: true,
    );
    if (mounted) {
      source.addGenerator(generator);
      final zombie = Zombie(
        coordinates: coordinates,
        source: source,
        ambiance: breath,
        ambianceGenerator: generator,
        saying: zombieSayings.getSound(random: random),
        hitPoints: random.nextInt(50),
      );
      zombies.add(zombie);
    } else {
      source.destroy();
      generator.destroy();
    }
  }

  /// Stop the player moving.
  void stopPlayerMoving(final BuildContext innerContext) =>
      player.movingDirection = null;

  /// Stop the player turning.
  void stopPlayerTurning(final BuildContext innerContext) =>
      player.turningDirection = null;

  /// Fire the player's weapon.
  Future<void> fireWeapon(final Source source) async {
    final random = ref.read(randomProvider);
    if (firing) {
      await context.playSound(
        sound: Assets.sounds.combat.gun.asSound(),
        source: source,
        destroy: true,
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
              sound: Assets.sounds.zombies.hits.values
                  .randomElement(random)
                  .asSound(),
              source: zombie.source,
              destroy: true,
            );
            zombie.hitPoints -= random.nextInt(5);
            if (zombie.hitPoints <= 0) {
              if (mounted) {
                await context.playSound(
                  sound: Assets.sounds.zombies.death.values
                      .randomElement(random)
                      .asSound(),
                  source: zombie.source,
                  destroy: true,
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
