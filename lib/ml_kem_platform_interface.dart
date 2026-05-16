import 'dart:typed_data';
import 'package:ml_kem/domain/encapsulated_data.dart';
import 'package:ml_kem/domain/key_pair.dart';
import 'package:ml_kem/enum/target_encryption_algorithm.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ml_kem_method_channel.dart';

abstract class MlKemPlatform extends PlatformInterface {
  /// Constructs a MlKemPlatform.
  MlKemPlatform() : super(token: _token);

  static final Object _token = Object();

  static MlKemPlatform _instance = MethodChannelMlKem();

  /// The default instance of [MlKemPlatform] to use.
  /// Defaults to [MethodChannelMlKem].
  static MlKemPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MlKemPlatform] when
  /// they register themselves.
  static set instance(MlKemPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<KeyPair> generateKeyPair() {
    throw UnimplementedError('generateKeyPair() has not been implemented.');
  }

  Future<EncapsulatedData> encapsulate(
    Uint8List publicKey, {
    TargetEncryptionAlgorithm targetEncryptionAlgorithm =
        TargetEncryptionAlgorithm.chacha20,
  }) {
    throw UnimplementedError('encapsulate() has not been implemented.');
  }

  Future<Uint8List> decapsulate({
    required Uint8List privateKey,
    required Uint8List encapsulation,
    TargetEncryptionAlgorithm targetEncryptionAlgorithm =
        TargetEncryptionAlgorithm.chacha20,
  }) {
    throw UnimplementedError('decapsulate() has not been implemented.');
  }
}
