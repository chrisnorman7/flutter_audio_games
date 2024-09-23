import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../flutter_audio_games.dart';

/// Useful extensions on build contexts.
extension FlutterAudioGamesBuildContextExtension on BuildContext {
  /// Pause and resume a [Ticking] while pushing a widget [builder].
  ///
  /// This method is useful when implementing a pause menu for example.
  Future<void> pauseTickingBuilderAndPushWidget(
    final WidgetBuilder builder,
  ) async {
    Ticking.maybeOf(this)?.pause();
    await Navigator.of(this).push(MaterialPageRoute(builder: builder));
    Ticking.maybeOf(this)?.resume();
  }

  /// Pause and resume a [RandomTasks] while pushing a widget [builder].
  ///
  /// This method is useful when implementing a pause menu for example.
  Future<void> pauseRandomTaskBuilderAndPushWidget(
    final WidgetBuilder builder,
  ) async {
    RandomTasks.maybeOf(this)?.pause();
    await Navigator.of(this).push(MaterialPageRoute(builder: builder));
    RandomTasks.maybeOf(this)?.resume();
  }

  /// Push a widget [builder], fading any [Music] out and back in again.
  ///
  /// This method is useful when pushing a widget over a [AudioGameMenu] for
  /// example.
  ///
  /// If [restartMusic] is `true`, then the playback position will be reset
  /// before fading back in.
  Future<void> fadeMusicAndPushWidget(
    final WidgetBuilder builder, {
    final bool restartMusic = true,
  }) async {
    Music.maybeOf(this)?.fadeOut();
    await Navigator.push(
      this,
      MaterialPageRoute(
        builder: builder,
      ),
    );
    final inheritedMusic = Music.maybeOf(this);
    if (restartMusic) {
      inheritedMusic?.setPlaybackPosition(Duration.zero);
    }
    inheritedMusic?.fadeIn();
  }

  /// Stop a sound playing with this context.
  void stopPlaySoundSemantics() =>
      findAncestorStateOfType<PlaySoundSemanticsState>()?.stop();

  /// Get the so loud instance.
  SoLoud get soLoud => SoLoud.instance;

  /// Get a so loud scope state.
  SoLoudScopeState get soLoudScope => SoLoudScope.of(this);

  /// Get the source loader attached to this context.
  SourceLoader get sourceLoader => soLoudScope.sourceLoader;

  /// Play [sound].
  Future<SoundHandle> playSound(final Sound sound) async {
    final source = await sourceLoader.loadSound(sound);
    return playSoundSource(sound, source);
  }

  /// Play [sound] from [source].
  Future<SoundHandle> playSoundSource(
    final Sound sound,
    final AudioSource source,
  ) async {
    final SoundHandle handle;
    final position = sound.position;
    switch (position) {
      case SoundPositionPanned():
        handle = await soLoud.play(
          source,
          looping: sound.looping,
          loopingStartAt: sound.loopingStart,
          pan: position.pan,
          paused: sound.paused,
          volume: sound.volume,
        );
      case SoundPosition3d():
        handle = await soLoud.play3d(
          source,
          position.x,
          position.y,
          position.z,
          looping: sound.looping,
          loopingStartAt: sound.loopingStart,
          paused: sound.paused,
          volume: sound.volume,
          velX: position.velX,
          velY: position.velY,
          velZ: position.velZ,
        );
    }
    if (sound.destroy) {
      final length = soLoud.getLength(source);
      soLoud.scheduleStop(handle, length);
    } else {}
    return handle;
  }

  /// Play [sound] [buffer].
  Future<SoundHandle> playSoundBuffer(
    final Sound sound,
    final Uint8List buffer,
  ) async {
    final source = await sourceLoader.loadSoundBuffer(sound, buffer);
    return playSoundSource(sound, source);
  }

