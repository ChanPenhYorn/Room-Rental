// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectivityHash() => r'f18900083489763ed4066a1c33ea0447ca0093fc';

/// See also [connectivity].
@ProviderFor(connectivity)
final connectivityProvider =
    AutoDisposeStreamProvider<List<ConnectivityResult>>.internal(
      connectivity,
      name: r'connectivityProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$connectivityHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConnectivityRef =
    AutoDisposeStreamProviderRef<List<ConnectivityResult>>;
String _$networkControllerHash() => r'fc3110c53044c50d094f813d66723e4428472c9b';

/// See also [NetworkController].
@ProviderFor(NetworkController)
final networkControllerProvider =
    AutoDisposeNotifierProvider<NetworkController, AsyncValue<void>>.internal(
      NetworkController.new,
      name: r'networkControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$networkControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NetworkController = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
