# Vue Architect 🏗️

<p align="center">
  <img src="https://img.shields.io/badge/Vue.js-Active-4FC08D?style=for-the-badge&logo=vue.js&logoColor=white" alt="Vue.js Support" />
  <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black" alt="JavaScript" />
  <img src="https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white" alt="TypeScript" />
  <img src="https://img.shields.io/badge/Vite-646CFF?style=for-the-badge&logo=vite&logoColor=white" alt="Vite Support" />
  <img src="https://img.shields.io/badge/Platform-Scalable-blue?style=for-the-badge" alt="Scalable Architecture" />
</p>

<p align="center">
  <a href="https://jissjohnson.info">
    <img src="https://img.shields.io/badge/Author-Jiss_Johnson-blue?style=flat-square" alt="Author Jiss Johnson">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-green.svg?style=flat-square" alt="MIT License">
  </a>
  <a href="https://github.com/jissjohnson/vue-architect/stargazers">
    <img src="https://img.shields.io/github/stars/jissjohnson/vue-architect?style=flat-square" alt="GitHub stars">
  </a>
  <a href="https://www.buymeacoffee.com/jissjohnson">
    <img src="https://img.shields.io/badge/Buy_Me_A_Coffee-Support-orange?style=flat-square&logo=buy-me-a-coffee" alt="Support development">
  </a>
</p>

**Vue Architect** is a premium CLI scaffolding tool designed to transform how you start Vue.js projects. It automates the creation of a **production-ready, enterprise-grade architecture** in seconds, built on a scalable platform-agnostic core.

---

## 📚 Table of Contents

- [The Scalable Architecture](#-the-scalable-architecture)
- [Key Features](#-key-features)
- [Platform Internals](#-platform-internals-for-developers)
- [Supported Platforms](#-supported-platforms)
- [Quick Start](#-quick-start)
- [Project Anatomy](#-project-anatomy)
- [Support & Connect](#-support--connect)
- [License](#-license)

---

## 🏗️ The Scalable Architecture

While focusing on **Vue.js**, this tool is built on a decoupled "Engine" architecture. This means the core scaffolding logic is separated from framework-specific templates, ensuring the project structure remains clean, modular, and infinitely extensible.

---

## 🌟 Key Features

- **🚀 Professional Vue Scaffolding**: Expertly architected projects for **Vue.js** (JS/TS) with a production-grade directory structure.
- **📦 Package Version Management**: Choose between **Stable**, **Latest**, or **Legacy** version profiles, or provide **Manual Overrides** for specific packages.
- **🏗️ Layered Architecture**: Implements a clean separation of concerns (API, Services, Components, Stores) by default.
- **🛠️ Extensible Core**: Centralized UI and Utility libraries ensure consistent behavior and reliability.
- **🔋 Batteries Included**: Pre-configured with Vite, Tailwind CSS, ESLint, Prettier, and essential development helpers.

---

## 🛠️ Platform Internals (For Developers)

If you are looking to modify the tool or understand how it works, here is the technical breakdown:

- **[core/](file:///Users/jissjohnson/code/vue-architect/core/)**: The brain of the platform.
    - `ui.sh`: Handles standard colors, spinners, and interactive keyboard menus.
    - `utils.sh`: Contains the Python-based templating engine and system validators.
    - `init.sh`: Manages the common project creation and Git rituals.
- **[engines/vue/](file:///Users/jissjohnson/code/vue-architect/engines/vue/)**: The Vue-specific logic.
    - `actions.sh`: Defines how dependencies are installed.
    - `generators.sh`: Orchestrates the assembly of the source tree.
    - `versions/`: Houses the version profiles for different environments.
- **[resources/vue/](file:///Users/jissjohnson/code/vue-architect/resources/vue/)**: The actual blueprint files used during scaffolding.

---

## 💻 Supported Platforms

- **macOS**: ✅ Fully Supported (Primary Development Platform)
- **Linux**: 🚧 Coming Soon
- **Windows**: 🚧 Coming Soon

*We are actively working on cross-platform compatibility to bring the Architect experience to all environments.*

---

## 🚀 Quick Start

### 1. Installation
Clone the repository to your local machine:

```bash
git clone https://github.com/jissjohnson/vue-architect.git
cd vue-architect
chmod +x vue-architect.command
```

### 2. Launch the Architect
Run the main entry point:

```bash
./vue-architect.command
```
*(On macOS, you can simply **double-click** `vue-architect.command` in Finder)*


---

## 🛠️ Building from Source

To create a single-file distributable executable of the Vue Architect:

1.  Run the build script:
    ```bash
    ./build.sh
    ```
2.  The executable will be generated at `dist/vue-architect`.
3.  You can move this file anywhere (e.g., `/usr/local/bin`) and run it:
    ```bash
    ./vue-architect
    ```


## 📂 Project Anatomy
Every project generated follows this professional structural pattern:

- **api/**: Axios instance with centralized Auth/Error interceptors.
- **services/**: Business logic layer (The "brain" of your app).
- **components/**: Atomic UI separation (base, common, feature-specific).
- **helpers/**: Secure wrappers for Storage, Date formatting, and Numerics.
- **views/**: Route-based page components.

---

## 🤝 Support & Connect

<p align="center">
  <b>Portfolio</b>: <a href="https://jissjohnson.info">jissjohnson.info</a>
  <br>
  <br>
  <b>Support</b>:
  <br>
  <br>
  <a href="https://www.buymeacoffee.com/jissjohnson">
    <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" width="180" />
  </a>
</p>

---

## 📜 License
Distributed under the **MIT License**. Check `LICENSE` for more information.

<p align="center">
  Developed with ❤️ by <b>Jiss Johnson</b>
</p>
