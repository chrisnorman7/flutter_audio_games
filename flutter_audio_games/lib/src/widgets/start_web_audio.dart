import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// The type of a function which builds a button for starting web audio.
typedef WebAudioButtonBuilder = Widget Function(
  BuildContext context,
  VoidCallback onDone,
);

/// Build a button for starting web audio.
Widget buildStartWebAudioButton(
  final BuildContext context,
  final VoidCallback onDone,
) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: TextButton(
            autofocus: true,
            onPressed: () async {
              final audio = SoLoud.instance;
              if (!audio.isInitialized) {
                await audio.init();
              }
              onDone();
            },
            child: const Text('Start audio'),
          ),
        ),
      ],
    );

/// A widget which shows a button for starting web audio.
///
/// If [kIsWeb] is not `true`, then [child] is shown.
class StartWebAudio extends StatefulWidget {
  /// Create an instance.
  const StartWebAudio({
    required this.builder,
    required this.child,
    this.title = 'Start audio',
    super.key,
  });

  /// The function which build the audio button.
  final WebAudioButtonBuilder builder;

  /// The title of the [Scaffold].
  final String title;

  /// The widget below this widget in the tree.
  final Widget child;

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
    return widget.builder(
      context,
      () => setState(() {}),
    );
  }
}
