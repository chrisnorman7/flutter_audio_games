import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestWidget extends StatelessWidget {
  /// Create an instance.
  const _TestWidget({required this.data, required this.getSourceLoader});

  /// The text to show.
  final String data;

  /// The method to call to save the source loader.
  final ValueChanged<SourceLoader?> getSourceLoader;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    getSourceLoader(SoLoudScope.maybeOf(context)?.sourceLoader);
    return Text(data);
  }
}

void main() {
  testWidgets('SoLoudScope', (final tester) async {
    SourceLoader? loader;
    const data = 'Hello, world.';
    await tester.pumpWidget(
      SoLoudScope(
        disposeSoLoud: false,
        child: MaterialApp(
          home: SimpleScaffold(
            title: 'Testing',
            body: _TestWidget(
              data: data,
              getSourceLoader: (final value) => loader = value,
            ),
          ),
        ),
      ),
    );
    expect(find.text(data), findsOneWidget);
    expect(loader, isNotNull);
  });
}
