import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// Manage the life cycle of [SoLoud].
class SoLoudScope extends StatefulWidget {
  /// Create an instance.
  const SoLoudScope({
    required this.child,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Create state for this widget.
  @override
  SoLoudScopeState createState() => SoLoudScopeState();
}

/// State for [SoLoudScope].
class SoLoudScopeState extends State<SoLoudScope> {
  /// Initialise state.
  @override
  void initState() {
    super.initState();
    SoLoud.instance.init();
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    SoLoud.instance.deinit();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => widget.child;
}
