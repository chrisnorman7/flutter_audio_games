import 'dart:async';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// The keyboard screen.
class KeyboardScreen extends StatefulWidget {
  /// Create an instance.
  const KeyboardScreen({super.key});

  /// Create state for this widget.
  @override
  KeyboardScreenState createState() => KeyboardScreenState();
}

/// State for [KeyboardScreen].
class KeyboardScreenState extends State<KeyboardScreen> {
  /// The note keys to use.
  late final List<GameShortcutsShortcut> noteKeys;

  /// The number of the current octave.
  late int _octaveNumber;

  /// The notes which are currently held down.
  late final Set<MidiNote> _heldNotes;

  /// The playing sounds.
  late final Map<MidiNote, LoadedSound> _playingSounds;

  /// The wave form to use.
  late WaveForm _waveForm;

  /// The volume of the notes.
  late final double volume;

  /// The fade time for notes.
  late final Duration fadeTime;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    noteKeys = [
      GameShortcutsShortcut.keyZ, // c
      GameShortcutsShortcut.keyS, // c#
      GameShortcutsShortcut.keyX, // d
      GameShortcutsShortcut.keyD, // d#
      GameShortcutsShortcut.keyC, // e
      GameShortcutsShortcut.keyV, // f
      GameShortcutsShortcut.keyG, // f#
      GameShortcutsShortcut.keyB, // g
      GameShortcutsShortcut.keyH, // g#
      GameShortcutsShortcut.keyN, // a
      GameShortcutsShortcut.keyJ, // a#
      GameShortcutsShortcut.keyM, // b
      GameShortcutsShortcut.keyQ, // c
      GameShortcutsShortcut.digit2, // c#
      GameShortcutsShortcut.keyW, // d
      GameShortcutsShortcut.digit3, // d#
      GameShortcutsShortcut.keyE, // e
      GameShortcutsShortcut.keyR, // f
      GameShortcutsShortcut.digit5, // f#
      GameShortcutsShortcut.keyT, // g
      GameShortcutsShortcut.digit6, // g#
      GameShortcutsShortcut.keyY, // a
      GameShortcutsShortcut.digit7, // a#
      GameShortcutsShortcut.keyU, // b
      GameShortcutsShortcut.keyI, // c
      GameShortcutsShortcut.digit9, // c#
      GameShortcutsShortcut.keyO, // d
      GameShortcutsShortcut.digit0, // d#
      GameShortcutsShortcut.keyP, // e
    ];
    _octaveNumber = 4;
    _heldNotes = {};
    _playingSounds = {};
    _waveForm = WaveForm.sin;
    volume = 0.5;
    fadeTime = const Duration(milliseconds: 50);
  }

  /// Build a widget.
  @override
  Widget build(BuildContext context) {
    final octaveOffset = _octaveNumber * 12 + 1;
    return SimpleScaffold(
      title: 'Keyboard',
      body: GameShortcuts(
        shortcuts: [
          for (var i = 0; i < noteKeys.length; i++)
            () {
              final shortcut = noteKeys[i];
              final note = MidiNote(octaveOffset + i);
              return GameShortcut(
                title: note.name,
                shortcut: shortcut,
                onStart: (innerContext) => _pressNote(note),
                onStop: (innerContext) => _releaseNote(note),
              );
            }(),
          GameShortcut(
            title: 'Octave Up',
            shortcut: GameShortcutsShortcut.pageUp,
            onStart: (innerContext) {
              setState(() {
                _octaveNumber += 1;
              });
            },
          ),
          GameShortcut(
            title: 'Octave down',
            shortcut: GameShortcutsShortcut.pageDown,
            onStart: (innerContext) => setState(() => _octaveNumber--),
          ),
          GameShortcut(
            title: 'Previous wave type',
            shortcut: GameShortcutsShortcut.home,
            onStart: (innerContext) {
              const forms = WaveForm.values;
              final index = (forms.indexOf(_waveForm) - 1) % forms.length;
              setState(() {
                _waveForm = forms[index];
              });
            },
          ),
          GameShortcut(
            title: 'Next wave type',
            shortcut: GameShortcutsShortcut.end,
            onStart: (innerContext) {
              const forms = WaveForm.values;
              final index = (forms.indexOf(_waveForm) + 1) % forms.length;
              setState(() {
                _waveForm = forms[index];
              });
            },
          ),
        ],
        child: Text('${_waveForm.name}: Octave $_octaveNumber'),
      ),
    );
  }

  /// Press [note].
  Future<void> _pressNote(final MidiNote note) async {
    if (_heldNotes.contains(note)) {
      return;
    }
    final sound = await context.loadAndPlaySound(
      SoundWave.fromMidiNote(midiNote: note, waveForm: _waveForm, volume: 0.0),
    );
    sound.handle.volume.fade(volume, fadeTime);
    _heldNotes.add(note);
    _playingSounds[note] = sound;
  }

  /// Release [note].
  Future<void> _releaseNote(final MidiNote note) async {
    final sound = _playingSounds.remove(note);
    if (sound != null) {
      _heldNotes.remove(note);
      unawaited(sound.handle.stop(fadeOutTime: fadeTime));
    }
  }
}
