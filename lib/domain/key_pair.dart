import 'dart:typed_data';

class KeyPair {
  final Uint8List publicKey;
  final Uint8List privateKey;

  KeyPair({required this.publicKey, required this.privateKey});
}
