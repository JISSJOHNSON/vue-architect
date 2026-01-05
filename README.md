# Vue Architect

<p align="center">
  <img src="https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vue.js&logoColor=4FC08D" alt="Vue.js" />
  <img src="https://img.shields.io/badge/Vite-646CFF?style=for-the-badge&logo=vite&logoColor=white" alt="Vite" />
  <img src="https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white" alt="TypeScript" />
  <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black" alt="JavaScript" />
  <img src="https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white" alt="Tailwind CSS" />
</p>

<p align="center">
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-green.svg?style=flat-square" alt="MIT License">
  </a>
  <a href="https://www.gnu.org/software/bash/">
    <img src="https://img.shields.io/badge/Language-Bash-blue.svg?style=flat-square" alt="Written in Bash">
  </a>
  <a href="https://github.com/jissjohnson/vue-architect/issues">
    <img src="https://img.shields.io/github/issues/jissjohnson/vue-architect?style=flat-square&color=red" alt="Open Issues">
  </a>
</p>

<p align="center">
  <b>Opinionated • Scalable • Professional-Grade</b><br>
  <i>Scaffold robust, modular, and cleaner Vue.js production environments in seconds.</i>
</p>

---

## 📖 Overview

**Vue Architect** is a powerful CLI tool designed for developers who value professional project organization. It goes beyond simple scaffolding by providing a **Layered Architecture** (Clean Architecture) that scales from small prototypes to enterprise-level applications.

It eliminates "boilerplate fatigue" by automating the setup of API clients, services, helpers, and a robust design system, all through an **interactive terminal interface**.

## 🚀 Features

- **📂 Layered Architecture**: Decoupled `api`, `services`, `helpers`, and `stores` for maximum maintainability.
- **📍 Flexible Scaffolding**: Create projects in the current directory, a new sub-folder, or any **absolute custom path**.
- **🎨 Design System Ready**: Atomic component structure (`src/components/base`) with pre-configured Tailwind variables and global styles.
- **🛡️ Type Safety**: First-class support for **TypeScript** (or JavaScript) with strict configurations.
- **🧠 Intelligent Helpers**: Global `StorageHelper` (safe JSON & Cookies) and `FormatHelper` (library-aware date/number formatting).
- **🔌 Optional Power-ups**: Toggle integrations for `date-fns`, `numeral`, `Vue Router`, and `Pinia` with a single spacebar tap.
- **🧹 Code Quality**: Pre-configured **ESLint (Flat Config)** and **Prettier** integrations.

## ⚡ Integrations

| Category | Technology | Description |
| :--- | :--- | :--- |
| **Framework** | [**Vue.js 3**](https://vuejs.org/) | Modern composition API support. |
| **Build Tool** | [**Vite**](https://vitejs.dev/) | Ultra-fast build and HMR. |
| **API** | [**Axios**](https://axios-http.com/) | Included by default with request/response interceptors. |
| **Routing** | [**Vue Router**](https://router.vuejs.org/) | Layout-based routing with dynamic meta. |
| **State** | [**Pinia**](https://pinia.vuejs.org/) | Lightweight, intuitive state management. |
| **Styling** | [**Tailwind CSS**](https://tailwindcss.com/) | Utility-first CSS with a curated color palette. |
| **Utilities** | [**date-fns**](https://date-fns.org/) | (Optional) Modern date manipulation. |
| **Utilities** | [**numeral**](http://numeraljs.com/) | (Optional) Advanced number formatting. |

## 📦 Quick Start

### 1. Installation

```bash
git clone https://github.com/jissjohnson/vue-architect.git
cd vue-architect
chmod +x vue-architect.command
```

### 2. Execution

```bash
./vue-architect.command
```
> **Tip:** On macOS, you can simply double-click `vue-architect.command` to start.

### 3. Usage Flow

1.  **Project Location**: Choose `Current Directory`, `New Sub-directory`, or `Custom Path`.
2.  **Language**: Select `JavaScript` or `TypeScript`.
3.  **Features**: Use **Space** to select features like Router, Pinia, or the optional helper libraries.

## 📂 Generated Project Structure

The architect generates a "Clean Architecture" onion structure:

```text
src/
├── api/            # Axios instance with auth/error interceptors
├── assets/         # Static assets and global design system (CSS Variables)
├── components/     # Component Library
│   ├── base/       # Atomic UI elements (BaseButton, etc.)
│   ├── common/     # Global layout pieces (Navbar, Footer)
│   └── features/   # Complex, logic-heavy modules
├── constants/      # App-wide magic strings, HTTP codes, and Config
├── helpers/        # Storage (Cookies/Local) and Format (Date/Number) utilities
├── layouts/        # Page structures (MainLayout, AuthLayout)
├── router/         # Route definitions and Navigation Guards
├── services/       # Decoupled business logic and API orchestration
├── stores/         # Application state (Pinia)
└── views/          # Dynamic page components and Error pages
```

## 🏗️ Technical Implementation

- **`vue-architect.command`**: Main orchestration.
- **`lib/`**:
    - `ui.sh`: Handles high-fidelity interactive menus.
    - `actions.sh`: Handles file system ops and dependency installation.
    - `generators.sh`: Main logic for template processing.
    - `utils.sh`: String manipulation and template substitution.
- **`resources/vue/`**: The core templates used for scaffolding.

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details on how to get started.

## 📜 License

Distributed under the **MIT License**. See [LICENSE](LICENSE) for more information.

## ☕ Support the Project

Boost development by [buying me a coffee](https://www.buymeacoffee.com/jissjohnson).

---
© 2026 Jiss Johnson. Developed with ❤️ for the Vue community.
