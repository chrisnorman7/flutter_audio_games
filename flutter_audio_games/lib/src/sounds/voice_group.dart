import 'package:flutter_soloud/flutter_soloud.dart';

/// The voice group class.
class VoiceGroup {
  /// Create an instance.
  VoiceGroup() : handle = SoLoud.instance.createVoiceGroup();

  /// The handle to use.
  final SoundHandle handle;

  /// The so loud instance to use.
  SoLoud get soLoud => SoLoud.instance;

  /// Add [voiceHandles] to this voice group.
  void addVoices(final List<SoundHandle> voiceHandles) =>
      soLoud.addVoicesToGroup(handle, voiceHandles);

  /// Destroy this voice group.
  void destroy() => soLoud.destroyVoiceGroup(handle);

  /// Check if this voice group is empty.
  bool get isEmpty => soLoud.isVoiceGroupEmpty(handle);
}
