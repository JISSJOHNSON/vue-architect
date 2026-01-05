#!/bin/bash
cd "$(dirname "$0")" || exit 1

# ==============================================================================
#  Vue Architect
#  ------------------------------------------------------------------------------
#  Author:  Jiss Johnson
#  Purpose: Scaffolds a production-ready Vue.js application with JS/TS support.
# ==============================================================================

# --- Strict Mode & Safety ---
set -o errexit
set -o nounset
set -o pipefail

# --- Source Modules ---
# Order matters: Constants -> Utils -> UI -> Generators -> Actions
export ARCHITECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ./lib/constants.sh
source ./lib/utils.sh
source ./lib/ui.sh
source ./lib/generators.sh
source ./lib/actions.sh

# --- Main Execution Flow ---
main() {
  print_banner
  check_requirements
  get_user_input "${1:-}"
  
  setup_directory
  initialize_project
  install_dependencies
  generate_structure
  
  write_vite_config
  write_tailwind_config
  write_eslint_config
  write_code_files
  
  update_scripts
  setup_git
  
  print_summary "${1:-}"
  print_support
}

# Start
main "${1:-}"
