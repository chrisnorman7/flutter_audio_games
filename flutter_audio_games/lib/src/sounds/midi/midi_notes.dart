import 'package:flutter_audio_games/src/sounds/midi/midi_note.dart';

/// A list of MIDI notes.
final class MidiNotes {
  /// Hide any constructor.
  const MidiNotes._();

  /// Returns a set of all defined MidiNote constants.
  static Set<MidiNote> get notes => const {
    c0,
    c0Sharp,
    d0,
    d0Sharp,
    e0,
    f0,
    f0Sharp,
    g0,
    g0Sharp,
    a0,
    a0Sharp,
    b0,
    a1,
    a1Sharp,
    b1,
    c2,
    c2Sharp,
    d2,
    d2Sharp,
    e2,
    f2,
    f2Sharp,
    g2,
    g2Sharp,
    a2,
    a2Sharp,
    b2,
    c3,
    c3Sharp,
    d3,
    d3Sharp,
    e3,
    f3,
    f3Sharp,
    g3,
    g3Sharp,
    a3,
    a3Sharp,
    b3,
    c4,
    c4Sharp,
    d4,
    d4Sharp,
    e4,
    f4,
    f4Sharp,
    g4,
    g4Sharp,
    a4,
    a4Sharp,
    b4,
    c5,
    c5Sharp,
    d5,
    d5Sharp,
    e5,
    f5,
    f5Sharp,
    g5,
    g5Sharp,
    a5,
    a5Sharp,
    b5,
    c6,
    c6Sharp,
    d6,
    d6Sharp,
    e6,
    f6,
    f6Sharp,
    g6,
    g6Sharp,
    a6,
    a6Sharp,
    b6,
    c7,
    c7Sharp,
    d7,
    d7Sharp,
    e7,
    f7,
    f7Sharp,
    g7,
    g7Sharp,
    a7,
    a7Sharp,
    b7,
    c8,
    c8Sharp,
    d8,
    d8Sharp,
    e8,
    f8,
    f8Sharp,
    g8,
    g8Sharp,
    a8,
    a8Sharp,
    b8,
    c9,
    c9Sharp,
    d9,
    d9Sharp,
    e9,
    f9,
    f9Sharp,
    g9,
  };

  /// C0.
  static const c0 = MidiNote(12);

  /// C0#.
  static const c0Sharp = MidiNote(13);

  /// D0.
  static const d0 = MidiNote(14);

  /// D0#.
  static const d0Sharp = MidiNote(15);

  /// E0.
  static const e0 = MidiNote(16);

  /// F0.
  static const f0 = MidiNote(17);

  /// F0#.
  static const f0Sharp = MidiNote(18);

  /// G0.
  static const g0 = MidiNote(19);

  /// G0#.
  static const g0Sharp = MidiNote(20);

  /// A0.
  static const a0 = MidiNote(21);

  /// A0#.
  static const a0Sharp = MidiNote(22);

  /// B0.
  static const b0 = MidiNote(23);

  /// A1.
  static const a1 = MidiNote(33);

  /// A1#.
  static const a1Sharp = MidiNote(34);

  /// B1.
  static const b1 = MidiNote(35);

  /// C2.
  static const c2 = MidiNote(36);

  /// C2#.
  static const c2Sharp = MidiNote(37);

  /// D2.
  static const d2 = MidiNote(38);

  /// D2#.
  static const d2Sharp = MidiNote(39);

  /// E2.
  static const e2 = MidiNote(40);

  /// F2.
  static const f2 = MidiNote(41);

  /// F2#.
  static const f2Sharp = MidiNote(42);

  /// G2.
  static const g2 = MidiNote(43);

  /// G2#.
  static const g2Sharp = MidiNote(44);

  /// A2.
  static const a2 = MidiNote(45);

  /// A2#.
  static const a2Sharp = MidiNote(46);

  /// B2.
  static const b2 = MidiNote(47);

  /// C3.
  static const c3 = MidiNote(48);

  /// C3#.
  static const c3Sharp = MidiNote(49);

  /// D3.
  static const d3 = MidiNote(50);

  /// D3#.
  static const d3Sharp = MidiNote(51);

  /// E3.
  static const e3 = MidiNote(52);

  /// F3.
  static const f3 = MidiNote(53);

  /// F3#.
  static const f3Sharp = MidiNote(54);

  /// G3.
  static const g3 = MidiNote(55);

  /// G3#.
  static const g3Sharp = MidiNote(56);

