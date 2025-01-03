import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../flutter_audio_games.dart';

/// The type of a function which builds a button for starting web audio.
typedef WebAudioButtonBuilder = Widget Function(
  BuildContext context,
  VoidCallback onDone,
);

/// Build a button for starting web audio.
///
/// This function relies on a [SoLoudScope] being somewhere in the widget tree.
Widget buildStartWebAudioButton(
  final BuildContext context,
  final VoidCallback onDone,
) =>
    SimpleScaffold(
      title: 'Start Audio',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: TextButton(
              autofocus: true,
              onPressed: () async {
                final audio = SoLoud.instance;
                if (!audio.isInitialized) {
                  final scope = context.soLoudScope;
                  await audio.init(
                    automaticCleanup: scope.automaticCleanup,
                    bufferSize: scope.bufferSize,
                    channels: scope.channels,
                    device: scope.device,
                    sampleRate: scope.sampleRate,
                  );
                }
                onDone();
              },
              child: const Text('Start audio'),
            ),
          ),
        ],
      ),
    );

/// A widget which shows a button for starting web audio.
///
/// If [kIsWeb] is not `true`, then [child] is shown.
class StartWebAudio extends StatefulWidget {
  /// Create an instance.
  const StartWebAudio({
    required this.child,
    this.buttonBuilder,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The function which build the audio button.
  ///
  /// If [buttonBuilder] is `null`, then [buildStartWebAudioButton] will be
  /// used.
  final WebAudioButtonBuilder? buttonBuilder;

  /// Create state for this widget.
  @override
  StartWebAudioState createState() => StartWebAudioState();
}

/// State for [StartWebAudio].
class StartWebAudioState extends State<StartWebAudio> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    if (SoLoud.instance.isInitialized || !kIsWeb) {
      return widget.child;
    }
    return (widget.buttonBuilder ?? buildStartWebAudioButton)(
      context,
      () => setState(() {}),
    );
  }
}
