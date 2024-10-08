import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

import 'src/screens/main_menu.dart';

void main() {
  runApp(const MyApp());
}

/// The top-level app class.
class MyApp extends StatelessWidget {
  /// Create an instance.
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) {
    RendererBinding.instance.ensureSemantics();
    return SoLoudScope(
      child: MaterialApp(
        title: 'Lights Out',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainMenu(),
      ),
    );
  }
}
