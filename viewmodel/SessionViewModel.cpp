#include"SessionViewModel.h"
#include "model/DiaryManager.h"


SessionViewModel::SessionViewModel(DiaryManager *diaryManager, QObject *parent)
  : QObject(parent)
    , m_diaryManager(diaryManager)
    , m_session(diaryManager->loadSessionTimeout()) // initialize with saved value 600(10 mins)
    , m_tickTimer(this)
{
    m_tickTimer.setTimerType(Qt::VeryCoarseTimer); // battery friendly
    connect(&m_tickTimer, &QTimer::timeout, this, &SessionViewModel::onTimerTick);
    m_tickTimer.start(30000); // hardcoded: minimum timeout is 60 so 30s is enough at this stage
}

bool SessionViewModel::isLocked() const {
    return m_session.state() == SessionState::Locked;
}

uint32_t SessionViewModel::timeoutSeconds() const {
    return m_session.timeoutSeconds();
}

void SessionViewModel::reportActivity() {
    m_session.recordActivity();
}

void SessionViewModel::lockNow() {
    const DiaryError error = m_diaryManager->lockVault();
    if (error != DiaryError::None) {
        // future todo: log or emit a warning signal later for user or testing
    }
    m_session.lock();
    emit lockStateChanged();
    emit sessionLocked();
}

void SessionViewModel::onUnlockSuccess() {
    m_session.unlock();
    emit lockStateChanged();
    emit sessionUnlocked();
}

void SessionViewModel::setTimeoutSeconds(uint32_t seconds) {
    m_session.setTimeoutSeconds(seconds);
    const DiaryError error = m_diaryManager->saveSessionTimeout(seconds);
    if (error != DiaryError::None) {
        // future todo: log or emit a warning signal later for user or testing
    }
    emit timeLimitChanged();
}

void SessionViewModel::onTimerTick() {
    if (!m_diaryManager->isVaultOpened()) return;
    if (m_session.state() == SessionState::Locked) return;
    if (m_session.isSessionExpired()) {
        lockNow();
    }
}

void SessionViewModel::onApplicationStateChanged(Qt::ApplicationState state) {
    if (state == Qt::ApplicationSuspended || state == Qt::ApplicationHidden) {
        if (m_diaryManager->isVaultOpened()) {
            lockNow();
        }
    }
}

void SessionViewModel::onVaultOpened(){
    const uint32_t saved = m_diaryManager->loadSessionTimeout();
    m_session.setTimeoutSeconds(saved);
    emit timeLimitChanged();
}