  /// Play [sound], if it is not `null`.
  ///
  /// If [sound] is `null`, `null` will be returned. Otherwise, a valid
  /// [SoundHandle] will be returned.
  Future<SoundHandle?> maybePlaySound(final Sound? sound) {
    if (sound == null) {
      return Future.value();
    }
    return playSound(sound);
  }

  /// Convert [text] to speech via [soLoud].
  Future<AudioSource> textToSpeech(final String text) =>
      soLoud.speechText(text);
}

/// Useful methods on generic points.
extension FlutterAudioGamesPointExtension<T extends num> on Point<T> {
  /// Return `true` if this point lies on a straight line between points [a] and
  /// [b].
  bool isOnLine(
    final Point<T> a,
    final Point<T> b,
  ) =>
      (distanceTo(b) + a.distanceTo(b)) == distanceTo(a);
}

/// Useful methods for points.
///
/// This extension is mostly copied from [Ziggurat](https://pub.dev/packages/ziggurat).
extension FlutterAudioGamesPointDoubleExtension on Point<double> {
  /// Return a floored version of this point. That is a point made up of
  /// [x] and [y], both floored with [double.floor].
  Point<int> floor() => Point<int>(x.floor(), y.floor());

  /// Return the angle between `this` and [other].
  ///
  /// This function provided by a good friend who wished to remain nameless.
  double angleBetween(final Point<double> other) {
    // Check if the points are on top of each other and output something
    // reasonable.
    if (x == other.x && y == other.y) {
      return 0.0;
    }
    // If y1 and y2 are the same, we'll end up dividing by 0, and that's bad.
    if (y == other.y) {
      if (other.x > x) {
        return 90.0;
      } else {
        return 270.0;
      }
    }
    final angle = atan2(other.x - x, other.y - y);
    // Convert result from radians to degrees. If you want minutes and seconds
    // as well it's tough.
    final degrees = angle * 180 / pi;
    // Ensure the angle is between 0 and 360.
    return normaliseAngle(degrees);
  }

  /// Return the coordinates that lie [distance] at [bearing] °.
  Point<double> pointInDirection(
    final double bearing,
    final double distance,
  ) {
    final rad = angleToRad(bearing);
    return Point<double>(x + (distance * sin(rad)), y + (distance * cos(rad)));
  }
}

/// Useful methods for points.
///
/// This extension is mostly copied from [Ziggurat](https://pub.dev/packages/ziggurat).
extension FlutterAudioGamesPointIntExtension on Point<int> {
  /// Return a version of this point with the points converted to doubles.
  Point<double> toDouble() => Point<double>(x.toDouble(), y.toDouble());
}

/// Useful extensions for lists.
extension FlutterAudioGamesListExtension<E> on List<E> {
  /// Return a random element.
  ///
  /// This uses [Random.nextInt] to get a random index.
  E randomElement(final Random random) => this[random.nextInt(length)];
}

/// Useful string methods.
extension FlutterAudioGamesStringExtension on String {
  /// Return a sound, using this string as the path.
  ///
  /// If you want to turn a [List] of [String]s into a [List] of [Sound]s, use
  /// the [FlutterAudioGamesListStringExtension.asSoundList] method.
  Sound asSound({
    required final bool destroy,
    required final SoundType soundType,
    final double volume = 0.7,
    final bool looping = false,
    final Duration loopingStart = Duration.zero,
    final SoundPosition position = unpanned,
    final bool paused = false,
    final LoadMode loadMode = LoadMode.memory,
  }) =>
      Sound(
        path: this,
        soundType: soundType,
        volume: volume,
        destroy: destroy,
        looping: looping,
        loopingStart: loopingStart,
        position: position,
        paused: paused,
        loadMode: loadMode,
      );
}

/// Useful methods on string lists.
extension FlutterAudioGamesListStringExtension on List<String> {
  /// Return a sound list.
  List<Sound> asSoundList({
    required final bool destroy,
    required final SoundType soundType,
    final double volume = 0.7,
    final bool looping = false,
    final Duration loopingStart = Duration.zero,
    final SoundPosition position = unpanned,
    final bool paused = false,
    final LoadMode loadMode = LoadMode.memory,
  }) =>
      map(
        (final path) => path.asSound(
          destroy: destroy,
          soundType: soundType,
          volume: volume,
          looping: looping,
          loopingStart: loopingStart,
          position: position,
          paused: paused,
          loadMode: loadMode,
        ),
      ).toList();
}

