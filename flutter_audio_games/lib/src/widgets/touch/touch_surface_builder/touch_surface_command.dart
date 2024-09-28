import 'package:backstreets_widgets/typedefs.dart';
import 'package:backstreets_widgets/widgets.dart';

/// A touch command.
class TouchSurfaceCommand {
  /// Create an instance.
  const TouchSurfaceCommand({
    required this.description,
    required this.shortcut,
    this.onStart,
    this.onStop,
  });

  /// The description of this command.
  final String description;

  /// The shortcut which will activate this command.
  final GameShortcutsShortcut shortcut;

  /// The function to call when this command is started.
  final ContextCallback? onStart;

  /// The function to? call when this function is stopped.
  final ContextCallback? onStop;
}
