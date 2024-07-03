import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

/// The random number provider.
@riverpod
Random random(final RandomRef ref) => Random();