  /// A3.
  static const a3 = MidiNote(57);

  /// A3#.
  static const a3Sharp = MidiNote(58);

  /// B3.
  static const b3 = MidiNote(59);

  /// C4.
  static const c4 = MidiNote(60);

  /// C4#.
  static const c4Sharp = MidiNote(61);

  /// D4.
  static const d4 = MidiNote(62);

  /// D4#.
  static const d4Sharp = MidiNote(63);

  /// E4.
  static const e4 = MidiNote(64);

  /// F4.
  static const f4 = MidiNote(65);

  /// F4#.
  static const f4Sharp = MidiNote(66);

  /// G4.
  static const g4 = MidiNote(67);

  /// G4#.
  static const g4Sharp = MidiNote(68);

  /// A4.
  static const a4 = MidiNote(69);

  /// A4#.
  static const a4Sharp = MidiNote(70);

  /// B4.
  static const b4 = MidiNote(71);

  /// C5.
  static const c5 = MidiNote(72);

  /// C5#.
  static const c5Sharp = MidiNote(73);

  /// D5.
  static const d5 = MidiNote(74);

  /// D5#.
  static const d5Sharp = MidiNote(75);

  /// E5.
  static const e5 = MidiNote(76);

  /// F5.
  static const f5 = MidiNote(77);

  /// F5#.
  static const f5Sharp = MidiNote(78);

  /// G5.
  static const g5 = MidiNote(79);

  /// G5#.
  static const g5Sharp = MidiNote(80);

  /// A5.
  static const a5 = MidiNote(81);

  /// A5#.
  static const a5Sharp = MidiNote(82);

  /// B5.
  static const b5 = MidiNote(83);

  /// C6.
  static const c6 = MidiNote(84);

  /// C6#.
  static const c6Sharp = MidiNote(85);

  /// D6.
  static const d6 = MidiNote(86);

  /// D6#.
  static const d6Sharp = MidiNote(87);

  /// E6.
  static const e6 = MidiNote(88);

  /// F6.
  static const f6 = MidiNote(89);

  /// F6#.
  static const f6Sharp = MidiNote(90);

  /// G6.
  static const g6 = MidiNote(91);

  /// G6#.
  static const g6Sharp = MidiNote(92);

  /// A6.
  static const a6 = MidiNote(93);

  /// A6#.
  static const a6Sharp = MidiNote(94);

  /// B6.
  static const b6 = MidiNote(95);

  /// C7.
  static const c7 = MidiNote(96);

  /// C7#.
  static const c7Sharp = MidiNote(97);

  /// D7.
  static const d7 = MidiNote(98);

  /// D7#.
  static const d7Sharp = MidiNote(99);

  /// E7.
  static const e7 = MidiNote(100);

  /// F7.
  static const f7 = MidiNote(101);

  /// F7#.
  static const f7Sharp = MidiNote(102);

  /// G7.
  static const g7 = MidiNote(103);

  /// G7#.
  static const g7Sharp = MidiNote(104);

  /// A7.
  static const a7 = MidiNote(105);

  /// A7#.
  static const a7Sharp = MidiNote(106);

  /// B7.
  static const b7 = MidiNote(107);

  /// C8.
  static const c8 = MidiNote(108);

  /// C8#.
  static const c8Sharp = MidiNote(109);

  /// D8.
  static const d8 = MidiNote(110);

  /// D8#.
  static const d8Sharp = MidiNote(111);

  /// E8.
  static const e8 = MidiNote(112);

  /// F8.
  static const f8 = MidiNote(113);

  /// F8#.
  static const f8Sharp = MidiNote(114);

  /// G8.
  static const g8 = MidiNote(115);

  /// G8#.
  static const g8Sharp = MidiNote(116);

  /// A8.
  static const a8 = MidiNote(117);

  /// A8#.
  static const a8Sharp = MidiNote(118);

  /// B8.
  static const b8 = MidiNote(119);

  /// C9.
  static const c9 = MidiNote(120);

  /// C9#.
  static const c9Sharp = MidiNote(121);

  /// D9.
  static const d9 = MidiNote(122);

  /// D9#.
  static const d9Sharp = MidiNote(123);

  /// E9.
  static const e9 = MidiNote(124);

  /// F9.
  static const f9 = MidiNote(125);

  /// F9#.
  static const f9Sharp = MidiNote(126);

  /// G9.
  static const g9 = MidiNote(127);
}
