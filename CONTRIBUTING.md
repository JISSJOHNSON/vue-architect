# Contributing to Vue Architect

First off, thank you for considering contributing to Vue Architect! It's people like you that make the development community such a great place.

## 🌟 How Can I Contribute?

### Reporting Bugs
- Ensure the bug was not already reported by searching on GitHub [Issues](https://github.com/jissjohnson/vue-architect/issues).
- If you're unable to find an open issue addressing the problem, open a new one. Be sure to include a clear title, a description, as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

### Suggesting Enhancements
- Open a GitHub Issue and explain the feature you want to see.
- Explain why this feature would be useful to most users.

### Pull Requests
1. **Fork the repository** and create your branch from `main`.
2. **Setup your environment**: Ensure you have Bash, Node.js v18+, and Git installed.
3. **Make your changes**:
   - If you are modifying the scaffolding logic, look in `lib/`.
   - If you are modifying the generated code, look in `resources/vue/`.
4. **Test your changes**: Run `./vue-architect.command` and generate a project to ensure everything works as expected.
5. **Format your code**: Follow the existing indentation and naming conventions in the scripts.
6. **Submit the PR**: Provide a clear description of what you've done and link any relevant issues.

## 🏗️ Codebase Overview

- **`vue-architect.command`**: The entry point. It sets up environment variables and sources the library files.
- **`lib/ui.sh`**: Functional UI components (banners, spinners, selection menus).
- **`lib/actions.sh`**: Handles directory creation, Git initialization, and dependency installation.
- **`lib/generators.sh`**: The "brain" that decides which templates to use and what variables to inject.
- **`resources/vue/`**: Contains all `.template` files. These use `{{PLACEHOLDER}}` syntax for dynamic replacement.

## 📝 Working with Templates

When adding a new template:
1. Create the file in `resources/vue/`.
2. Use `{{KEY}}` for any dynamic content.
3. Update `lib/generators.sh` to include a `generate_from_template` call for your new file.
4. If your template depends on a user's feature selection, add the conditional logic in `lib/generators.sh`.

## 🎨 Shell Scripting Standards

- Use `local` variables within functions.
- Use `"${VARIABLE}"` for expansion to prevent word splitting.
- Use `log_info`, `log_success`, `log_warn`, and `log_header` from `lib/ui.sh` for feedback.
- Ensure cross-platform compatibility (macOS and Linux).

## ☕ Support

If you have questions, feel free to open an issue or reach out via [Buy Me A Coffee](https://www.buymeacoffee.com/jissjohnson).

---
Happy coding! 🚀
