# Contributing to Vue Architect

First off, thank you for considering contributing to Vue Architect! This project is designed to be a scalable foundation for modern Vue development, and your contributions help make it better for everyone.

By participating in this project, you agree to abide by the **Code of Conduct** to maintain a welcoming and inclusive community.

---

## 🌟 How Can I Contribute?

### 🐛 Reporting Bugs
- **Search first**: Check existing [Issues](https://github.com/jissjohnson/vue-architect/issues) to avoid duplicates.
- **Report**: If not found, open a new issue with:
  - A clear, descriptive title.
  - Steps to reproduce the bug.
  - Expected behavior vs. actual behavior.
  - Your environment (OS, Node version).

### 💡 Suggesting Enhancements
- Open a GitHub Issue and explain the feature you want to see.
- Explain why this feature would be useful to most users.
- **Platform Support**: We are specifically looking for contributions to help port the CLI to **Linux** and **Windows** environments.

---

## 🛠️ Development Workflow

### Prerequisites
- **Bash** (v4.0 or higher recommended)
- **Node.js** (v18.0.0 or higher)
- **Git**

### Setting Up
1. **Fork** the repository on GitHub.
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/vue-architect.git
   cd vue-architect
   ```
3. **Make it executable**:
   ```bash
   chmod +x vue-architect.command
   ```

---

## 🏗️ Technical Architecture

The platform is divided into three logical layers. Understanding this is key to making effective contributions.

### 1. Core Layer (`core/`)
The brain of the platform.
- **`ui.sh`**: Shared UI components and color logic.
- **`utils.sh`**: Common utilities (spinners, name validation).
- **`init.sh`**: Lifecycle hooks (directory setup, git init).
- **`versions.sh`**: The package version management logic.

### 2. Vue Engine Layer (`engines/vue/`)
Encapsulates all logic specific to Vue.js.
- **`constants.sh`**: Vue state and dependency lists.
- **`actions.sh`**: Dependency installation and structure logic.
- **`generators.sh`**: Logic for deciding which templates to use.
- **`versions/`**: Profile definitions (stable.sh, latest.sh, etc.).

### 3. Resource Layer (`resources/vue/`)
- Contains the actual blueprint files, Vue components, and configuration templates.

---

## 📝 Pull Request Process

1. **Branch**: Create a new branch from `main` for your feature or fix.
   ```bash
   git checkout -b feature/my-new-feature
   ```
2. **Code**: Implement your changes.
3. **Test**: Run the architect script locally to verify your changes work as expected.
   ```bash
   ./vue-architect.command
   ```
4. **Commit**: Write clear, concise commit messages.
5. **Push**: Push to your fork and submit a Pull Request.

### Style Guide
- **Shell Scripting**:
  - Use `local` variables in functions to avoid pollution.
  - Always quote variables: `"${VARIABLE}"`.
  - Use the core logging functions (`log_info`, `log_success`, etc.) for output.
- **Indentation**: Use 2 spaces for indentation.

---

## ☕ Support

Reach out via [GitHub Issues](https://github.com/jissjohnson/vue-architect/issues) or support the project via [Buy Me A Coffee](https://www.buymeacoffee.com/jissjohnson).

---

Happy architecting! 🚀