/// Useful methods on sound handles.
extension FlutterAudioGamesAudioHandleExtension on SoundHandle {
  /// Stop this handle.
  Future<void> stop({final Duration? fadeOutTime}) async {
    final soLoud = SoLoud.instance;
    if (fadeOutTime == null) {
      await soLoud.stop(this);
    } else {
      soLoud
        ..fadeVolume(this, 0.0, fadeOutTime)
        ..scheduleStop(this, fadeOutTime);
    }
  }

  /// Fade the volume of this sound.
  void fadeVolume(final double to, final Duration time) =>
      SoLoud.instance.fadeVolume(this, to, time);

  /// Maybe fade to [to].
  void maybeFade({
    required final Duration? fadeTime,
    required final double to,
  }) {
    if (fadeTime != null) {
      fadeVolume(to, fadeTime);
    } else {
      volume = to;
    }
  }

  /// Pause this sound.
  void pause() => SoLoud.instance.setPause(this, true);

  /// Resume this sound.
  void unpause() => SoLoud.instance.setPause(this, false);

  /// Fade the pan of this sound.
  void fadePan(final double to, final Duration time) =>
      SoLoud.instance.fadePan(this, to, time);

  /// Fade the relative speed of this sound.
  void fadeRelativePlaySpeed(final double to, final Duration time) =>
      SoLoud.instance.fadeRelativePlaySpeed(this, to, time);

  /// Check if the handle to this sound is still valid.
  bool get isValidVoiceHandle => SoLoud.instance.getIsValidVoiceHandle(this);

  /// Returns `true` if this sound is looping.
  bool get looping => SoLoud.instance.getLooping(this);

  /// Get the loop point for this sound.
  Duration get loopPoint => SoLoud.instance.getLoopPoint(this);

  /// Get the pan for this sound.
  double get pan => SoLoud.instance.getPan(this);

  /// Returns `true` if this sound is paused.
  bool get paused => SoLoud.instance.getPause(this);

  /// Get the current seek position of this sound.
  Duration get seek => SoLoud.instance.getPosition(this);

  /// Returns `true` if this sound is protected.
  bool get protectVoice => SoLoud.instance.getProtectVoice(this);

  /// Get the relative play speed of this sound.
  double get relativePlaySpeed => SoLoud.instance.getRelativePlaySpeed(this);

  /// Get the volume of this sound.
  double get volume => SoLoud.instance.getVolume(this);

  /// Returns `true` if this is a valid voice group.
  bool get isValidVoiceGroup => SoLoud.instance.isVoiceGroup(this);

  /// Returns `true` of this voice group is empty.
  bool get isVoiceGroupEmpty => SoLoud.instance.isVoiceGroupEmpty(this);

  /// Oscillate pan for this sound.
  void oscillatePan(final double from, final double to, final Duration time) =>
      SoLoud.instance.oscillatePan(this, from, to, time);

  /// Oscillate the relative play speed of this sound.
  void oscillateRelativePlaySpeed(
    final double from,
    final double to,
    final Duration time,
  ) =>
      SoLoud.instance.oscillateRelativePlaySpeed(this, from, to, time);

  /// Oscillate the volume of this sound.
  void oscillateVolume(
    final double from,
    final double to,
    final Duration time,
  ) =>
      SoLoud.instance.oscillateVolume(this, from, to, time);

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
      SoLoud.instance
          .set3dSourceVelocity(this, velocityX, velocityY, velocityZ);

  /// Set [looping] for this sound.
  set looping(final bool enable) => SoLoud.instance.setLooping(this, enable);

