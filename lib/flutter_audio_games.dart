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
import 'src/widgets/scenes/timed_builders.dart';
import 'src/widgets/sounds/music/music.dart';
import 'src/widgets/sounds/play_sound_semantics.dart';
import 'src/widgets/tasks/random_tasks/random_tasks.dart';
import 'src/widgets/tasks/ticking/ticking.dart';
import 'src/widgets/tasks/ticking_tasks/ticking_tasks.dart';

export 'src/extensions.dart';
export 'src/maths.dart';
export 'src/moving_direction.dart';
export 'src/sounds/sound.dart';
export 'src/sounds/sound_list.dart';
export 'src/turning_direction.dart';
export 'src/type_defs.dart';
export 'src/widgets/audio_game_menu/audio_game_menu.dart';
export 'src/widgets/audio_game_menu/audio_game_menu_item.dart';
export 'src/widgets/audio_game_menu/audio_game_menu_item_list_tile.dart';
export 'src/widgets/gain_list_tile.dart';
export 'src/widgets/game_shortcuts/game_shortcut.dart';
export 'src/widgets/game_shortcuts/game_shortcuts.dart';
export 'src/widgets/game_shortcuts/game_shortcuts_help_screen.dart';
export 'src/widgets/game_shortcuts/inherited_game_shortcuts.dart';
export 'src/widgets/scenes/scene_builder/scene_builder.dart';
export 'src/widgets/scenes/scene_builder/scene_builder_ambiance.dart';
export 'src/widgets/scenes/scene_builder/scene_builder_ambiance_context.dart';
export 'src/widgets/scenes/timed_builders.dart';
export 'src/widgets/scenes/timed_transitions.dart';
export 'src/widgets/scenes/transition_sound_builder.dart';
export 'src/widgets/sounds/ambiances/ambiances_builder.dart';
export 'src/widgets/sounds/music/inherited_music.dart';
export 'src/widgets/sounds/music/maybe_music.dart';
export 'src/widgets/sounds/music/music.dart';
export 'src/widgets/sounds/play_sound.dart';
export 'src/widgets/sounds/play_sound_semantics.dart';
export 'src/widgets/sounds/reverb_builder/reverb_builder.dart';
export 'src/widgets/sounds/reverb_builder/reverb_preset.dart';
export 'src/widgets/tasks/random_tasks/inherited_random_tasks.dart';
export 'src/widgets/tasks/random_tasks/random_task.dart';
export 'src/widgets/tasks/random_tasks/random_tasks.dart';
export 'src/widgets/tasks/ticking/inherited_ticking.dart';
export 'src/widgets/tasks/ticking/ticking.dart';
export 'src/widgets/tasks/ticking_tasks/ticking_task.dart';
export 'src/widgets/tasks/ticking_tasks/ticking_tasks.dart';
