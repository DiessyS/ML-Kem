enum TargetEncryptionAlgorithm {
  aes_128("AES", 128),
  aes_192("AES", 192),
  aes_256("AES", 256),
  chacha20("ChaCha20", 256);

  final String algorithm;
  final int keySize;

  const TargetEncryptionAlgorithm(this.algorithm, this.keySize);
}
