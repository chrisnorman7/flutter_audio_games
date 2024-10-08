import 'package:flutter/material.dart';

/// A widget that renders as a perfect square, using the available width to
/// calculate the height and keep a 1:1 aspect ratio.
///
/// Code provided by Chat GPT.
class SquareWidget extends StatelessWidget {
  /// Creates a constant [SquareWidget] with a child.
  const SquareWidget({
    required this.child,
    super.key,
  });

  /// The child widget to be displayed inside the square.
  final Widget child;

  @override
  Widget build(final BuildContext context) => LayoutBuilder(
        builder: (final context, final constraints) {
          // Get the minimum of the width and height to create a square
          final size = constraints.maxWidth;

          return SizedBox(
            width: size, // Set width to the available width
            height: size, // Set height equal to the width
            child: child, // The child widget is displayed inside
          );
        },
      );
}