  /// Set the [loopPoint] for this sound.
  set loopPoint(final Duration time) =>
      SoLoud.instance.setLoopPoint(this, time);

  /// Set the [pan] of this sound.
  set pan(final double value) => SoLoud.instance.setPan(this, value);

  /// Set the absolute pan of this sound.
  void setPanAbsolute(final double left, final double right) =>
      SoLoud.instance.setPanAbsolute(this, left, right);

  /// Set [paused] for this sound.
  set paused(final bool pause) => SoLoud.instance.setPause(this, pause);

  /// Set [protectVoice] for this sound.
  set setProtectVoice(final bool protect) =>
      SoLoud.instance.setProtectVoice(this, protect);

  /// Set the [relativePlaySpeed] for this sound.
  set relativePlaySpeed(final double speed) =>
      SoLoud.instance.setRelativePlaySpeed(this, speed);

  /// Set the [volume] of this sound.
  set volume(final double volume) => SoLoud.instance.setVolume(this, volume);
}

/// Useful methods for sources.
extension FlutterAudioGamesAudioSourceExtension on AudioSource {
  /// Returns the number of concurrent sounds that are playing from this source.
  int get countSounds => SoLoud.instance.countAudioSource(this);

  /// Dispose of this source.
  Future<void> dispose() => SoLoud.instance.disposeSource(this);

  /// Get the length of this source.
  Duration get length => SoLoud.instance.getLength(this);

  /// Set the waveform for this source.
  set waveform(final WaveForm newWaveform) =>
      SoLoud.instance.setWaveform(this, newWaveform);

  /// Set the waveform detune for this sound.
  set waveformDetune(final double detune) =>
      SoLoud.instance.setWaveformDetune(this, detune);

  /// Set the waveform frequency.
  set waveformFreq(final double frequency) =>
      SoLoud.instance.setWaveformFreq(this, frequency);

  /// Set the waveform scale.
  set waveformScale(final double scale) =>
      SoLoud.instance.setWaveformScale(this, scale);

  /// Set whether this source represents a super wave.
  set superwave(final bool superwave) =>
      SoLoud.instance.setWaveformSuperWave(this, superwave);
}

/// Useful methods.
extension FlutterAudioGamesSoLoudExtension on SoLoud {
  /// Set the listener orientation from [angle].
  void set3dListenerOrientation(final double angle) {
    final rads = angleToRad(angle);
    final x = cos(rads);
    final y = sin(rads);
    const z = -1.0;
    set3dListenerAt(x, y, z);
  }
}

/// Useful methods to turn [File]s into [Sound]s.
extension FileX on File {
  /// Create a sound from `this` file.
  Sound asSound({
    required final bool destroy,
    final double volume = 0.7,
    final bool looping = false,
    final Duration loopingStart = Duration.zero,
    final SoundPosition position = unpanned,
    final bool paused = false,
    final LoadMode loadMode = LoadMode.memory,
  }) =>
      Sound(
        path: path,
        soundType: SoundType.file,
        destroy: destroy,
        loadMode: loadMode,
        looping: looping,
        loopingStart: loopingStart,
        paused: paused,
        position: position,
        volume: volume,
      );
}

/// Useful extensions to turn [Directory] instances into [Sound]s.
extension DirectoryX on Directory {
  /// Create a sound from a file in `this` directory.
  Sound asSound({
    required final Random random,
    required final bool destroy,
    final double volume = 0.7,
    final bool looping = false,
    final Duration loopingStart = Duration.zero,
    final SoundPosition position = unpanned,
    final bool paused = false,
    final LoadMode loadMode = LoadMode.memory,
  }) {
    final files = listSync().whereType<File>().toList();
    if (files.isEmpty) {
      throw StateError('Empty directory found at $path.');
    }
    final file = files.randomElement(random);
    return file.asSound(
      destroy: destroy,
      loadMode: loadMode,
      looping: looping,
      loopingStart: loopingStart,
      paused: paused,
      position: position,
      volume: volume,
    );
  }
}
