import 'dart:typed_data';
import 'package:ml_kem/domain/encapsulated_data.dart';
import 'package:ml_kem/domain/key_pair.dart';
import 'package:ml_kem/enum/target_encryption_algorithm.dart';

import 'ml_kem_platform_interface.dart';

class MlKem {
  Future<KeyPair> generateKeyPair() {
    return MlKemPlatform.instance.generateKeyPair();
  }

  Future<EncapsulatedData> encapsulate(
    Uint8List publicKey, {
    TargetEncryptionAlgorithm targetEncryptionAlgorithm =
        TargetEncryptionAlgorithm.chacha20,
  }) {
    return MlKemPlatform.instance.encapsulate(
      publicKey,
      targetEncryptionAlgorithm: targetEncryptionAlgorithm,
    );
  }

  Future<Uint8List> decapsulate({
    required Uint8List privateKey,
    required Uint8List encapsulation,
    TargetEncryptionAlgorithm targetEncryptionAlgorithm =
        TargetEncryptionAlgorithm.chacha20,
  }) {
    return MlKemPlatform.instance.decapsulate(
      privateKey: privateKey,
      encapsulation: encapsulation,
      targetEncryptionAlgorithm: targetEncryptionAlgorithm,
    );
  }
}
