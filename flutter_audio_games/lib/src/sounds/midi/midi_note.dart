import 'dart:math';

/// A single MIDI note.
class MidiNote {
  /// Create an instance.
  const MidiNote(this.note, {this.referencePitch = 440});

  /// The note value.
  ///
  /// For example: 60 is c4, 61 is c#4, 62 is d4, etc.
  final int note;

  /// The reference pitch for generating the [frequency] from the [note].
  final double referencePitch;

  /// The frequency of this note.
  double get frequency => referencePitch * pow(2.0, (note - 69) / 12);

  /// The name of this note.
  String get name {
    const noteNames = [
      'c',
      'c#',
      'd',
      'd#',
      'e',
      'f',
      'f#',
      'g',
      'g#',
      'a',
      'a#',
      'b',
    ];
    final octave = (note ~/ 12) - 1;
    final noteName = noteNames[note % 12];
    return '$noteName$octave';
  }

  /// Return the hash code.
  @override
  int get hashCode => Object.hash(referencePitch, frequency);

  /// See if [other] matches `this`.
  @override
  bool operator ==(Object other) {
    if (other is MidiNote) {
      return other.referencePitch == referencePitch && other.note == note;
    }
    return super == other;
  }
}
