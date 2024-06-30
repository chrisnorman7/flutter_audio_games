// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$randomHash() => r'231c5210df9a2af2107477f5a65d881c9abb5a25';

/// The random number provider.
///
/// Copied from [random].
@ProviderFor(random)
final randomProvider = AutoDisposeProvider<Random>.internal(
  random,
  name: r'randomProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$randomHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RandomRef = AutoDisposeProviderRef<Random>;
String _$loadedSoundHash() => r'96c7ba0d7094429ac58b3a814deb700556a8deea';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provide an asset from a sound.
///
/// Copied from [loadedSound].
@ProviderFor(loadedSound)
const loadedSoundProvider = LoadedSoundFamily();

/// Provide an asset from a sound.
///
/// Copied from [loadedSound].
class LoadedSoundFamily extends Family<AsyncValue<LoadedSound>> {
  /// Provide an asset from a sound.
  ///
  /// Copied from [loadedSound].
  const LoadedSoundFamily();

  /// Provide an asset from a sound.
  ///
  /// Copied from [loadedSound].
  LoadedSoundProvider call(
    Sound sound,
  ) {
    return LoadedSoundProvider(
      sound,
    );
  }

  @override
  LoadedSoundProvider getProviderOverride(
    covariant LoadedSoundProvider provider,
  ) {
    return call(
      provider.sound,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'loadedSoundProvider';
}

/// Provide an asset from a sound.
///
/// Copied from [loadedSound].
class LoadedSoundProvider extends FutureProvider<LoadedSound> {
  /// Provide an asset from a sound.
  ///
  /// Copied from [loadedSound].
  LoadedSoundProvider(
    Sound sound,
  ) : this._internal(
          (ref) => loadedSound(
            ref as LoadedSoundRef,
            sound,
          ),
          from: loadedSoundProvider,
          name: r'loadedSoundProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$loadedSoundHash,
          dependencies: LoadedSoundFamily._dependencies,
          allTransitiveDependencies:
              LoadedSoundFamily._allTransitiveDependencies,
          sound: sound,
        );

  LoadedSoundProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sound,
  }) : super.internal();

  final Sound sound;

  @override
  Override overrideWith(
    FutureOr<LoadedSound> Function(LoadedSoundRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LoadedSoundProvider._internal(
        (ref) => create(ref as LoadedSoundRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sound: sound,
      ),
    );
  }

  @override
  FutureProviderElement<LoadedSound> createElement() {
    return _LoadedSoundProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadedSoundProvider && other.sound == sound;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sound.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LoadedSoundRef on FutureProviderRef<LoadedSound> {
  /// The parameter `sound` of this provider.
  Sound get sound;
}

class _LoadedSoundProviderElement extends FutureProviderElement<LoadedSound>
    with LoadedSoundRef {
  _LoadedSoundProviderElement(super.provider);

  @override
  Sound get sound => (origin as LoadedSoundProvider).sound;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
