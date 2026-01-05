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

# --- Templating ---
generate_from_template() {
  local template_path="$1"
  local output_path="$2"
  shift 2
  
  if [[ ! -f "$template_path" ]]; then
    fatal_error "Template not found: $template_path"
  fi

  local content
  content=$(cat "$template_path")
  
  while [[ $# -gt 0 ]]; do
    local key="$1"
    local value="$2"
    # value may contain newlines, so we use a temporary file or a better way to replace
    # Simple sed "s|key|value|g" fails if value has newlines.
    # We can use a python one-liner or perl if available, or just use a loop with bash.
    
    # Using python for robust replacement if available, else fallback to something else
    if command -v python3 &> /dev/null; then
      content=$(python3 -c "import sys; print(sys.argv[1].replace('{{' + sys.argv[2] + '}}', sys.argv[3]), end='')" "$content" "$key" "$value")
    else
      # Fallback for simple cases (one line)
      content=$(echo "$content" | sed "s|{{$key}}|$value|g")
    fi
    shift 2
  done
  
  echo -n "$content" > "$output_path"
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
