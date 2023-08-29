package io.skiplabs.skgw

import software.amazon.awssdk.auth.credentials.InstanceProfileCredentialsProvider
import software.amazon.awssdk.auth.credentials.ProfileCredentialsProvider
import software.amazon.awssdk.core.SdkBytes
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.kms.KmsClient
import software.amazon.awssdk.services.kms.model.DecryptRequest
import software.amazon.awssdk.services.kms.model.EncryptRequest

// simple synchronous symmetric encryption interface
interface EncryptionTransform {
  fun encrypt(input: ByteArray): ByteArray
  fun decrypt(input: ByteArray): ByteArray
}

class NoEncryptionTransform() : EncryptionTransform {
  override fun encrypt(input: ByteArray): ByteArray {
    return input
  }

  override fun decrypt(input: ByteArray): ByteArray {
    return input
  }
}

class KmsEncryptionTransform(val kmsClient: KmsClient, val keyId: String) : EncryptionTransform {
  override fun encrypt(input: ByteArray): ByteArray {
    val bytes = SdkBytes.fromByteArray(input)
    val encReq = EncryptRequest.builder().keyId(keyId).plaintext(bytes).build()
    val encResp = kmsClient.encrypt(encReq)
    return encResp.ciphertextBlob().asByteArray()
  }

  override fun decrypt(input: ByteArray): ByteArray {
    val bytes = SdkBytes.fromByteArray(input)
    val decryptReq = DecryptRequest.builder().ciphertextBlob(bytes).keyId(keyId).build()
    var decryptResp = kmsClient.decrypt(decryptReq)
    return decryptResp.plaintext().asByteArray()
  }
}

fun testKmsEncryptionTransform(): EncryptionTransform {
  val keyId = "2a7137c0-9a68-40f2-804d-450ce18a2dde"
  val provider = ProfileCredentialsProvider.create()
  val kmsClient = KmsClient.builder().region(Region.US_EAST_1).credentialsProvider(provider).build()
  return KmsEncryptionTransform(kmsClient, keyId)
}

fun ec2KmsEncryptionTransform(): EncryptionTransform {
  val keyId = "3bb24624-a84b-4a2d-91f1-cb93f04eea7d"
  val provider = InstanceProfileCredentialsProvider.builder().build()
  val kmsClient = KmsClient.builder().region(Region.US_EAST_1).credentialsProvider(provider).build()
  return KmsEncryptionTransform(kmsClient, keyId)
}
