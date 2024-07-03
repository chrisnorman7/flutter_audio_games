/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

class $SoundsGen {
  const $SoundsGen();

  /// Directory path: sounds/menus
  $SoundsMenusGen get menus => const $SoundsMenusGen();

  /// Directory path: sounds/music
  $SoundsMusicGen get music => const $SoundsMusicGen();
}

class $SoundsMenusGen {
  const $SoundsMenusGen();

  /// File path: sounds/menus/activate.mp3
  String get activate => 'sounds/menus/activate.mp3';

  /// File path: sounds/menus/select.mp3
  String get select => 'sounds/menus/select.mp3';

  /// List of all assets
  List<String> get values => [activate, select];
}

class $SoundsMusicGen {
  const $SoundsMusicGen();

  /// File path: sounds/music/main_theme.mp3
  String get mainTheme => 'sounds/music/main_theme.mp3';

  /// List of all assets
  List<String> get values => [mainTheme];
}

class Assets {
  Assets._();

  static const $SoundsGen sounds = $SoundsGen();
}
