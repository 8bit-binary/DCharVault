<div align="center">
  <img src="https://raw.githubusercontent.com/DCharVault/DCharVault/main/.github/logo.png" alt="DCharVault Logo" width="200"/>
  <h1>DCharVault</h1>
  <p><b>A cross-platform, zero-knowledge local journaling application focusing on security and native performance.</b></p>

  <!-- Badges -->
  <a href="https://qt.io"><img src="https://img.shields.io/badge/Qt-6.8-41CD52?logo=qt&logoColor=white" alt="Qt 6.8"></a>
  <a href="https://en.cppreference.com/w/cpp/20"><img src="https://img.shields.io/badge/C++-20-00599C?logo=c%2B%2B&logoColor=white" alt="C++20"></a>
  <a href="https://libsodium.org"><img src="https://img.shields.io/badge/Cryptography-Libsodium-blue?logo=security&logoColor=white" alt="Libsodium"></a>
  <a href="https://sqlite.org"><img src="https://img.shields.io/badge/Database-SQLite-003B57?logo=sqlite&logoColor=white" alt="SQLite"></a>
  <br/>
  <a href="https://github.com/DCharVault/DCharVault/actions"><img src="https://img.shields.io/github/actions/workflow/status/DCharVault/DCharVault/build.yml?branch=main" alt="Build Status"></a>
  <a href="https://github.com/DCharVault/DCharVault/blob/main/LICENSE"><img src="https://img.shields.io/github/license/DCharVault/DCharVault" alt="License"></a>
</div>

<br/>

> ⚠️ **Status:** Currently in active development. Core cryptography and Qt/QML integration are functional.

---

## 📝 About the Project

**DCharVault** is an offline-first, highly secure diary and journaling app designed to keep your private thoughts truly private. In an era where data is often stored on cloud servers and vulnerable to breaches, DCharVault ensures that your entries never leave your device unencrypted, and are never accessible in plain text.
**DCharVault** was built as a personal project to explore the complexities of integrating low-level cryptographic memory management with a high-level cross-platform GUI framework. 

---

## ✨ Technical Highlights

* 🛡️ **Advanced Memory Protection:** Implementation of a custom C++ STL-compatible allocator (`SecureAllocator`) that wraps Libsodium's memory management to prevent RAM scraping.
* ⚡ **Native Execution:** Built entirely on C++20, ensuring minimal overhead and direct system-level API access.
* 📱 **Unified UI Codebase:** A single Qt QML frontend rendering natively on Windows, Linux, and Android.
* ⚙️ **Automated Build Architecture:** A robust GitHub Actions CI/CD pipeline handling complex dependency resolution (vcpkg, Android NDK) and dynamic linker patching (`patchelf`).

---

## 🛡️ Security Architecture

The cryptographic core is designed to minimize plaintext exposure in memory.

* **Key Derivation (KDF):** Uses Argon2id (`crypto_pwhash`) with interactive limits to securely derive encryption keys from the master password.
* **Data Encryption:** All entries and metadata are encrypted using **XChaCha20-Poly1305 (AEAD)**, providing both confidentiality and authenticated encryption.
* **Memory Safety (`SecureAllocator`):** A custom C++ allocator wrapping `sodium_malloc` and `sodium_free`. This guarantees that sensitive data (keys, passwords, raw text) is:
  * Protected by OS-level memory guard pages.
  * Pinned in RAM (preventing swapping to disk).
  * Securely zeroed out before deallocation.
* **Master Password Verification:** Verification is done via encrypted MAC blocks rather than storing key hashes, ensuring the password is never stored or logged.

---

## ⚠️ Known Limitations

* *This is an architectural experiment; it has not undergone a formal security audit.*
* *Does not protect against kernel-level keylogging or compromised OS environments.*
* *UI and cross-platform UX are currently in experimental phases.*

---

## 🛠️ Tech Stack

| Component | Technology |
| :--- | :--- |
| **Core Logic** | Modern C++ (C++20) |
| **GUI Framework** | Qt 6.8 (C++ Backend / QML Frontend) |
| **Cryptography** | Libsodium |
| **Database** | SQLite (Stores only encrypted payloads) |
| **Build System** | CMake |

---

## 🚀 Getting Started

### Prerequisites

To build DCharVault from source, you will need:

* **CMake** (3.16 or higher)
* **C++20** compatible compiler (GCC, Clang, or MSVC)
* **Qt 6.8** (Components: `Quick`, `Sql`, `QuickControls2`, `QuickDialogs2`)
* **Libsodium**

### 💻 Build Instructions

#### Linux (Ubuntu/Debian)

1. Install dependencies:
   ```bash
   sudo apt update
   sudo apt install build-essential cmake pkg-config libsodium-dev
   # Install Qt6 (Recommended via Qt Maintenance Tool or apt if available)
   ```
2. Clone and build:
   ```bash
   git clone https://github.com/DCharVault/DCharVault.git
   cd DCharVault
   mkdir build && cd build
   cmake ..
   make -j$(nproc)
   ```

#### Windows (MSVC & vcpkg)

1. Install Libsodium using [vcpkg](https://github.com/microsoft/vcpkg):
   ```cmd
   vcpkg install libsodium:x64-windows
   ```
2. Set the environment variable `SODIUM_ROOT_ENV` to your vcpkg installed directory (e.g., `C:\vcpkg\installed\x64-windows`).
3. Build using CMake:
   ```cmd
   git clone https://github.com/DCharVault/DCharVault.git
   cd DCharVault
   mkdir build && cd build
   cmake .. -DCMAKE_TOOLCHAIN_FILE=C:\path\to\vcpkg\scripts\buildsystems\vcpkg.cmake
   cmake --build . --config Release
   ```

#### Android

* Requires the Qt Android toolchain, Android SDK, and NDK.
* Libsodium must be compiled for Android (arm64-v8a, armeabi-v7a, etc.).
* Set `SODIUM_ANDROID_ROOT_ENV` to the root of your compiled Libsodium Android libraries before running CMake.

---

## 🔄 CI/CD & Build Pipeline

DCharVault features an automated cross-compilation pipeline utilizing **GitHub Actions**:

* 🐧 **Linux (Ubuntu):** Manual bundling, RPATH patching (`patchelf`), and dependency isolation.
* 🪟 **Windows (MSVC):** Vcpkg integration and `windeployqt` packaging for seamless distribution.
* 🤖 **Android (ARM64):** Cross-compiled via Qt Android toolchain with automated Release APK keystore signing.

---
## 📄 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](https://github.com/DCharVault/DCharVault/blob/main/LICENSE) for details.

---
