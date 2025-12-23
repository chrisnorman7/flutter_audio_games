/// This package provides useful widgets for rapid creation of audio games.
///
/// ## Getting Started
///
/// - Create audio menus with the [AudioGameMenu] class.
/// - Schedule a single task to happen on a regular basis with the [Ticking]
///   widget.
/// - Schedule random tasks with the [RandomTasks] widget.
/// - Add music to any widget by wrapping it in a [Music] widget.
/// - Add a sound to play when a widget is focused by wrapping it in a
///   [PlaySoundSemantics] widget.
/// - Show splash screens and play cut scenes with the [TimedBuilders] widget.
library;

import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

export 'src/asset_span.dart';
export 'src/extensions.dart';
export 'src/maths.dart';
export 'src/moving_direction.dart';
export 'src/sounds/sound_handle_property.dart';
export 'src/sounds/sound_position.dart';
export 'src/sounds/sound_types.dart';
export 'src/sounds/source_loader.dart';
export 'src/sounds/voice_group.dart';
export 'src/turning_direction.dart';
export 'src/widgets/audio_game_menu/audio_game_menu.dart';
export 'src/widgets/audio_game_menu/audio_game_menu_item.dart';
export 'src/widgets/audio_game_menu/audio_game_menu_item_list_tile.dart';
export 'src/widgets/audio_game_menu/audio_game_menu_list_view.dart';
export 'src/widgets/select_playback_device.dart';
export 'src/widgets/side_scroller/side_scroller.dart';
export 'src/widgets/side_scroller/side_scroller_direction.dart';
export 'src/widgets/side_scroller/side_scroller_surface.dart';
export 'src/widgets/side_scroller/side_scroller_surface_object.dart';
export 'src/widgets/so_loud_scope.dart';
export 'src/widgets/sounds/ambiances/ambiances_builder.dart';
export 'src/widgets/sounds/load_sounds.dart';
export 'src/widgets/sounds/maybe_play_sound_semantics.dart';
export 'src/widgets/sounds/music/maybe_music.dart';
export 'src/widgets/sounds/music/music.dart';
export 'src/widgets/sounds/play_sound.dart';
export 'src/widgets/sounds/play_sound_semantics.dart';
export 'src/widgets/sounds/play_sounds_semantics.dart';
export 'src/widgets/sounds/protect_sounds.dart';
export 'src/widgets/start_web_audio.dart';
export 'src/widgets/volume_list_tile.dart';
