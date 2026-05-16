class GenerateKeyPairException implements Exception {
  final String message;

  GenerateKeyPairException(this.message);

  @override
  String toString() => 'GenerateKeyPairException: $message';
}
