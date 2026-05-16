class DecapsulationException implements Exception {
  final String message;

  DecapsulationException(this.message);

  @override
  String toString() => 'DecapsulationException: $message';
}
