import 'dart:math';

import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// Useful methods.
extension SoLoudX on SoLoud {
  /// Set the listener orientation from [angle].
  void set3dListenerOrientation(final double angle) {
    final rads = angleToRad(angle);
    final x = cos(rads);
    final y = sin(rads);
    const z = -1.0;
    set3dListenerAt(x, y, z);
  }
}
