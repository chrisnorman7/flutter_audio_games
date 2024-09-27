import 'package:flutter_tts/flutter_tts.dart';

/// The TTS system to use.
final tts = FlutterTts();

/// Speak some [text].
Future<void> speak(final String text) async {
  await tts.stop();
  await tts.speak(text);
}
