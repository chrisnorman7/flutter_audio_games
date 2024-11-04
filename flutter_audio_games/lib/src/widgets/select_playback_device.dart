import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A screen for selecting a new [SoLoud] playback device.
class SelectPlaybackDevice extends StatefulWidget {
  /// Create an instance.
  const SelectPlaybackDevice({
    this.title = 'Select Playback Device',
    this.onDeviceChanged,
    super.key,
  });

  /// The title of the widget.
  final String title;

  /// The function to call when the playback device changes.
  final void Function(PlaybackDevice device)? onDeviceChanged;

  /// Create state for this widget.
  @override
  SelectPlaybackDeviceState createState() => SelectPlaybackDeviceState();
}

/// State for [SelectPlaybackDevice].
class SelectPlaybackDeviceState extends State<SelectPlaybackDevice> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final devices = SoLoud.instance.listPlaybackDevices();
    return SimpleScaffold(
      title: widget.title,
      body: ListView.builder(
        itemBuilder: (final context, final index) {
          final device = devices[index];
          return ListTile(
            autofocus: index == 0,
            selected: device.isDefault,
            title: Text(device.name),
            onTap: () {
              SoLoud.instance.changeDevice(newDevice: device);
              widget.onDeviceChanged?.call(device);
              setState(() {});
            },
          );
        },
        itemCount: devices.length,
        shrinkWrap: true,
      ),
    );
  }
}
