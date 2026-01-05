#!/bin/bash

# --- Shared Utilities ---

check_command() {
  if ! command -v "$1" &> /dev/null; then
    fatal_error "Missing required command: $1"
  fi
}

validate_name() {
  if [[ ! "$1" =~ ^[a-z0-9_-]+$ ]]; then echo "invalid"; else echo "valid"; fi
}

get_timestamp() {
  date +%s
}

# --- Templating Engine ---
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
    # Using python for robust replacement if available
    if command -v python3 &> /dev/null; then
      content=$(python3 -c "import sys; print(sys.argv[1].replace('{{' + sys.argv[2] + '}}', sys.argv[3]), end='')" "$content" "$key" "$value")
    else
      # Fallback to sed for simpler cases
      content=$(echo "$content" | sed "s|{{$key}}|$value|g")
    fi
    shift 2
  done
  
  echo -n "$content" > "$output_path"
}
