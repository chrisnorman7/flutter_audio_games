import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// Useful methods on sound handles.
extension SoundHandleX on SoundHandle {
  /// Stop this handle.
  Future<void> stop({
    final Duration? fadeOutTime,
    final double fadeTo = 0.0,
  }) async {
    if (fadeOutTime == null) {
      await SoLoud.instance.stop(this);
    } else {
      volume.fade(fadeTo, fadeOutTime);
      scheduleStop(fadeOutTime);
    }
  }

  /// The volume property.
  SoundHandleProperty<double> get volume => SoundHandleProperty(
        getValue: () => SoLoud.instance.getVolume(this),
        setValue: (final value) => SoLoud.instance.setVolume(this, value),
        fade: (final to, final time) => SoLoud.instance.fadeVolume(
          this,
          to,
          time,
        ),
        oscillate: (final from, final to, final time) =>
            SoLoud.instance.oscillateVolume(
          this,
          from,
          to,
          time,
        ),
      );

  /// Maybe fade to [to].
  void maybeFade({
    required final Duration? fadeTime,
    required final double to,
  }) {
    if (fadeTime != null) {
      volume.fade(to, fadeTime);
    } else {
      volume.value = to;
    }
  }

  /// The pan property.
  SoundHandleProperty<double> get pan => SoundHandleProperty(
        getValue: () => SoLoud.instance.getPan(this),
        setValue: (final value) => SoLoud.instance.setPan(this, value),
        fade: (final to, final time) => SoLoud.instance.fadePan(this, to, time),
        oscillate: (final from, final to, final time) =>
            SoLoud.instance.oscillatePan(
          this,
          from,
          to,
          time,
        ),
      );

  /// The relative play speed property.
  SoundHandleProperty<double> get relativePlaySpeed => SoundHandleProperty(
        getValue: () => SoLoud.instance.getRelativePlaySpeed(this),
        setValue: (final value) => SoLoud.instance.setRelativePlaySpeed(
          this,
          value,
        ),
        fade: (final to, final time) => SoLoud.instance.fadeRelativePlaySpeed(
          this,
          to,
          time,
        ),
        oscillate: (final from, final to, final time) =>
            SoLoud.instance.oscillateRelativePlaySpeed(
          this,
          from,
          to,
          time,
        ),
      );

  /// Pause this sound.
  ///
  /// If [time] is not `null`, then the pause will be scheduled for the future.
  void pause({final Duration? time}) {
    if (time == null) {
      SoLoud.instance.setPause(this, true);
    } else {
      schedulePause(time);
    }
  }

  /// Resume this sound.
  void unpause() => SoLoud.instance.setPause(this, false);

  /// Check if the handle to this sound is still valid.
  bool get isValid => SoLoud.instance.getIsValidVoiceHandle(this);

  /// Returns `true` if this sound is looping.
  bool get looping => SoLoud.instance.getLooping(this);

  /// Get the loop point for this sound.
  Duration get loopPoint => SoLoud.instance.getLoopPoint(this);

  /// Returns `true` if this sound is paused.
  bool get paused => SoLoud.instance.getPause(this);

  /// Get the current seek position of this sound.
  Duration get seek => SoLoud.instance.getPosition(this);

  /// Returns `true` if this sound is protected.
  bool get protectVoice => SoLoud.instance.getProtectVoice(this);

  /// Returns `true` if this is a valid voice group.
  bool get isVoiceGroup => SoLoud.instance.isVoiceGroup(this);

  /// Switch the [paused] state of this sound.
  void pauseSwitch() => SoLoud.instance.pauseSwitch(this);

  /// Schedule [pause] for this sound.
  void schedulePause(final Duration time) =>
      SoLoud.instance.schedulePause(this, time);

  /// Schedule [stop] for this sound.
  void scheduleStop(final Duration time) =>
      SoLoud.instance.scheduleStop(this, time);

  /// Seek to a new [position] in this sound.
  set seek(final Duration position) => SoLoud.instance.seek(this, position);

  /// Set 3d source attenuation for this sound.
  void setSourceAttenuation(
    final int attenuationModel,
    final double attenuationRolloffFactor,
  ) =>
      SoLoud.instance.set3dSourceAttenuation(
        this,
        attenuationModel,
        attenuationRolloffFactor,
      );

  /// Set the doppler factor for this sound.
  set dopplerFactor(final double dopplerFactor) =>
      SoLoud.instance.set3dSourceDopplerFactor(this, dopplerFactor);

  /// Set the minimum and maximum distance this source can be heard at.
  void setMinMaxDistance(final double minDistance, final double maxDistance) =>
      SoLoud.instance.set3dSourceMinMaxDistance(this, minDistance, maxDistance);

  /// Set the source parameters for this sound.
  void setSourceParameters(
    final double posX,
    final double posY,
    final double posZ,
    final double velocityX,
    final double velocityY,
    final double velocityZ,
  ) =>
      SoLoud.instance.set3dSourceParameters(
        this,
        posX,
        posY,
        posZ,
        velocityX,
        velocityY,
        velocityZ,
      );

  /// Set the source position of this sound.
  void setSourcePosition(
    final double posX,
    final double posY,
    final double posZ,
  ) =>
      SoLoud.instance.set3dSourcePosition(this, posX, posY, posZ);

  /// Set the source velocity for this sound.
  void setSourceVelocity(
    final double velocityX,
    final double velocityY,
    final double velocityZ,
  ) =>
      SoLoud.instance.set3dSourceVelocity(
        this,
        velocityX,
        velocityY,
        velocityZ,
      );

  /// Set [looping] for this sound.
  set looping(final bool enable) => SoLoud.instance.setLooping(this, enable);

  /// Set the [loopPoint] for this sound.
  set loopPoint(final Duration time) =>
      SoLoud.instance.setLoopPoint(this, time);

  /// Set the absolute pan of this sound.
  void setPanAbsolute(final double left, final double right) =>
      SoLoud.instance.setPanAbsolute(this, left, right);

  /// Set [paused] for this sound.
  set paused(final bool pause) => SoLoud.instance.setPause(this, pause);

  /// Set [protectVoice] for this sound.
  set protectVoice(final bool protect) =>
      SoLoud.instance.setProtectVoice(this, protect);

  /// Fade this handle to [fadeTo] over [fadeOutTime], run [f], then fade back
  /// up over [fadeInTime] to the original [volume].
  Future<T> runFaded<T>(
    final Future<T> Function() f, {
    final double fadeTo = 0.0,
    final Duration fadeOutTime = const Duration(seconds: 3),
    final Duration fadeInTime = const Duration(seconds: 3),
  }) async {
    final maxVolume = volume.value;
    volume.fade(fadeTo, fadeOutTime);
    final result = await f();
    volume.fade(maxVolume, fadeInTime);
    return result;
  }

  /// Set the inaudible behaviour for this sound handle.
  void setInaudibleBehaviour({
    final bool mustTick = false,
    final bool kill = false,
  }) =>
      SoLoud.instance.setInaudibleBehavior(this, mustTick, kill);
}
