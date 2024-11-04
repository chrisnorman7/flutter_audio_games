import 'package:flutter_soloud/flutter_soloud.dart';

/// A property on a [SoundHandle] instance.
class SoundHandleProperty<T> {
  /// Create an instance.
  const SoundHandleProperty({
    required this.getValue,
    required this.setValue,
    required final void Function(T to, Duration time) fade,
    required final void Function(
      double from,
      double to,
      Duration time,
    ) oscillate,
  })  : _fade = fade,
        _oscillate = oscillate;

  /// The function to call to get [value].
  final T Function() getValue;

  /// The function to call to set [value].
  final void Function(T value) setValue;

  /// Get the value of this property.
  T get value => getValue();

  /// Set set the value of this property.
  set value(final T newValue) => setValue(newValue);

  final void Function(T to, Duration time) _fade;

  /// Fade [value] over [time] to [to].
  void fade(final T to, final Duration time) => _fade(to, time);

  final void Function(
    double from,
    double to,
    Duration time,
  ) _oscillate;

  /// Oscillate [value] between [from] and [to] over [time].
  void oscillate(final double from, final double to, final Duration time) =>
      _oscillate(from, to, time);
}
