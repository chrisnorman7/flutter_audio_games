import 'dart:math';

import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

/// The random number provider.
@riverpod
Random random(final RandomRef ref) => Random();

/// Provide an asset from a sound.
@Riverpod(keepAlive: true)
Future<LoadedSound> loadedSound(final LoadedSoundRef ref, final Sound sound) =>
    sound.load();
