import 'dart:math';

import 'package:flutter_soloud/flutter_soloud.dart';

/// Useful methods.
extension SoLoudX on SoLoud {
  /// Set the listener orientation from angle [degrees].
  void set3dListenerOrientation(double degrees) {
    final radians = degrees * pi / 180;

    set3dListenerAt(sin(radians), cos(radians), 0);
    set3dListenerUp(0, 0, 1);
  }

  /// The speed of sound used for 3D audio effects.
  double get soundSpeed3d => get3dSoundSpeed();

  /// Set the speed of sound used for 3D audio effects.
  set soundSpeed3d(double speed) => set3dSoundSpeed(speed);
}
