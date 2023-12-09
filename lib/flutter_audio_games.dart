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
/// - Show splash screens and play cut scenes with the [TimedBuilders] widget.
library flutter_audio_games;

import 'src/widgets/audio_game_menu/audio_game_menu.dart';
import 'src/widgets/game_shortcuts/game_shortcuts.dart';
import 'src/widgets/music/music.dart';
import 'src/widgets/play_sound_semantics.dart';
import 'src/widgets/random_tasks/random_tasks.dart';
import 'src/widgets/scenes/timed_builders.dart';
import 'src/widgets/ticking/ticking.dart';
import 'src/widgets/ticking_tasks/ticking_tasks.dart';

export 'src/extensions.dart';
export 'src/maths.dart';
export 'src/moving_direction.dart';
export 'src/turning_direction.dart';
export 'src/type_defs.dart';
export 'src/widgets/audio_game_menu/audio_game_menu.dart';
export 'src/widgets/audio_game_menu/audio_game_menu_item.dart';
export 'src/widgets/audio_game_menu/audio_game_menu_item_list_tile.dart';
export 'src/widgets/game_shortcuts/game_shortcut.dart';
export 'src/widgets/game_shortcuts/game_shortcuts.dart';
export 'src/widgets/game_shortcuts/inherited_game_shortcuts.dart';
export 'src/widgets/music/inherited_music.dart';
export 'src/widgets/music/music.dart';
export 'src/widgets/play_sound.dart';
export 'src/widgets/play_sound_semantics.dart';
export 'src/widgets/random_tasks/inherited_random_tasks.dart';
export 'src/widgets/random_tasks/random_task.dart';
export 'src/widgets/random_tasks/random_tasks.dart';
export 'src/widgets/scenes/timed_builders.dart';
export 'src/widgets/ticking/inherited_ticking.dart';
export 'src/widgets/ticking/ticking.dart';
export 'src/widgets/ticking_tasks/ticking_task.dart';
export 'src/widgets/ticking_tasks/ticking_tasks.dart';
