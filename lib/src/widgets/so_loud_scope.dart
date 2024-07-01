import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:http/http.dart';

import '../sounds/source_loader.dart';

/// Manage the life cycle of [SoLoud].
class SoLoudScope extends StatefulWidget {
  /// Create an instance.
  const SoLoudScope({
    required this.child,
    this.loadMode = LoadMode.memory,
    this.httpClient,
    super.key,
  });

  /// Get the nearest state or `null`.
  static SoLoudScopeState? maybeOf(final BuildContext context) =>
      context.findAncestorStateOfType<SoLoudScopeState>();

  /// Get the nearest state.
  static SoLoudScopeState of(final BuildContext context) => maybeOf(context)!;

  /// The load mode to use when loading sounds.
  final LoadMode loadMode;

  /// The HTTP client to use when loading sounds from urls.
  final Client? httpClient;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Create state for this widget.
  @override
  SoLoudScopeState createState() => SoLoudScopeState();
}

/// State for [SoLoudScope].
class SoLoudScopeState extends State<SoLoudScope> {
  /// The so loud instance to use.
  late final SoLoud soLoud;

  /// The source loader to use.
  late final SourceLoader sourceLoader;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    soLoud = SoLoud.instance;
    sourceLoader = SourceLoader(
      assetBundle: DefaultAssetBundle.of(context),
      loadMode: widget.loadMode,
      httpClient: widget.httpClient,
    );
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
