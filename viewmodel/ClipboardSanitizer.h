/*
 * SECURITY LIMITATIONS:
 *
 * This sanitizer can only control the primary clipboard. It CANNOT prevent:
 * - Windows Clipboard History (Win+V) from persisting copies
 * - macOS Universal Clipboard from syncing to iCloud
 * - Third-party clipboard managers from logging all clipboard operations
 * - Wayland clipboard paste models on Linux
 * - Screenshots/screen recording software from capturing paste events
 *
 * Users should disable Clipboard History and clipboard managers if handling
 * highly sensitive data.
 */


#ifndef CLIPBOARDSANITIZER_H
#define CLIPBOARDSANITIZER_H

#include<QObject>
#include<QTimer>
#include<QClipboard>

class DiaryManager;

class ClipboardSanitizer : public QObject{
    Q_OBJECT
    Q_PROPERTY(uint32_t timeoutSeconds READ timeoutSeconds WRITE setTimeoutSeconds NOTIFY timeoutChanged)
public:
     explicit ClipboardSanitizer(DiaryManager* manager, int defaultTimeoutMs = 30000, QObject *parent = nullptr);
    ~ClipboardSanitizer();

    Q_INVOKABLE void notifyCopied();
    Q_INVOKABLE void wipeNow();

    uint32_t timeoutSeconds() const;
    Q_INVOKABLE void setTimeoutSeconds(uint32_t seconds);

public slots:
    void onVaultOpened();

private slots:
    void onSystemClipboardChanged();
    void executeSanitization();

signals:
    void clipboardSanitized(); // emitted after wipe
    void externalClipboardDetected(); // emitted when external change detected
    void timeoutChanged();

private:
    DiaryManager *m_diaryManager;
    uint32_t m_timeoutSeconds;

    void overwriteWithGarbage();

    QTimer m_wipeTimer;
    QClipboard *m_clipboard;

    bool m_ownsClipboard;
};

#endif // CLIPBOARDSANITIZER_H
