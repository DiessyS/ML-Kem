import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ml_kem/ml_kem.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _mlKemPlugin = MlKem();

  Uint8List? _publicKey;
  Uint8List? _privateKey;
  Uint8List? _encapsulation;
  Uint8List? _sharedSecretSender;
  Uint8List? _sharedSecretReceiver;
  String _status = 'Ready';

  // Helper to display bytes as hex
  String _toHex(Uint8List? bytes) {
    if (bytes == null) return 'null';
    return '${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join().substring(0, 32)}...';
  }

  Future<void> _runGenerate() async {
    try {
      final keys = await _mlKemPlugin.generateKeyPair();
      setState(() {
        _publicKey = keys.publicKey;
        _privateKey = keys.privateKey;
        _status = 'Key Pair Generated';
      });
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  Future<void> _runEncapsulate() async {
    if (_publicKey == null) return;
    try {
      final result = await _mlKemPlugin.encapsulate(_publicKey!);
      setState(() {
        _sharedSecretSender = result.sharedSecret;
        _encapsulation = result.encapsulation;
        _status = 'Secret Encapsulated';
      });
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  Future<void> _runDecapsulate() async {
    if (_privateKey == null || _encapsulation == null) return;
    try {
      final secret = await _mlKemPlugin.decapsulate(
        privateKey: _privateKey!,
        encapsulation: _encapsulation!,
      );
      setState(() {
        _sharedSecretReceiver = secret;
        _status = 'Secret Decapsulated';
      });
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final match =
        _sharedSecretSender != null &&
        _sharedSecretReceiver != null &&
        _sharedSecretSender.toString() == _sharedSecretReceiver.toString();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ML-KEM Plugin Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Status: $_status',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ElevatedButton(
                onPressed: _runGenerate,
                child: const Text('1. Generate Key Pair'),
              ),
              Text('Public Key: ${_toHex(_publicKey)}'),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _publicKey == null ? null : _runEncapsulate,
                child: const Text('2. Encapsulate Secret (Sender)'),
              ),
              Text('Sender Secret: ${_toHex(_sharedSecretSender)}'),
              Text('Encapsulation: ${_toHex(_encapsulation)}'),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _encapsulation == null ? null : _runDecapsulate,
                child: const Text('3. Decapsulate Secret (Receiver)'),
              ),
              Text('Receiver Secret: ${_toHex(_sharedSecretReceiver)}'),
              const SizedBox(height: 24),

              if (_sharedSecretSender != null && _sharedSecretReceiver != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: match ? Colors.green.shade100 : Colors.red.shade100,
                  child: Text(
                    match
                        ? 'SUCCESS: Secrets Match!'
                        : 'FAILURE: Secrets differ!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: match
                          ? Colors.green.shade900
                          : Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
