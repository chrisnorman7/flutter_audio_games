import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

import '../../gen/assets.gen.dart';
import '../constants.dart';
import '../game_level.dart';
import '../levels/first_level.dart';
import '../levels/second_level.dart';

/// A widget to move between levels.
class GameLevels extends StatefulWidget {
  /// Create an instance.
  const GameLevels({
    super.key,
  });

  /// Create state for this widget.
  @override
  GameLevelsState createState() => GameLevelsState();
}

/// State for [GameLevels].
class GameLevelsState extends State<GameLevels> {
  /// The current level.
  late GameLevel level;

  /// The player's coordinates in the main level.
  late Point<int> _firstLevelCoordinates;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    level = GameLevel.mainLevel;
    _firstLevelCoordinates = const Point(0, 0);
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    switch (level) {
      case GameLevel.mainLevel:
        return FirstLevel(
          onMove: (final coordinates) => _firstLevelCoordinates = coordinates,
          moveToSecondLevel: () {
            _activateDoor();
            setState(() {
              level = GameLevel.secondLevel;
            });
          },
          initialCoordinates: _firstLevelCoordinates,
        );
      case GameLevel.secondLevel:
        return SecondLevel(
          moveToFirstLevel: () {
            _activateDoor();
            setState(() {
              level = GameLevel.mainLevel;
            });
          },
        );
    }
  }

  /// Door activation.
  void _activateDoor() {
    speak('You walk through the door.');
    context.playSound(
      Assets.sounds.doors.door
          .asSound(destroy: true, soundType: SoundType.asset),
    );
  }
}
