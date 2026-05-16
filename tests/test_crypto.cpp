#include <gtest/gtest.h>
#include <sodium.h>
#include <string>
#include <vector>

// Fixture to ensure LibSodium is initialized before any crypto test runs
class CryptoTest : public ::testing::Test {
protected:
    void SetUp() override {
        // sodium_init() returns -1 on critical failure, 0 on success, 1 if already initialized
        ASSERT_GE(sodium_init(), 0) << "FATAL: libsodium failed to initialize.";
    }
};

TEST_F(CryptoTest, SymmetricEncryptionRoundTrip) {
    const std::string plaintext = "zero_knowledge_test_payload_01";

    // 1. SECURE ALLOCATION
    // Keys must live in pinned, non-pageable memory.
    unsigned char* key = static_cast<unsigned char*>(sodium_malloc(crypto_secretbox_KEYBYTES));
    ASSERT_NE(key, nullptr) << "Memory allocation for crypto key failed.";
    crypto_secretbox_keygen(key);

    // 2. NONCE GENERATION
    std::vector<unsigned char> nonce(crypto_secretbox_NONCEBYTES);
    randombytes_buf(nonce.data(), nonce.size());

    // 3. ENCRYPTION
    // Ciphertext size requires room for the MAC
    std::vector<unsigned char> ciphertext(plaintext.length() + crypto_secretbox_MACBYTES);
    int encrypt_status = crypto_secretbox_easy(
        ciphertext.data(),
        reinterpret_cast<const unsigned char*>(plaintext.data()),
        plaintext.length(),
        nonce.data(),
        key
        );
    ASSERT_EQ(encrypt_status, 0) << "Encryption process failed.";

    // 4. DECRYPTION
    std::vector<unsigned char> decryptedtext(plaintext.length());
    int decrypt_status = crypto_secretbox_open_easy(
        decryptedtext.data(),
        ciphertext.data(),
        ciphertext.size(),
        nonce.data(),
        key
        );

    // If this fails, either the ciphertext was tampered with or you messed up the pointers
    ASSERT_EQ(decrypt_status, 0) << "Decryption rejected: MAC validation failed or data corrupted.";

    std::string result(reinterpret_cast<char*>(decryptedtext.data()), decryptedtext.size());
    EXPECT_EQ(plaintext, result) << "Decrypted payload does not match original plaintext.";

    // 5. SECURE CLEANUP
    // If you forget this in your actual wrapper, you leak the master key. Do not forget it.
    sodium_free(key);
}
