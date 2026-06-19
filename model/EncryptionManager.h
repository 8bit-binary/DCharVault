#ifndef ENCRYPTIONMANAGER_H
#define ENCRYPTIONMANAGER_H

#include <sodium.h>
#include"SecureAllocator.h"
#include<QByteArray>
#include<string>
#include<vector>
#include<cstdint>

class EncryptionManager{
public:
    EncryptionManager();

    bool initialize() const;

    QByteArray generateSalt() const;

    SecureVector deriveMasterKey(const SecureString& password, const QByteArray& salt) const;

    QByteArray encryptString(const QString& inputString, const SecureVector& masterKey) const;
    QString decryptString(const QByteArray& inputBytes, const SecureVector& masterkey) const;

    // generates secure randombytes
    QByteArray generateRandomBytes(size_t length = 32) const;

private:
};

#endif // ENCRYPTIONMANAGER_H
