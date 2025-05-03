import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

/// A widget which protects a list of [sounds] from being disposed for the
/// duration of its life.
class ProtectSounds extends StatefulWidget {
  /// Create an instance.
  const ProtectSounds({required this.sounds, required this.child, super.key});

  /// The list of sounds to be protected.
  ///
  /// When the widget is disposed, these sounds will be unprotected.
  final List<Sound> sounds;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Create state for this widget.
  @override
  ProtectSoundsState createState() => ProtectSoundsState();
}

/// State for [ProtectSounds].
class ProtectSoundsState extends State<ProtectSounds> {
  /// The source loader to use.
  late final SourceLoader _sourceLoader;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _sourceLoader = context.sourceLoader;
    widget.sounds.forEach(_sourceLoader.protectSound);
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    widget.sounds.forEach(_sourceLoader.unprotectSound);
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => widget.child;
}
