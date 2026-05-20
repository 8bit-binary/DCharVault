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

// tampering/corruption attack
TEST_F(EncryptionManagerTest, DecryptionFailsOnCorruptedData) {
    const QString originalText = "Sensitive_Data_Do_Not_Leak";

    const char* rawPwd = "StrongTestPassword123!";
    const SecureString dummyPassword(rawPwd, rawPwd + std::strlen(rawPwd));

    const QByteArray salt = encManager.generateSalt();
    const SecureVector masterKey = encManager.deriveMasterKey(dummyPassword, salt);

    QByteArray encryptedData = encManager.encryptString(originalText, masterKey);
    ASSERT_FALSE(encryptedData.isEmpty());

    // Attack Case: Flip single bit in the ciphertext to simulate tampering or disk corruption
    encryptedData[0] = encryptedData[0] ^ 0x01;

    // Defensive Pact: Decryption must reject the tampered payload
    const QString resultText = encManager.decryptString(encryptedData, masterKey);

    EXPECT_TRUE(resultText.isEmpty()) << "SECURITY FLAW: Decryption succeeded on tampered ciphertext!";
}

// wrong pass attack
TEST_F(EncryptionManagerTest, DecryptionFailsWithWrongPassword){
    const QString originalText = "My_Secret_Journal_Entry";

    const char* correctRawPwd = "CorrectPassword123!";
    const SecureString correctPassword(correctRawPwd,correctRawPwd+std::strlen(correctRawPwd));

    const char* wrongPwdRaw = "WrongPassword999!";
    const SecureString wrongPassword(wrongPwdRaw, wrongPwdRaw + std::strlen(wrongPwdRaw));

    const QByteArray salt = encManager.generateSalt();
    const SecureVector masterKey = encManager.deriveMasterKey(correctPassword,salt);
    const QByteArray encryptedData = encManager.encryptString(originalText, masterKey);

    const SecureVector wrongKey = encManager.deriveMasterKey(wrongPassword, salt);
    const QString resultText = encManager.decryptString(encryptedData, wrongKey);

    EXPECT_TRUE(resultText.isEmpty()) << "SECURITY FLAW: Vault decrypted with the wrong password!";
}

// Truncation/Buffer Overflow Attack
TEST_F(EncryptionManagerTest, DecryptionRejectsUndersizedPayload)
{
    const char* rawPwd = "StrongTestPassword123!";
    const SecureString dummyPassword(rawPwd, rawPwd + std::strlen(rawPwd));
    const QByteArray salt = encManager.generateSalt();
    const SecureVector masterKey = encManager.deriveMasterKey(dummyPassword, salt);

    const QByteArray tinyGarbageData = "1234567890";

    const QString resultText = encManager.decryptString(tinyGarbageData, masterKey);

    EXPECT_TRUE(resultText.isEmpty()) << "CRITICAL: System failed to reject an undersized ciphertext payload.";
}
