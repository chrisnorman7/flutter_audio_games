# Changes

## 0.37.3

- Updated `backstreets_widgets`.

## 0.37.2

- Added the `AmbiancesBuilder.fadeFrom` member to work around a bug in flutter_soloud.

## 0.37.1

- Upgraded `backstreets_widgets`.

## 0.37.0

- Upgraded `backstreets_widgets`.

## 0.36.0

- Enforce proper loading and error arguments for `AmbiancesBuilder`.

## 0.35.1

- Export the `ProtectSounds` widget.

## 0.35.0

- Fixed the `StartWebAudio` widget to not require the `buttonBuilder` argument.
- Updated `backstreets_widgets`.

## 0.34.0

- Added the `ProtectSounds` widget.
- Added the `LoadSounds` widget.

## 0.33.0

- Upgraded `backstreets_widgets`.
- Added the `StartWebAudio` widget.
- Removed scene-related widgets.
- Added simple 2d directions to instances of `Point<int>`.

## 0.32.1

- Upgraded `backstreets_widgets`.

## 0.32.0

- Updated `backstreets_widgets`.
- Added the `MaybePlaySoundSemantics` widget.
- Allow `SoLoud.init` to be configured.

## 0.31.0

- Added the `PlaySoundsSemantics` widget.
- Added the `GameCredits` screen.
- Added the `SelectPlaybackDevice` screen.
- Start using Web Audio style sound properties.
- Added the `SideScroller` widget.
- Added the `BuildContext.playRandomSound` extension method.
- Added the `TouchSurfaceBuilder` widget.
- Added the `VoiceGroup` class.
- Removed text styles.
- Updated `backstreets_widgets`.
- Don't cache custom sounds.

## 0.30.0

- Allow loading sounds from buffers.
- Updated `backstreets_widgets`.

## 0.29.1

- Removed unused argument to `Directory.asSound`.

## 0.29.0

- Fixed a spelling mistake.
- Added extension methods to files and directories to create sounds from them.
- Exposed `SourceLoader` logger.

## 0.28.0

- Allow copying a sound with a new path.

## 0.27.0

- Allow modifying the sound type of a copied sound.

## 0.26.0

- Give `loadCustomSound` access to the calling `SourceLoader`.

## 0.25.0

- Upgraded dependencies so games should work on the web.
- Allow custom sound sources.
- Add more methods from So Loud.
- Stop pretending we can ever have more than 1 instance of `SoLoud`.

## 0.24.0

- Make touch menus more usable.
- Add custom accessibility actions to touch menus.
- Add the `SourceLoader.disposeSound` method.
- Stop automatically disposing of sounds.
- Allow load mode to be set on a per-sound basis.
- Add extension methods to allow calling soloud methods on `AudioSource`s and `SoundHandle`s.
- Allow setting the text style for `Text`s used throughout the package.
- Removed the unused `SoundType.tts` member.
- Added logging to `SourceLoader`.

## 0.23.2

- Fix `TouchSurface` coordinates.

## 0.23.1

- Fixed a bug with touch surfaces.

## 0.23.0

- Use proper text for `TouchSurface` widgets.
- Allow multiple touches in a `TouchSurface`.
- Add the `TouchArea` widget.
- Add keyboard shortcuts to `TouchMenu` widgets.
- Allow keyboard shortcuts in `TouchSurface` widgets.

## 0.22.0

- Many bug fixes.

## 0.21.0

- Improvements to `SourceLoader`.
- Add touch-friendly widgets.

## 0.20.0

- Added `velX`, `velY`, and `velZ` properties to `SoundPosition3d`.

## 0.19.0

- Moved widgets to [backstreets_widgets](https://pub.dev/packages/backstreets_widgets).

## 0.18.0

- Updated `backstreets_widgets`.

## 0.17.0

- Added the `stopPlaySoundSemantics` extension method.

## 0.16.1

- Updated `backstreets_widgets`.

## 0.16.0

- Added the `SceneBuilder` widget.

## 0.15.0

- Use sounds instead of assets paths in `GainListTile`.

## 0.14.0

- Start using `PhysicalKeyboardKey`s for `GameShortcut` instances.

## 0.13.2

- Don't look up deactivated widgets.

## 0.13.1

- Stop the `PlaySoundSemantics` widget when `dispose`d.

## 0.13.0

- Updated `flutter_synthizer`.

## 0.12.0

- Added the `Sound` and `SoundList` classes.
- Added the `asSound` extension method to `String` instances.
- Added the `asSoundList` extension method to `List<String>` instances.

## 0.11.0

- Added the `isOnLine` method for `Point` instances.

## 0.10.1

- Stop music lingering when the widget is rebuilt.

## 0.10.0

- Updated `flutter_synthizer`.
- Set `linger` properly for `music` widgets.

## 0.9.1

- Fixed a bug which meant `Music` widgets weren't rebuilt.

## 0.9.0

- Added the `MaybeMusic` widget.
- Added the `ShortcutsHelpScreen` widget.`

## 0.8.0

- Updated the docs.

## 0.7.1

- Use `backstreets_widgets` widgets more often.
- Code clean-up.
- Added the `GainListTile` widget.
- Added the `TransitionSoundBuilder` widget.

## 0.7.0

- Added the `GainMixin.maybeFade` extension method.
- Added the `Ambiances` widget.
- Started using the [backstreets_widgets](https://pub.dev/packages/backstreets_widgets) package.
- Added the `TimedTransitions` widget.

## 0.6.2

- Updated `flutter_synthizer`.

## 0.6.1

- Fixed the type of `ReverbBuilder.builder`.

## 0.6.0

- Added the `ReverbBuilder` widget.

## 0.5.0

- Added the `CutScene` widget.
- Added the `PlaySound` widget.
- Cleaned up the source tree.

## 0.4.0

- Added earcons to audio game menu items.

## 0.3.0

- Updated `flutter_synthizer`.

## 0.2.0

- Updated `flutter_synthizer`.

## 0.1.0

- Added a `context` argument to `GameShortcut`s.
- Use an `InheritedGameShortcuts` widget to make `GameShortcuts` accessible to builders.

## 0.0.1

- Initial release.
