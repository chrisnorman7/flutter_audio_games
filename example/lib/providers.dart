import 'dart:math';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provide a sound source.
final sourceProvider = Provider.family<DirectSource, Context>(
  (final ref, final context) => context.createDirectSource(),
);

/// The random number provider.
final randomProvider = Provider<Random>((final ref) => Random());
