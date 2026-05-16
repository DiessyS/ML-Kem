class EncapsulationException implements Exception {
  final String message;

  EncapsulationException(this.message);

  @override
  String toString() => 'EncapsulationException: $message';
}
