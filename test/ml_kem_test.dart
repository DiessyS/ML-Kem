import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:ml_kem/domain/encapsulated_data.dart';
import 'package:ml_kem/domain/key_pair.dart';
import 'package:ml_kem/enum/target_encryption_algorithm.dart';
import 'package:ml_kem/ml_kem.dart';
import 'package:ml_kem/ml_kem_platform_interface.dart';
import 'package:ml_kem/ml_kem_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMlKemPlatform extends MlKemPlatform with MockPlatformInterfaceMixin {
  @override
  Future<KeyPair> generateKeyPair() async {
    return KeyPair(
      publicKey: Uint8List.fromList([1, 2, 3]),
      privateKey: Uint8List.fromList([4, 5, 6]),
    );
  }

  @override
  Future<EncapsulatedData> encapsulate(
    Uint8List publicKey, {
    TargetEncryptionAlgorithm targetEncryptionAlgorithm =
        TargetEncryptionAlgorithm.chacha20,
  }) async {
    return EncapsulatedData(
      sharedSecret: Uint8List.fromList([7, 8, 9]),
      encapsulation: Uint8List.fromList([10, 11, 12]),
    );
  }

  @override
  Future<Uint8List> decapsulate({
    required Uint8List privateKey,
    required Uint8List encapsulation,
    TargetEncryptionAlgorithm targetEncryptionAlgorithm =
        TargetEncryptionAlgorithm.chacha20,
  }) async {
    return Uint8List.fromList([7, 8, 9]);
  }
}

void main() {
  final MlKemPlatform initialPlatform = MlKemPlatform.instance;

  test('$MethodChannelMlKem is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMlKem>());
  });

  group('MlKem Main Class Tests', () {
    late MlKem mlKemPlugin;
    late MockMlKemPlatform mockPlatform;

    setUp(() {
      mlKemPlugin = MlKem();
      mockPlatform = MockMlKemPlatform();
      MlKemPlatform.instance = mockPlatform;
    });

    test('generateKeyPair returns correct data from platform', () async {
      final result = await mlKemPlugin.generateKeyPair();
      expect(result.publicKey, [1, 2, 3]);
      expect(result.privateKey, [4, 5, 6]);
    });

    test('encapsulate returns correct data from platform', () async {
      final dummyKey = Uint8List.fromList([1, 2, 3]);
      final result = await mlKemPlugin.encapsulate(dummyKey);

      expect(result.sharedSecret, [7, 8, 9]);
      expect(result.encapsulation, [10, 11, 12]);
    });
  });
}
