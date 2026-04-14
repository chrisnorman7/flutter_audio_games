import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

import 'screens/keyboard_screen.dart';

void main() {
  runApp(const MyApp());
}

/// The top-level app widget.
class MyApp extends StatelessWidget {
  /// Create an instance.
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) => SoLoudScope(
    child: MaterialApp(
      title: 'Keyboard',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const KeyboardScreen(),
    ),
  );
}
