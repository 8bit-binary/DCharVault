#ifndef SESSIONVIEWMODEL_H
#define SESSIONVIEWMODEL_H

#include <QObject>
#include <QTimer>
#include "model/SessionManager.h"

class DiaryManager;

class SessionViewModel : public QObject {
    Q_OBJECT

    // Read-only from QML — only C++ core can change it
    //         type          getter/method   signal: that fires when value changes
    Q_PROPERTY(bool isLocked READ isLocked NOTIFY lockStateChanged)

    // Read-Write direct from QML -- settings screen can change it
    Q_PROPERTY(uint32_t timeoutSeconds READ timeoutSeconds
                   WRITE setTimeoutSeconds NOTIFY timeLimitChanged)

public:
    explicit SessionViewModel(DiaryManager* diaryManager, QObject* parent = nullptr);

    bool isLocked() const;
    uint32_t timeoutSeconds() const;

    Q_INVOKABLE void reportActivity();
    Q_INVOKABLE void lockNow();
    Q_INVOKABLE void onUnlockSuccess();
    Q_INVOKABLE void setTimeoutSeconds(uint32_t seconds);

public slots:
    void onApplicationStateChanged(Qt::ApplicationState state);
    void onVaultOpened();

signals:
    void lockStateChanged();
    void sessionLocked();
    void sessionUnlocked();
    void timeLimitChanged();

private slots:
    void onTimerTick();

private:
    DiaryManager* m_diaryManager;  // can null-check before lockVault()
    SessionManager m_session;       // owned value member(SessionViewModel owns it)
    QTimer m_tickTimer;     // owned value member
};

#endif // SESSIONVIEWMODEL_H
