import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ml_kem/domain/encapsulated_data.dart';
import 'package:ml_kem/domain/key_pair.dart';
import 'package:ml_kem/enum/target_encryption_algorithm.dart';
import 'package:ml_kem/exception/decapsulation_exception.dart';
import 'package:ml_kem/exception/encapsulation_exception.dart';
import 'package:ml_kem/exception/generate_key_pair_exception.dart';

import 'ml_kem_platform_interface.dart';

/// An implementation of [MlKemPlatform] that uses method channels.
class MethodChannelMlKem extends MlKemPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ml_kem');

  @override
  Future<KeyPair> generateKeyPair() async {
    final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
      'generateKeyPair',
    );
    if (result == null) {
      throw GenerateKeyPairException('Failed to generate ML-KEM key pair');
    }

    return KeyPair(
      publicKey: result['publicKey'] as Uint8List,
      privateKey: result['privateKey'] as Uint8List,
    );
  }

  @override
  Future<EncapsulatedData> encapsulate(
    Uint8List publicKey, {
    TargetEncryptionAlgorithm targetEncryptionAlgorithm =
        TargetEncryptionAlgorithm.chacha20,
  }) async {
    final result = await methodChannel
        .invokeMethod<Map<dynamic, dynamic>>('encapsulate', {
          'publicKey': publicKey,
          'algorithm': targetEncryptionAlgorithm.name,
          'algorithmKeySize': targetEncryptionAlgorithm.keySize,
        });
    if (result == null) {
      throw EncapsulationException('Failed to encapsulate secret');
    }

    return EncapsulatedData(
      sharedSecret: result['sharedSecret'] as Uint8List,
      encapsulation: result['encapsulation'] as Uint8List,
    );
  }

  @override
  Future<Uint8List> decapsulate({
    required Uint8List privateKey,
    required Uint8List encapsulation,
    TargetEncryptionAlgorithm targetEncryptionAlgorithm =
        TargetEncryptionAlgorithm.chacha20,
  }) async {
    final result = await methodChannel.invokeMethod<Uint8List>('decapsulate', {
      'privateKey': privateKey,
      'encapsulation': encapsulation,
      'algorithm': targetEncryptionAlgorithm.name,
      'algorithmKeySize': targetEncryptionAlgorithm.keySize,
    });
    if (result == null) {
      throw DecapsulationException('Failed to decapsulate secret');
    }

    return result;
  }
}
