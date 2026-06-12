#ifndef SESSIONMANAGER_H
#define SESSIONMANAGER_H

#include<chrono>
#include<cstdint>

enum class SessionState{
    Active,
    Locked,
    LoggedOut
};

class SessionManager{
public:
    explicit SessionManager(uint32_t timeoutSeconds = 300);

    void recordActivity();
    void lock();
    void unlock();

    void setTimeoutSeconds(uint32_t seconds);
    uint32_t timeoutSeconds() const;

    [[nodiscard]] bool isSessionExpired() const;
    SessionState state() const;

private:
    uint32_t m_timeoutSeconds;
    SessionState m_state;
    std::chrono::steady_clock::time_point m_lastActivity;
};

#endif // SESSIONMANAGER_H
