package com.dastream.ml_kem

import org.bouncycastle.jcajce.SecretKeyWithEncapsulation
import org.bouncycastle.jcajce.spec.KEMExtractSpec
import org.bouncycastle.jcajce.spec.KEMGenerateSpec
import org.bouncycastle.jcajce.spec.MLKEMParameterSpec
import org.bouncycastle.jce.provider.BouncyCastleProvider
import java.security.KeyFactory
import java.security.KeyPairGenerator
import java.security.SecureRandom
import java.security.spec.PKCS8EncodedKeySpec
import java.security.spec.X509EncodedKeySpec
import javax.crypto.KeyGenerator

class MLKemBridge {
    private val bcProvider = BouncyCastleProvider()

    fun generateKeyPair(): Map<String, ByteArray> {
        val keyPairGenerator = KeyPairGenerator.getInstance("ML-KEM", bcProvider)
        keyPairGenerator.initialize(MLKEMParameterSpec.ml_kem_768, SecureRandom())
        val keyPair = keyPairGenerator.generateKeyPair()

        return mapOf(
            "publicKey" to keyPair.public.encoded,
            "privateKey" to keyPair.private.encoded
        )
    }

    fun encapsulate(
        publicKeyBytes: ByteArray,
        algorithm: String,
        algorithmKeySize: Int
    ): Map<String, ByteArray> {
        val keyFactory = KeyFactory.getInstance("ML-KEM", bcProvider)
        val publicKeySpec = X509EncodedKeySpec(publicKeyBytes)
        val publicKey = keyFactory.generatePublic(publicKeySpec)

        val senderKeyGen = KeyGenerator.getInstance("ML-KEM", bcProvider)
        senderKeyGen.init(KEMGenerateSpec(publicKey, algorithm, algorithmKeySize), SecureRandom())

        val secretWithEnc = senderKeyGen.generateKey() as SecretKeyWithEncapsulation

        return mapOf(
            "sharedSecret" to secretWithEnc.encoded,
            "encapsulation" to secretWithEnc.encapsulation
        )
    }

    fun decapsulate(
        privateKeyBytes: ByteArray,
        encapsulationBytes: ByteArray,
        algorithm: String,
        algorithmKeySize: Int
    ): ByteArray {
        val keyFactory = KeyFactory.getInstance("ML-KEM", bcProvider)
        val privateKeySpec = PKCS8EncodedKeySpec(privateKeyBytes)
        val privateKey = keyFactory.generatePrivate(privateKeySpec)

        val receiverKeyGen = KeyGenerator.getInstance("ML-KEM", bcProvider)
        receiverKeyGen.init(
            KEMExtractSpec(
                privateKey,
                encapsulationBytes,
                algorithm,
                algorithmKeySize
            )
        )

        val secretWithEnc = receiverKeyGen.generateKey() as SecretKeyWithEncapsulation

        return secretWithEnc.encoded
    }
}