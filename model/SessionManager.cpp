#include "SessionManager.h"

SessionManager::SessionManager(uint32_t timeoutSeconds)
    : m_timeoutSeconds(timeoutSeconds)
    , m_state(SessionState::Active)
    , m_lastActivity(std::chrono::steady_clock::now())
{}

void SessionManager::recordActivity(){
    if(m_state == SessionState::Active){
        m_lastActivity = std::chrono::steady_clock::now();
    }
}

bool SessionManager::isSessionExpired() const{
    if(m_timeoutSeconds == 0) return false;

    if(m_state != SessionState::Active) return false;

    auto now = std::chrono::steady_clock::now();
    auto elapsed = std::chrono::duration_cast<std::chrono::seconds>( now - m_lastActivity );

    return elapsed.count() >= m_timeoutSeconds;
}

void SessionManager::lock(){
    m_state = SessionState::Locked;
}
void SessionManager::unlock(){
    m_state = SessionState::Active;
    m_lastActivity = std::chrono::steady_clock::now();
}

void SessionManager::setTimeoutSeconds(uint32_t seconds){
    m_timeoutSeconds = seconds;
}

uint32_t SessionManager::timeoutSeconds() const{
    return m_timeoutSeconds;
}
SessionState SessionManager::state() const{
    return m_state;
}
