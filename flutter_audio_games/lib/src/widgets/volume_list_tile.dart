import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

/// A [ListTile] for editing [volume].
class VolumeListTile extends StatelessWidget {
  /// Create an instance.
  const VolumeListTile({
    required this.title,
    required this.volume,
    required this.onChanged,
    required this.volumeChangeSound,
    this.autofocus = false,
    this.minVolume = 0.0,
    this.maxVolume = 10.0,
    this.volumeAdjustment = 0.1,
    super.key,
  });

  /// The title of the [ListTile].
  final String title;

  /// The current volume.
  final double volume;

  /// The function to call when [volume] changes.
  final ValueChanged<double> onChanged;

  /// The sound to play when the volume changes.
  final Sound volumeChangeSound;

  /// Whether the [ListTile] should be autofocused.
  final bool autofocus;

  /// The minimum volume.
  final double minVolume;

  /// The maximum volume.
  final double maxVolume;

  /// The volume adjustment to use.
  final double volumeAdjustment;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => DoubleListTile(
    value: volume,
    onChanged: (final value) {
      context.playSound(volumeChangeSound.copyWith(volume: value));
      onChanged(value);
    },
    title: title,
    autofocus: autofocus,
    decimalPlaces: 1,
    min: minVolume,
    max: maxVolume,
    modifier: volumeAdjustment,
    subtitle: '${(volume * 100).floor()}%',
  );
}
