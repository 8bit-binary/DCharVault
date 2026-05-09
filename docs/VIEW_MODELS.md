# ViewModel API Documentation

This document defines the ViewModel layer of DCharVault. Located in the `/viewmodel` directory, these classes inherit from `QObject` and act as the secure bridge between the QML frontend and the C++ Core Models. They manage UI state, handle user input securely, and emit signals to update the UI without exposing backend cryptography.

## `LoginViewModel`
Manages the authentication flow, vault creation, and system-level UI states.

### Q_INVOKABLE Methods (Callable from QML)
*   `void authenticate(SecurePasswordInput* passwordField, const QString& dbUrl)`
    Attempts to unlock an existing vault by passing the secure password buffer to the `DiaryManager`.
*   `void createVault(const QString& journalName, SecurePasswordInput* passwordField, const QString& dbUrl)`
    Initializes a new encrypted vault at the specified desktop path.
*   `void createVaultAndroid(const QString& journalName, SecurePasswordInput* passwordField)`
    Initializes a new encrypted vault using Android-specific internal storage paths.
*   `void updateTitleBar(bool isDark)`
    Updates system-level window UI properties to match the active theme.

### Signals (Emitted to QML)
*   `void loginSuccess()`: Emitted when authentication or vault creation succeeds. Triggers UI navigation to the main diary view.
*   `void loginFailed()`: Emitted when authentication fails (e.g., incorrect master password or invalid MAC).
*   `void dbNotFound()`: Emitted if the target database file does not exist at the provided path.

---

## `DiaryViewModel`
Manages the state and operations for the currently active diary entry.

### Q_INVOKABLE Methods (Callable from QML)
*   `void saveNewEntry(const qint64 id, const QString& title, const QString& content)`
    Routes a save or update command to the `DiaryManager`.
*   `QString loadEntryContent(const qint64 id)`
    Requests the decrypted plaintext content of an entry. Returns the plaintext string to the UI.
*   `QString loadEntryTitle(const qint64 id)`
    Requests the decrypted plaintext title of an entry. Returns the plaintext string to the UI.
*   `void deleteEntry(const qint64 id)`
    Issues a command to permanently delete the specified entry.

### Signals (Emitted to QML)
*   `void entrySavedSuccessfully(const qint64 savedId, const QString& finalizeTitle)`: Emitted upon successful database persistence.
*   `void entrySaveFailed(const QString& errorMessage)`: Emitted if the encryption or database insertion fails.
*   `void entryDeletedSuccessfully()`: Emitted when an entry is successfully purged.
*   `void entryDeleteFailed()`: Emitted if the deletion operation fails.

---

## `DiaryListModel`
A customized `QAbstractListModel` that provides the QML views with a lightweight, iterable list of diary entries.

### Q_INVOKABLE Methods (Callable from QML)
*   `void loadEntries()`
    Commands the `DiaryManager` to decrypt all entry metadata and refreshes the internal UI list.

### Overridden C++ Methods
*   `int rowCount(const QModelIndex &parent = QModelIndex()) const`
    Returns the total number of entries currently loaded in memory.
*   `QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const`
    Maps specific data fields (Title, Date, ID) to QML delegate components.
*   `QHash<int, QByteArray> roleNames() const`
    Defines the string-based roles accessible from QML (e.g., `idRole`, `titleRole`, `dateRole`).

---

## `SecurePasswordInput`
A security-focused UI helper component. It intercepts password keystrokes and stores them directly in a memory-safe `SecureString`, preventing the master password from lingering in Qt's standard string buffers.

### Q_INVOKABLE Methods (Callable from QML)
*   `void clearPassword()`
    Securely zeroes out and clears the internal password buffer.

### Public C++ Methods
*   `int passwordLength() const`
    Returns the current length of the password (used for UI validation, like disabling the submit button if empty).
*   `const SecureString& getSecureBuffer() const`
    Provides the Core Models with a direct reference to the securely allocated password.

### Signals (Emitted to QML)
*   `void passwordLengthChanged()`: Notifies the UI when the password input length changes.
*   `void enterPressed()`: Emitted when the user presses the 'Enter' key within the input field.

---

## `ClipboardSanitizer`
A background security utility that monitors the operating system's clipboard and automatically wipes it after a predefined timeout to prevent sensitive diary data from leaking to other applications.

### Q_INVOKABLE Methods (Callable from QML)
*   `void notifyCopied()`
    Triggered by the UI when the user copies text. Initiates the countdown timer for clipboard sanitization.
*   `void wipeNow()`
    Immediately forces a wipe of the system clipboard.

### Public C++ Methods
*   `void onSystemClipboardChanged()`
    A Qt Slot connected to the OS clipboard. It detects if the user copies new data externally and aborts the wipe timer if necessary.
*   `void executeSanitization()`
    The internal execution method that performs the actual memory overwrite of the clipboard.