# Vue Architect 🏗️

<p align="center">
  <img src="https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vue.js&logoColor=4FC08D" alt="Vue.js Production Framework" />
  <img src="https://img.shields.io/badge/Vite-646CFF?style=for-the-badge&logo=vite&logoColor=white" alt="Vite Fast Build Tool" />
  <img src="https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white" alt="TypeScript Support" />
  <img src="https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white" alt="Tailwind CSS Design System" />
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

**Vue Architect** is a premium CLI scaffolding tool designed to transform how you start Vue.js projects. It automates the creation of a **production-ready, enterprise-grade architecture** in seconds, allowing you to focus on building features rather than configuring boilerplate.

---

## 🔥 Why Vue Architect?

Standard starters often leave you with a flat structure that quickly becomes unmanageable. **Vue Architect** implements a **Layered Architecture (Clean Architecture)** principles, ensuring your codebase remains decoupled, testable, and scalable from Day 1.

### 🌟 Key Highlights
- **🚀 Ultra-Fast Setup**: Go from zero to a running development server in under 10 seconds.
- **🏗️ Pro-Grade Architecture**: Logical separation of concerns with dedicated layers for API, Services, Models, and UI.
- **🎨 Curated Design System**: Built-in Atomic Design support with `Base` components and pre-configured Tailwind tokens.
- **🛠️ Developer-First DX**: Interactive terminal menus with arrow-key navigation and multi-select feature toggling.
- **🔋 Batteries Included**: Pre-configured Axios interceptors, Storage helpers, and library-aware Formatters.

---

## 🚀 Feature Matrix

| Feature | Included | Description |
| :--- | :---: | :--- |
| **Vue 3 (Composition API)** | ✅ | The modern standard for reactive web development. |
| **Vite 6** | ✅ | Lighting fast HMR and optimized production builds. |
| **TypeScript / JS** | ✅ | Full support for both, including strict TS configurations. |
| **Tailwind CSS 3** | ➕ | Optional utility-first styling with a professional base layer. |
| **Vue Router** | ➕ | Pre-configured layouts and navigation guards. |
| **Pinia** | ➕ | Intuitive, modular state management. |
| **ESLint & Prettier** | ➕ | Industry-standard code style and quality enforcement. |
| **Helper Libraries** | ➕ | Integration for `date-fns` (Date) and `numeral` (Currency). |

---

## 🛠️ Quick Start Guide

### 1. Simple Installation
No global installation required. Just clone and run.

```bash
git clone https://github.com/jissjohnson/vue-architect.git
cd vue-architect
chmod +x vue-architect.command
```

### 2. Launch the Architect
Run the interactive command-line interface:

```bash
./vue-architect.command
```
*(On macOS, you can also just double-click the file in Finder)*

### 3. Automated Configuration
The tool will guide you through:
- **Location**: Current directory, a new folder, or a custom target path.
- **Stack**: Choose between JavaScript and TypeScript.
- **Features**: Toggle Router, Pinia, Tailwind, and more using **Space** to select.

---

## 📂 The Architected Anatomy

Every project generated follows a strict, high-performance structural pattern:

```text
src/
├── api/          # 📡 Axios instance with Auth & Error interceptors
├── assets/       # 🎨 Global styles, images, and brand assets
├── components/   # 🧩 Atomic UI components (base/common/features)
├── constants/    # 🔑 Global constants, HTTP codes, and configurations
├── helpers/      # 🧙 StorageHelper, Formatters, and logic wrappers
├── layouts/      # 🖼️ View structures (Main, Auth, Dashboard)
├── router/       # 🚦 Navigation logic and dynamic guards
├── services/     # ⚙️ Business logic and API coordination layer
├── stores/       # 📦 State persistence using Pinia
└── views/        # 📄 Routeable page components
```

---

## 🛡️ Best Practices & Standards

**Vue Architect** doesn't just give you files; it gives you a **standard**:
- **Services Pattern**: Keeps components "thin" by moving logic to reusable service classes.
- **Atomic Components**: `src/components/base` ensures UI consistency through small, reusable units.
- **Helper Encapsulation**: Never touch `localStorage` or `date` logic directly; use the provided secure helpers.
- **Flat Configs**: Uses the latest ESLint Flat Config and Prettier 3 for a modern linting experience.

---

## 🤝 Community & Support

- **Portfolio**: [Explore my work](https://jissjohnson.info)
- **Issues**: [Report a bug or request a feature](https://github.com/jissjohnson/vue-architect/issues)
- **Support**: [Buy me a coffee ☕](https://www.buymeacoffee.com/jissjohnson)

---

## 📜 License

Project is licensed under the **MIT License**. Feel free to use it for personal or commercial projects.

---
<p align="center">
  Developed with ❤️ by <b>Jiss Johnson</b>
</p>
