#!/bin/bash

# --- Visuals & Styles ---
if [[ -t 1 ]]; then
    tput clear
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    MAGENTA=$(tput setaf 5)
    CYAN=$(tput setaf 6)
    WHITE=$(tput setaf 7)
    BG_BLUE=$(tput setab 4)
    UNDERLINE=$(tput smul)
else
    BOLD=""
    RESET=""
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    MAGENTA=""
    CYAN=""
    WHITE=""
    BG_BLUE=""
    UNDERLINE=""
fi

# --- Logging & UI ---
log_header() { 
    echo -e "\n${BOLD}${BG_BLUE}${WHITE} :: $1 :: ${RESET}" 
}
log_info()   { echo -e " ${CYAN}➜${RESET} $1"; }
log_success(){ echo -e " ${GREEN}${ICON_CHECK}${RESET} $1"; }
log_warn()   { echo -e " ${YELLOW}⚠️  $1${RESET}"; }
log_error()  { echo -e " ${RED}${ICON_CROSS} $1${RESET}" >&2; }

# --- Spinner ---
start_spinner() {
    if [[ ! -t 1 ]]; then
        echo " $1..."
        return
    fi
    tput civis # hide cursor
    local msg="$1"
    set +m
    {
        local -a marks=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
        while true; do
            for mark in "${marks[@]}"; do
                echo -ne "\r${CYAN}${mark}${RESET} ${msg}..."
                sleep 0.1
            done
        done
    } &
    SPINNER_PID=$!
}

stop_spinner() {
    if [[ -n "$SPINNER_PID" ]]; then
        kill "$SPINNER_PID" 2>/dev/null || true
        wait "$SPINNER_PID" 2>/dev/null || true
        SPINNER_PID=""
        echo -ne "\r\033[K" # clear line
    fi
    if [[ -t 1 ]]; then tput cnorm; fi # restore cursor
    if [[ -n "${1:-}" ]]; then
        log_success "$1"
    fi
}

# --- Error Handling ---
fatal_error() {
  stop_spinner # ensure spinner stops if error occurs
  log_error "$1"
  exit 1
}

cleanup() {
  local exit_code=$?
  # Kill spinner if running
  if [[ -n "$SPINNER_PID" ]]; then kill "$SPINNER_PID" 2>/dev/null || true; fi
  if [[ -t 1 ]]; then tput cnorm; fi 
  
  if [ $exit_code -ne 0 ]; then
    echo -e "\n${RED}${ICON_CROSS} Script interrupted/failed. Exit code: $exit_code${RESET}"
  fi
  
  if [[ -t 0 && $exit_code -ne 0 ]]; then
      echo -e "\n${BOLD}Press any key to exit...${RESET}"
      read -n 1 -s -r
  fi
}
trap cleanup EXIT
