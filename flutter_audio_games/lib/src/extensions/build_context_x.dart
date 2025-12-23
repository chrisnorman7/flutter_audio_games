import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// The type of a function which will affect a source when it is loaded.
typedef OnSourceLoad = FutureOr<void> Function(AudioSource source);

/// Useful extensions on build contexts.
extension BuildContextX on BuildContext {
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
    await Navigator.push(this, MaterialPageRoute<void>(builder: builder));
    final inheritedMusic = Music.maybeOf(this);
    if (restartMusic) {
      inheritedMusic?.setPlaybackPosition(Duration.zero);
    }
    inheritedMusic?.fadeIn();
  }

  /// Get the so loud instance.
  SoLoud get soLoud => SoLoud.instance;

  /// Get a so loud scope state.
  SoLoudScopeProvider get soLoudScope => SoLoudScope.of(this);

  /// Get the source loader attached to this context.
  SourceLoader get sourceLoader => soLoudScope.sourceLoader;

  /// Play a random sound from [soundList].
  ///
  /// If [onSourceLoad] is not `null`, it will be called with the result of
  /// loading the random sound from the [sourceLoader].
  Future<SoundHandle> playRandomSound(
    final List<Sound> soundList, {
    final OnSourceLoad? onSourceLoad,
  }) {
    final sound = soundList.randomElement();
    return playSound(sound, onSourceLoad: onSourceLoad);
  }

  /// Play [sound].
  ///
  /// If [onSourceLoad] is not `null`, it will be called with the result of
  /// loading [sound] from the [sourceLoader].
  Future<SoundHandle> playSound(
    final Sound sound, {
    final OnSourceLoad? onSourceLoad,
  }) async {
    final source = await sourceLoader.loadSound(sound);
    await onSourceLoad?.call(source);
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
        handle =
            await soLoud.play3d(
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
              )
              ..setMinMaxDistance(position.minDistance, position.maxDistance);
        handle.setInaudibleBehaviour(
          mustTick: position.tickWhenInaudible,
          kill: position.killWhenInaudible,
        );
    }
    handle.relativePlaySpeed.value = sound.relativePlaySpeed;
    if (sound.destroy) {
      final length = source.length;
      handle.scheduleStop(length);
    }
    return handle;
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
