import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../sounds/loaded_sound.dart';

/// A [ListTile] for editing [gain].
class GainListTile extends StatelessWidget {
  /// Create an instance.
  const GainListTile({
    required this.title,
    required this.gain,
    required this.onChanged,
    required this.volumeChangeSound,
    this.autofocus = false,
    this.minGain = 0.0,
    this.maxGain = 10.0,
    this.gainAdjustment = 0.1,
    super.key,
  });

  /// The title of the [ListTile].
  final String title;

  /// The gain to use.
  final double gain;

  /// The function to call when [gain] changes.
  final ValueChanged<double> onChanged;

  /// The sound to play when the volume changes.
  final LoadedSound volumeChangeSound;

  /// Whether the [ListTile] should be autofocused.
  final bool autofocus;

  /// The minimum gain.
  final double minGain;

  /// The maximum gain.
  final double maxGain;

  /// The volume adjustment to use.
  final double gainAdjustment;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => DoubleListTile(
        value: gain,
        onChanged: (final value) {
          volumeChangeSound.play(
            destroy: true,
            gain: value,
          );
          onChanged(value);
        },
        title: title,
        autofocus: autofocus,
        decimalPlaces: 1,
        min: minGain,
        max: maxGain,
        modifier: gainAdjustment,
        subtitle: '${(gain * 100).floor()}%',
      );
}
