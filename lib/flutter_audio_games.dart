/// This package provides useful widgets for rapid creation of audio games.
///
/// ## Getting Started
///
/// - Create audio menus with the [AudioGameMenu] class.
/// - Schedule a single task to happen on a regular basis with the [Ticking]
///   widget.
/// - Schedule multiple tasks to happen at a given time with the [TickingTasks]
///   widget.
/// - Schedule random tasks with the [RandomTasks] widget.
/// - Add music to any widget by wrapping it in a [Music] widget.
/// - Add a sound to play when a widget is focused by wrapping it in a
///   [PlaySoundSemantics] widget.
/// - Add game shortcuts with the [GameShortcuts] widget.
///
/// This package uses the
/// [flutter_synthizer](https://pub.dev/packages/flutter_synthizer) package.
library flutter_audio_games;

import 'widgets/audio_game_menu/audio_game_menu.dart';
import 'widgets/game_shortcuts/game_shortcuts.dart';
import 'widgets/music/music.dart';
import 'widgets/play_sound_semantics.dart';
import 'widgets/random_tasks/random_tasks.dart';
import 'widgets/ticking//ticking.dart';
import 'widgets/ticking_tasks/ticking_tasks.dart';

export 'package:dart_synthizer/dart_synthizer.dart';
export 'package:flutter_synthizer/flutter_synthizer.dart';

export 'src/extensions.dart';
export 'src/maths.dart';
export 'src/moving_direction.dart';
export 'src/turning_direction.dart';
export 'widgets/audio_game_menu/audio_game_menu.dart';
export 'widgets/audio_game_menu/audio_game_menu_item.dart';
export 'widgets/audio_game_menu/audio_game_menu_item_list_tile.dart';
export 'widgets/game_shortcuts/game_shortcut.dart';
export 'widgets/game_shortcuts/game_shortcuts.dart';
export 'widgets/music/inherited_music.dart';
export 'widgets/music/music.dart';
export 'widgets/play_sound_semantics.dart';
export 'widgets/random_tasks/inherited_random_tasks.dart';
export 'widgets/random_tasks/random_task.dart';
export 'widgets/random_tasks/random_tasks.dart';
export 'widgets/ticking/inherited_ticking.dart';
export 'widgets/ticking/ticking.dart';
export 'widgets/ticking_tasks/ticking_task.dart';
export 'widgets/ticking_tasks/ticking_tasks.dart';
export 'widgets/timed_builders.dart';
