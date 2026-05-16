package com.dastream.ml_kem

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class MlKemPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    private val bridge = MLKemBridge()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ml_kem")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        try {
            when (call.method) {
                "generateKeyPair" -> {
                    val keyPair = bridge.generateKeyPair()
                    result.success(keyPair)
                }

                "encapsulate" -> {
                    val publicKey = call.argument<ByteArray>("publicKey")
                    val algorithm = call.argument<String>("algorithm")
                    val algorithmKeySize = call.argument<Int>("algorithmKeySize")
                    if (publicKey != null && algorithm != null && algorithmKeySize != null) {
                        val encapsulated =
                            bridge.encapsulate(publicKey, algorithm, algorithmKeySize)
                        result.success(encapsulated)
                    } else {
                        result.error("INVALID_ARGUMENT", "publicKey is required", null)
                    }
                }

                "decapsulate" -> {
                    val privateKey = call.argument<ByteArray>("privateKey")
                    val encapsulation = call.argument<ByteArray>("encapsulation")
                    val algorithm = call.argument<String>("algorithm")
                    val algorithmKeySize = call.argument<Int>("algorithmKeySize")
                    if (privateKey != null && encapsulation != null && algorithm != null && algorithmKeySize != null) {
                        val secret = bridge.decapsulate(
                            privateKey,
                            encapsulation,
                            algorithm,
                            algorithmKeySize
                        )
                        result.success(secret)
                    } else {
                        result.error(
                            "INVALID_ARGUMENT",
                            "privateKey and encapsulation are required",
                            null
                        )
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        } catch (e: Exception) {
            result.error("ML_KEM_ERROR", e.message, e.stackTraceToString())
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}