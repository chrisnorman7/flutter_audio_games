import 'package:flutter/material.dart';

import '../widgets/audio_game_menu/audio_game_menu_item.dart';
import '../widgets/game_shortcuts/game_shortcut.dart';

/// The type of a function which receives a build context as its only argument.
///
/// This typedef is used by [AudioGameMenuItem] and [GameShortcut].
typedef ContextCallback = void Function(BuildContext innerContext);
