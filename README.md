# ML-KEM Flutter (Bouncy Castle Wrapper)

This plugin provides a Flutter wrapper for ML-KEM (FIPS 203), leveraging Bouncy Castle to bring post-quantum secure key encapsulation to Flutter (android only).

## Getting Started

```dart
    import 'package:ml_kem/ml_kem.dart';
    
    final _mlKem = MlKem();
    
    // 1. Generate keys (Receiver)
    final keys = await _mlKem.generateKeyPair();
    final publicKey = keys['publicKey'];
    final privateKey = keys['privateKey'];
    
    // 2. Create secret (Sender)
    final res = await _mlKem.encapsulate(publicKey);
    final secretSender = res['sharedSecret'];
    final ciphertext = res['encapsulation'];
    
    // 3. Recover secret (Receiver)
    final secretReceiver = await _mlKem.decapsulate(
        privateKey: privateKey,
        encapsulation: ciphertext,
    );
    
    // secretSender == secretReceiver
```

