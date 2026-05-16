import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ml_kem/ml_kem.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ML-KEM End-to-End Cryptography Flow', (
    WidgetTester tester,
  ) async {
    final plugin = MlKem();

    final keys = await plugin.generateKeyPair();

    final publicKey = keys.publicKey;
    final privateKey = keys.privateKey;

    expect(publicKey.isNotEmpty, isTrue);
    expect(privateKey.isNotEmpty, isTrue);

    final encapsulationData = await plugin.encapsulate(publicKey);

    final senderSharedSecret = encapsulationData.sharedSecret;
    final encapsulationPayload = encapsulationData.encapsulation;

    expect(senderSharedSecret.length, equals(32));
    expect(encapsulationPayload.isNotEmpty, isTrue);

    final receiverSharedSecret = await plugin.decapsulate(
      privateKey: privateKey,
      encapsulation: encapsulationPayload,
    );

    expect(receiverSharedSecret, equals(senderSharedSecret));
  });
}
