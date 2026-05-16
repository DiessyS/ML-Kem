import 'dart:typed_data';

class EncapsulatedData {
  final Uint8List sharedSecret;
  final Uint8List encapsulation;

  EncapsulatedData({required this.sharedSecret, required this.encapsulation});
}
