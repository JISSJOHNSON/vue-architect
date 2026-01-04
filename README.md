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
  <b>Opinionated • Scalable • Production-Ready</b><br>
  <i>Instantly scaffold a robust, modular Vue.js development environment.</i>
</p>

---

## 📖 Overview

**Vue Architect** is a CLI tool designed to skip the repetitive "boilerplate fatigue." Instead of spending 30 minutes configuring ESLint, setting up Pinia, or debugging tailwind configs, run one command and start coding immediately.

It offers a **fully interactive terminal interface** to let you cherry-pick exactly what you need for your modern web application.

## ⚡ Tech Stack & Integrations

Vue Architect integrates the best-in-class tools from the Vue ecosystem. Click on any technology to learn more:

| Category | Technology | Description |
| :--- | :--- | :--- |
| **Framework** | [**Vue.js 3**](https://vuejs.org/) | The progressive JavaScript framework. |
| **Build Tool** | [**Vite**](https://vitejs.dev/) | Next generation frontend tooling. |
| **Routing** | [**Vue Router**](https://router.vuejs.org/) | (Optional) The official router for Vue.js. |
| **State** | [**Pinia**](https://pinia.vuejs.org/) | (Optional) The intuitive store for Vue.js. |
| **Styling** | [**Tailwind CSS**](https://tailwindcss.com/) | (Optional) A utility-first CSS framework. |
| **Language** | [**TypeScript**](https://www.typescriptlang.org/) | (Optional) Strongly typed JavaScript. |
| **Language** | [**JavaScript**](https://developer.mozilla.org/en-US/docs/Web/JavaScript) | The language of the web. |
| **Linting** | [**ESLint**](https://eslint.org/) | Find and fix problems in your JavaScript code. |
| **Formatting**| [**Prettier**](https://prettier.io/) | An opinionated code formatter. |

## 🚀 Features

- **🎨 Interactive CLI**: Beautiful, animated terminal interface with keyboard navigation.
- **🛡️ Type Safety**: First-class support for **TypeScript** (or JavaScript, if you prefer).
- **🧩 Modular Architecture**: Scaffolds a scalable folder structure (`src/features`, `src/layouts`) rather than a flat mess.
- **🧹 Code Quality**: Automated setup for **ESLint (Flat Config)** and **Prettier**.
- **🧠 Smart scaffolding**: The generated code adapts to your choices (e.g., proper Pinia imports only when selected).
- **⚡ Performance**: Built on top of Vite for blazing fast startup and HMR.

## 🛠 Prerequisites

Before running the architect, ensure you have:

*   **Node.js** (v18.0.0+)
*   **Git** (For version control)
*   **Bash** (Native on macOS/Linux. Windows users: use WSL/Git Bash).

## 📦 Quick Start

### 1. Installation

Clone the repository to get the latest version of the architect.

```bash
git clone https://github.com/jissjohnson/vue-architect.git
cd vue-architect
```

### 2. Execution

Make the script executable and run it.

```bash
chmod +x vue-architect.command
./vue-architect.command
```
> **Tip:** On macOS, you can simply double-click `vue-architect.command` in Finder!

### 3. Usage

Follow the interactive prompts:

1.  **Project Name**: Enter a lowercase name (e.g., `my-dashboard`).
2.  **Language**: Choose between JS or TS.
3.  **Features**: Use **Space** to toggle features and **Enter** to confirm.

## 📂 Generated Structure

Your new project will look like this (depending on selected features):

```text
my-vue-app/
├── public/
├── src/
│   ├── assets/          # Static assets (images, fonts)
│   ├── components/      # Shared components
│   │   ├── common/      # Global (Footer, Navbar)
│   │   └── features/    # complex feature-specific components
│   ├── layouts/         # Page layouts (DefaultLayout)
│   ├── views/           # Route views / Pages
│   ├── router/          # (Optional) Router config
│   ├── stores/          # (Optional) Pinia stores
│   ├── utils/           # Helper functions
│   ├── App.vue          # Root component
│   └── main.ts          # Application entry
├── .gitignore
├── index.html
├── package.json
└── vite.config.ts
```

## 🏗️ Internal Architecture

If you want to contribute, here is how `vue-architect` itself is organized:

- **`vue-architect.command`**: Main entry point.
- **`lib/`**:
    - `ui.sh`: Handles the interactive menus and banners.
    - `actions.sh`: Core logic implementation.
    - `generators.sh`: Templates for code generation.

## 🤝 Contributing

We love contributions! Please read our [Contributing Guide](CONTRIBUTING.md) (coming soon) or simply:

1.  Fork it.
2.  Create your feature branch (`git checkout -b feature/cool-thing`).
3.  Commit your changes (`git commit -m 'Add cool thing'`).
4.  Push to the branch (`git push origin feature/cool-thing`).
5.  Open a Pull Request.

## 📜 License

This project is licensed under the **MIT License**. See [LICENSE](LICENSE) for details.

## ☕ Support the Project

If `Vue Architect` saved you time, consider buying me a coffee to keep the momentum going!

<br>
<a href="https://www.buymeacoffee.com/jissjohnson" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" width="200" />
</a>
