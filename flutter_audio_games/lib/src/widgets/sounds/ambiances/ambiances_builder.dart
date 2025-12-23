import 'package:backstreets_widgets/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// A widget which plays [ambiances].
class AmbiancesBuilder extends StatefulWidget {
  /// Create an instance.
  const AmbiancesBuilder({
    required this.ambiances,
    required this.builder,
    required this.error,
    required this.loading,
    this.fadeInTime,
    this.fadeOutTime,
    this.fadeFrom = 0.1,
    super.key,
  });

  /// The ambiances to play.
  final List<Sound> ambiances;

  /// The widget below this widget in the tree.
  final Widget Function(BuildContext context, List<SoundHandle> handles)
  builder;

  /// The function to call with an error.
  final ErrorWidgetCallback error;

  /// The function to call to provide a loading widget.
  final Widget Function() loading;

  /// The fade in time.
  final Duration? fadeInTime;

  /// The fade out time.
  final Duration? fadeOutTime;

  /// The volume to fade from.
  ///
  /// This is a fix while [flutter_soloud #168](https://github.com/alnitak/flutter_soloud/issues/168) is still not fixed.
  final double fadeFrom;

  /// Create state for this widget.
  @override
  AmbiancesBuilderState createState() => AmbiancesBuilderState();
}

/// State for [AmbiancesBuilder].
class AmbiancesBuilderState extends State<AmbiancesBuilder> {
  /// An error object.
  Object? _error;

  /// A stack trace.
  StackTrace? _stackTrace;

  /// Whether the ambiances have loaded yet.
  late bool _loaded;

  /// The ambiance handles.
  late final List<SoundHandle> handles;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    handles = [];
    _loaded = false;
    loadAmbiances();
  }

  /// Load the ambiances.
  Future<void> loadAmbiances() async {
    try {
      for (final handle in handles) {
        await handle.stop();
      }
      handles.clear();
      final fadeInTime = widget.fadeInTime;
      for (final ambiance in widget.ambiances) {
        if (mounted) {
          final handle = await context.playSound(
            ambiance.copyWith(
              volume: fadeInTime == null ? null : widget.fadeFrom,
            ),
          );
          if (mounted) {
            handle.maybeFade(fadeTime: fadeInTime, to: ambiance.volume);
            handles.add(handle);
          } else {
            await handle?.stop();
          }
        }
      }
      setState(() {
        _loaded = true;
      });
      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      setState(() {
        _error = e;
        _stackTrace = s;
      });
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    for (final handle in handles) {
      handle.stop(fadeOutTime: widget.fadeOutTime);
    }
    handles.clear();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final error = _error;
    if (error != null) {
      return widget.error(error, _stackTrace);
    }
    if (_loaded) {
      return widget.builder(context, handles);
    }
    return widget.loading();
  }
}
