#include<gtest/gtest.h>
#include<QString>
#include<QByteArray>
#include"model/DatabaseManager.h"

class DatabaseManagerTest : public ::testing::Test{
protected:
    DatabaseManager dbManager;
    void SetUp() override{
        // used :memory intentionally to protect polluting local storage
        ASSERT_TRUE(dbManager.databaseInit(":memory:"))<< "Failed to initialize in-memory SQLite database.";
        ASSERT_TRUE(dbManager.createTable())<< "Failed to create database tables.";
    }
};

TEST_F(DatabaseManagerTest, ConfigKeyValueStorage) {
    const QString testKey = "crypto_salt";
    const QByteArray testValue = "dummy_random_salt_bytes_010101";

    bool writeSuccess = dbManager.setConfigValue(testKey, testValue);
    ASSERT_TRUE(writeSuccess) << "Database failed to insert config value.";

    const QByteArray retrievedValue = dbManager.getConfigValue(testKey);
    ASSERT_FALSE(retrievedValue.isEmpty()) << "Database returned empty value for existing key.";

    EXPECT_EQ(testValue, retrievedValue) << "Retrieved database data does not match inserted data.";
}

TEST_F(DatabaseManagerTest, SetAndGetJournalName) {
    const QString expectedName = "My Secret Journal 2026";

    ASSERT_TRUE(dbManager.setJournalName(expectedName)) << "Failed to set journal name.";

    const QString retrievedName = dbManager.getJournalName();
    EXPECT_EQ(expectedName, retrievedName) << "Journal name round-trip failed.";
}
