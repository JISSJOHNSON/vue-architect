#!/bin/bash

# --- Vue Engine Constants ---

# Defaults (can be overridden by version profiles)
export VUE_VERSION="${VUE_VERSION:-latest}"
export VITE_VERSION="${VITE_VERSION:-latest}"
export TAILWIND_VERSION="${TAILWIND_VERSION:-latest}"
export PINIA_VERSION="${PINIA_VERSION:-latest}"
export ROUTER_VERSION="${ROUTER_VERSION:-latest}"
export ESLINT_VERSION="${ESLINT_VERSION:-latest}"
export PRETTIER_VERSION="${PRETTIER_VERSION:-latest}"

# Vue Engine State
IS_TS="${IS_TS:-false}"
USE_ROUTER="${USE_ROUTER:-true}"
USE_PINIA="${USE_PINIA:-true}"
USE_TAILWIND="${USE_TAILWIND:-true}"
USE_ESLINT="${USE_ESLINT:-true}"
USE_PRETTIER="${USE_PRETTIER:-true}"
USE_DATE_LIB="${USE_DATE_LIB:-false}"
USE_NUMBER_LIB="${USE_NUMBER_LIB:-false}"

vue_engine_menu() {
  echo ""
  local langs=("JavaScript" "TypeScript")
  local lang_choice=0
  select_option "Select Development Language:" "${langs[@]}" || lang_choice=$?
  [[ $lang_choice -eq 1 ]] && IS_TS=true || IS_TS=false

  echo ""
  local features=("Vue Router" "Pinia (State Management)" "Tailwind CSS" "ESLint" "Prettier" "Date Utils (date-fns)" "Currency Utils (numeral)")
  local results=($(select_multiple "Select Project Features:" "${features[@]}"))
  
  USE_ROUTER="${results[0]}"
  USE_PINIA="${results[1]}"
  USE_TAILWIND="${results[2]}"
  USE_ESLINT="${results[3]}"
  USE_PRETTIER="${results[4]}"
  USE_DATE_LIB="${results[5]}"
  USE_NUMBER_LIB="${results[6]}"
}
