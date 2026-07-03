#include "LoginViewModel.h"
#include <QUrl>
#include <QDir>
#include <QStandardPaths>
#include <QDebug>
#include <QFileInfo>
#include <QFile>

#include "SecurePasswordInput.h"


#include <QWindow>
#ifdef Q_OS_WIN
#include <windows.h>
#include <dwmapi.h>
#ifndef DWMWA_USE_IMMERSIVE_DARK_MODE
#define DWMWA_USE_IMMERSIVE_DARK_MODE 20
#endif
#endif

static QString resolveUriToLocalPath(const QString& dbUrl) {
    QString localFilePath = QUrl(dbUrl).isLocalFile() ? QUrl(dbUrl).toLocalFile() : dbUrl;

#ifdef Q_OS_ANDROID
    if (localFilePath.startsWith("content://")) {
        // Qt's QFile can read content:// URIs on Android natively.
        // Copy the encrypted .db into our private sandbox so SQLite can open it.
        QString cachePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        QDir().mkpath(cachePath);
        QString localCopy = cachePath + "/active_vault.db";

        // Remove stale cache from previous session
        QFile::remove(localCopy);

        if (!QFile::copy(localFilePath, localCopy)) {
            qCritical() << "Failed to import vault from content:// URI";
            return {};
        }
        // Make writable (QFile::copy preserves source permissions which may be read-only)
        QFile::setPermissions(localCopy, QFileDevice::ReadOwner | QFileDevice::WriteOwner);
        qDebug() << "LoginViewModel: Imported vault to sandbox:" << localCopy;
        return localCopy;
    } else if (!localFilePath.startsWith("/")) {
        // If it's a relative name like "app_private_vault.db", put it in AppDataLocation
        QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        QDir().mkpath(dataPath);
        localFilePath = dataPath + "/" + localFilePath;
    }
#endif
    return localFilePath;
}


LoginViewModel::LoginViewModel(DiaryManager &manager, QObject *parent)
    : QObject(parent), m_diaryManager(manager),m_sanitizer(30000,this){}

void LoginViewModel::authenticate(SecurePasswordInput *passwordField, const QString& dbUrl){
    if (!passwordField) {
        qCritical() << "Error: Password field is null.";
        return;
    }

    // convert qml file: //url to a native OS file path
    const QString localFilePath = resolveUriToLocalPath(dbUrl);
    if(localFilePath.isEmpty()){
        qCritical()<<"Error: No database file selected";
        emit dbNotFound();
        return;
    }

    // Android: track original content:// URI so DiaryManager can sync back on lock
    if (dbUrl.contains(QStringLiteral("content://"))) {
        m_diaryManager.setContentUri(dbUrl, localFilePath);
    }

    bool openState = (m_diaryManager.openDiary("\0",localFilePath, passwordField->getSecureBuffer()) == DiaryError::None); // for auth we do not need filename
    passwordField->clearPassword();
    if(openState){
        qDebug() << "ViewModel: Login successful. Firing success signal to QML.";
        emit loginSuccess();
    }else{
        qDebug() << "ViewModel: Login failed. Firing failure signal to QML.";
        emit loginFailed();
    }
}

void LoginViewModel::updateTitleBar(bool isDark) {
#ifdef Q_OS_WIN
    // We get the active window from the application
    for (QWindow *window : QGuiApplication::allWindows()) {
        if (window->winId()) {
            HWND hwnd = (HWND)window->winId();
            BOOL dark = isDark ? TRUE : FALSE;
            DwmSetWindowAttribute(hwnd, DWMWA_USE_IMMERSIVE_DARK_MODE, &dark, sizeof(dark));
        }
    }
#endif
}

void LoginViewModel::createVault(const QString& newJournalName,SecurePasswordInput *passwordField, const QString &dbUrl){
    if(!passwordField){
        qCritical() << "Error: Password field is null.";
        return;
    }
    // convert qml file: //url to a native OS file path
    const QString localFilePath = resolveUriToLocalPath(dbUrl);
    if(localFilePath.isEmpty()){
        qCritical()<<"Error: No database file selected";
        emit dbNotFound();
        return;
    }

    // Android: track original content:// URI so DiaryManager can sync back on lock
    if (dbUrl.contains(QStringLiteral("content://"))) {
        m_diaryManager.setContentUri(dbUrl, localFilePath);
    }

    bool openState = (m_diaryManager.openDiary(newJournalName,localFilePath, passwordField->getSecureBuffer()) == DiaryError::None);
    passwordField->clearPassword();
    if(openState){
        qDebug() << "ViewModel: Login successful. Firing success signal to QML.";
        emit loginSuccess();
    }else{
        qDebug() << "ViewModel: Login failed. Firing failure signal to QML.";
        emit loginFailed();
    }
}

void LoginViewModel::createVaultAndroid(const QString &journalName, SecurePasswordInput *passwordField){
    if(!passwordField){
        qCritical() << "Error: Password field is null.";
        return;
    }
    QString docsPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(docsPath);
    if (!dir.exists("DCharVault")) {
        dir.mkdir("DCharVault");
    }

    QString safeName = journalName.trimmed();

    if(!safeName.endsWith(".db")){
        safeName+=".db";
    }

    QString fullPath = docsPath + "/DCharVault/" + safeName;

    bool createState = (m_diaryManager.openDiary(journalName, fullPath, passwordField->getSecureBuffer()) == DiaryError::None);
    passwordField->clearPassword();

    if(createState){
        qDebug() << "ViewModel: Login successful. Firing success signal to QML.";
        emit loginSuccess();
    }else{
        qDebug() << "ViewModel: Login failed. Firing failure signal to QML.";
        emit loginFailed();
    }
}
