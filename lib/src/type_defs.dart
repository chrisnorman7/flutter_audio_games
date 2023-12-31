import 'package:flutter/material.dart';

import 'widgets/audio_game_menu/audio_game_menu_item.dart';
import 'widgets/game_shortcuts/game_shortcut.dart';

/// The type of a function which receives a build context as its only argument.
///
/// This typedef is used by [AudioGameMenuItem] and [GameShortcut].
typedef ContextCallback = void Function(BuildContext innerContext);

/// The type of a function which takes both a build [context] and a [value].
typedef BuildContextValueBuilder<T> = Widget Function(
  BuildContext context,
  T value,
);

/// The type of a function to instigate a transition.
typedef OnTransition = void Function(Duration duration, WidgetBuilder builder);
