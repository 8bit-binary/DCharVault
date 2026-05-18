#include<gtest/gtest.h>
#include<QString>
#include<QByteArray>
#include"model/EncryptionManager.h"
#include"model/SecureAllocator.h"

class EncryptionManagerTest : public ::testing::Test{
protected:
    EncryptionManager encManager;
    void SetUp() override{
        ASSERT_TRUE(encManager.initialize())<<"EncryptionManager failed to initialize Libsodium.";
    }
};

TEST_F(EncryptionManagerTest, EncryptDecryptRoundTrip)
{
    const QString originalText = "Zero_Knowledge_Vault_Payload_2026";
    const char* rawPwd = "StrongTestPassword123!";
    const SecureString dummyPassword(rawPwd,rawPwd+std::strlen(rawPwd));

    const QByteArray salt = encManager.generateSalt();
    ASSERT_FALSE(salt.isEmpty())<<"Salt generation failed. Returned empty array.";

    const SecureVector masterKey = encManager.deriveMasterKey(dummyPassword,salt);
    ASSERT_FALSE(masterKey.empty())<<"Argon2id Key derivation failed.";

    const QByteArray encryptedData = encManager.encryptString(originalText,masterKey);
    ASSERT_FALSE(encryptedData.isEmpty())<< "Encryption returned empty data.";

    ASSERT_NE(encryptedData, originalText.toUtf8()) << "FATAL: Encrypted data matches plaintext!";

    const QString resultText = encManager.decryptString(encryptedData,masterKey);
    ASSERT_FALSE(resultText.isEmpty())<< "Decryption rejected: MAC validation failed or data corrupted.";

    EXPECT_EQ(originalText, resultText) << "Decrypted text does not match the original input.";
}

TEST_F(EncryptionManagerTest, DecryptionFailsOnCorruptedData) {
    const QString originalText = "Sensitive_Data_Do_Not_Leak";

    const char* rawPwd = "StrongTestPassword123!";
    SecureString dummyPassword(rawPwd, rawPwd + std::strlen(rawPwd));

    QByteArray salt = encManager.generateSalt();
    SecureVector masterKey = encManager.deriveMasterKey(dummyPassword, salt);

    QByteArray encryptedData = encManager.encryptString(originalText, masterKey);
    ASSERT_FALSE(encryptedData.isEmpty());

    // Attack Case: Flip single bit in the ciphertext to simulate tampering or disk corruption
    encryptedData[0] = encryptedData[0] ^ 0x01;

    // Defensive Pact: Decryption must reject the tampered payload
    QString resultText = encManager.decryptString(encryptedData, masterKey);

    EXPECT_TRUE(resultText.isEmpty()) << "SECURITY FLAW: Decryption succeeded on tampered ciphertext!";
}
