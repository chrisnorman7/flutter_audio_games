import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:http/http.dart';

import '../sounds/source_loader.dart';

/// Manage the life cycle of [SoLoud].
///
/// This widget should be placed as close to the top of the widget tree as
/// possible, preferably above [MaterialApp].
class SoLoudScope extends StatefulWidget {
  /// Create an instance.
  const SoLoudScope({
    required this.child,
    this.httpClient,
    this.loadCustomSound = defaultLoadCustomSound,
    this.loggerName = 'SoLoudScope',
    super.key,
  });

  /// Get the nearest state or `null`.
  static SoLoudScopeState? maybeOf(final BuildContext context) =>
      context.findAncestorStateOfType<SoLoudScopeState>();

  /// Get the nearest state.
  static SoLoudScopeState of(final BuildContext context) => maybeOf(context)!;

  /// The HTTP client to use when loading sounds from urls.
  final Client? httpClient;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The function which will load custom sources.
  final LoadSound loadCustomSound;

  /// The name of the logger to use.
  final String loggerName;

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
      soLoud: soLoud,
      assetBundle: DefaultAssetBundle.of(context),
      httpClient: widget.httpClient,
      loadCustomSound: widget.loadCustomSound,
      loggerName: widget.loggerName,
    );
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    sourceLoader.disposeUnusedSources();
    SoLoud.instance.deinit();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => widget.child;
}
