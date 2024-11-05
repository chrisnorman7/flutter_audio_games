import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A screen for selecting a new [SoLoud] playback device.
class SelectPlaybackDevice extends StatefulWidget {
  /// Create an instance.
  const SelectPlaybackDevice({
    this.title = 'Select Playback Device',
    this.onDeviceChanged,
    this.defaultString = ' (default)',
    this.currentDevice,
    super.key,
  });

  /// The title of the widget.
  final String title;

  /// The function to call when the playback device changes.
  final void Function(PlaybackDevice device)? onDeviceChanged;

  /// The string which is shown after the name of the default device.
  final String defaultString;

  /// The playback device which is currently being used.
  final PlaybackDevice? currentDevice;

  /// Create state for this widget.
  @override
  SelectPlaybackDeviceState createState() => SelectPlaybackDeviceState();
}

/// State for [SelectPlaybackDevice].
class SelectPlaybackDeviceState extends State<SelectPlaybackDevice> {
  /// The current playback device.
  late PlaybackDevice? currentDevice;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    currentDevice = widget.currentDevice;
  }

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
            selected: (currentDevice == null)
                ? device.isDefault
                : device.id == currentDevice!.id,
            title: Text(
              '${device.name}${device.isDefault ? widget.defaultString : ""}',
            ),
            onTap: () {
              SoLoud.instance.changeDevice(newDevice: device);
              widget.onDeviceChanged?.call(device);
              setState(() {
                currentDevice = device;
              });
            },
          );
        },
        itemCount: devices.length,
        shrinkWrap: true,
      ),
    );
  }
}
