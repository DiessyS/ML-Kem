import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ml_kem/ml_kem_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMlKem platform = MethodChannelMlKem();
  const MethodChannel channel = MethodChannel('ml_kem');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'generateKeyPair':
              return {
                'publicKey': Uint8List.fromList([99]),
                'privateKey': Uint8List.fromList([88]),
              };
            case 'encapsulate':
              expect(methodCall.arguments['publicKey'], isNotNull);
              return {
                'sharedSecret': Uint8List.fromList([77]),
                'encapsulation': Uint8List.fromList([66]),
              };
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('generateKeyPair correctly parses MethodChannel response', () async {
    final result = await platform.generateKeyPair();
    expect(result.publicKey, [99]);
    expect(result.privateKey, [88]);
  });

  test('encapsulate sends args and parses MethodChannel response', () async {
    final dummyKey = Uint8List.fromList([11]);
    final result = await platform.encapsulate(dummyKey);

    expect(result.sharedSecret, [77]);
  });
}
