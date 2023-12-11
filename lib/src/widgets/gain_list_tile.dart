import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

/// A [ListTile] for editing [gain].
class GainListTile extends StatelessWidget {
  /// Create an instance.
  const GainListTile({
    required this.title,
    required this.gain,
    required this.onChanged,
    required this.source,
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

  /// The source whose volume should be set.
  final Source source;

  /// The sound to play when the volume changes.
  final String volumeChangeSound;

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
          context.playSound(
            assetPath: volumeChangeSound,
            source: source,
            destroy: true,
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
