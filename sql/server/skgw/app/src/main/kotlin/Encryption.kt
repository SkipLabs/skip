package io.skiplabs.skgw

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
