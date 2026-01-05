#!/bin/bash

# ==============================================================================
#  Vue Architect
#  ------------------------------------------------------------------------------
#  A scalable platform for scaffolding modern Vue.js applications.
# ==============================================================================

# --- Environment Setup ---
set -o errexit   # Exit on error
set -o nounset   # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

# Establish the platform root directory
cd "$(dirname "$0")"
export ARCHITECT_ROOT="$(pwd)"

# --- Library Imports ---
source "$ARCHITECT_ROOT/core/ui.sh"
source "$ARCHITECT_ROOT/core/utils.sh"
source "$ARCHITECT_ROOT/core/init.sh"
source "$ARCHITECT_ROOT/core/versions.sh"

# --- Global State ---
PROJECT_NAME=""
PROJECT_DIR=""
SELECTED_ENGINE="vue"
START_TIME=$(get_timestamp)

# ==============================================================================
#  Main Execution Flow
# ==============================================================================

main() {
  print_banner
  
  # 1. Initialize Engine logic
  source "$ARCHITECT_ROOT/engines/vue/constants.sh"
  source "$ARCHITECT_ROOT/engines/vue/actions.sh"
  source "$ARCHITECT_ROOT/engines/vue/generators.sh"
  source "$ARCHITECT_ROOT/engines/vue/utils.sh"

  # 2. Select Version Profile
  select_version_profile "$SELECTED_ENGINE"

  # 3. Project Configuration
  echo ""
  echo -en "  ${BOLD}${BLUE}?${RESET} ${BOLD}${WHITE}Project Identifier: ${RESET}${CYAN}"
  read -r input < /dev/tty
  PROJECT_NAME="${input:-my-vue-app}"
  
  local loc_options=("Current Directory (./$PROJECT_NAME)" "Specific Path")
  local loc_choice=0
  select_option "Where should we architect this project?" "${loc_options[@]}" || loc_choice=$?
  
  if [[ $loc_choice -eq 0 ]]; then
    PROJECT_DIR="$(pwd)/$PROJECT_NAME"
  else
    echo -en "  ${BOLD}${BLUE}?${RESET} ${BOLD}${WHITE}Target Path: ${RESET}${CYAN}"
    read -r path_input < /dev/tty
    PROJECT_DIR="$path_input/$PROJECT_NAME"
  fi
  
  # 4. Engine Specific Menu
  vue_engine_menu

  # 5. Execute Pipeline
  setup_project_dir "$PROJECT_DIR" "$PROJECT_NAME"
  
  # Engine specific execution
  vue_initialize_project
  vue_install_dependencies
  vue_generate_structure
  
  # Engine specific generation
  write_vite_config
  write_tailwind_config
  write_eslint_config
  write_code_files
  
  if command -v update_scripts &> /dev/null; then
    update_scripts
  fi

  init_git
  finalize_git
  
  # Summary
  local duration=$(( $(get_timestamp) - START_TIME ))
  log_header "Scaffolding Completed in ${duration}s!"
  
  echo -e "\n  ${BOLD}${WHITE}Quick Start Steps:${RESET}"
  echo -e "    ${CYAN}1.${RESET} cd $PROJECT_DIR"
  echo -e "    ${CYAN}2.${RESET} npm run dev\n"
}

print_banner() {
    echo -e "${GREEN}"
    cat << "EOF"
    ___             _     _ _            _   
   / _ \           | |   (_) |          | |  
  / /_\ \_ __ ___  | |__  _| |_ ___  ___| |_ 
  |  _  | '__/ __| | '_ \| | __/ _ \/ __| __|
  | | | | | | (__  | | | | | ||  __/ (__| |_ 
  \_| |_/_|  \___| |_| |_|_|\__\___|\___|\__|
EOF
    echo -e "${RESET}"
    echo -e "    ${BOLD}${WHITE}Scalable Vue Project Architect Platform${RESET}"
    echo -e "    ${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

main
