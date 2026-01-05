#!/bin/bash

print_banner() {
    clear
    echo -e "${BOLD}"
    # Custom Vue-themed ASCII Art
    cat << EOF
${GREEN}  __     __${BLUE}  _    _  ${GREEN}  _______  ${RESET}
${GREEN}  \\ \\   / /${BLUE} | |  | | ${GREEN} |  _____| ${RESET}
${GREEN}   \\ \\ / / ${BLUE} | |  | | ${GREEN} | |___    ${RESET}
${GREEN}    \\ V /  ${BLUE} | |  | | ${GREEN} |  ___|   ${RESET}
${GREEN}     \\_/   ${BLUE}  \\____/  ${GREEN} | |_____  ${RESET}
${GREEN}           ${BLUE}          ${GREEN} |_______| ${RESET}
EOF
    echo -e "${RESET}"
    echo -e "${RESET}"
    echo -e "${BOLD}${WHITE}    Vue.js Architect${RESET}"
    echo -e "${BLUE}    ---------------------------${RESET}"
    echo -e "${CYAN}    v1.0.0 ${WHITE}• ${CYAN}By Jiss Johnson${RESET}"
    echo -e "${BLUE}    ---------------------------${RESET}"
    echo -e "    ${WHITE}Opinionated ${CYAN}•${WHITE} Scalable ${CYAN}•${WHITE} Production-Ready${RESET}\n"
}

select_language_opt() {
  local options=("JavaScript" "TypeScript")
  local selection=0
  
  tput civis # Hide cursor
  
  while true; do
    # Print options
    for ((i=0; i<${#options[@]}; i++)); do
      tput el
      if [[ $i -eq $selection ]]; then
        echo -e "${GREEN}❯ ${options[$i]}${RESET}"
      else
        echo -e "  ${options[$i]}"
      fi
    done
    
    # Wait for input
    read -r -s -n 1 key < /dev/tty
    
    if [[ "$key" == $'\x1b' ]]; then
        read -r -s -n 2 key < /dev/tty
        if [[ "$key" == "[A" ]]; then # Up
            ((selection--))
            if [[ $selection -lt 0 ]]; then selection=1; fi
        elif [[ "$key" == "[B" ]]; then # Down
             ((selection++))
             if [[ $selection -gt 1 ]]; then selection=0; fi
        fi
        # Move up to redraw
        tput cuu 2
    elif [[ "$key" == "" ]]; then # Enter
        break
    else
        # Any other key, just redraw
        tput cuu 2
    fi
  done
  
  tput cnorm # Restore cursor
  return $selection
}

validate_project_name() {
  if [[ ! "$1" =~ ^[a-z0-9_-]+$ ]]; then echo "invalid"; else echo "valid"; fi
}

select_features_opt() {
  local options=("Vue Router" "Pinia" "Tailwind CSS" "ESLint" "Prettier" "Date Library (date-fns)" "Number Library (numeral)")
  local checked=(1 1 1 1 1 1 1)
  local selection=0
  
  tput civis # Hide cursor
  
  while true; do
    # Print options
    for ((i=0; i<${#options[@]}; i++)); do
      tput el
      local prefix="[ ]"
      if [[ ${checked[$i]} -eq 1 ]]; then prefix="[x]"; fi
      
      if [[ $i -eq $selection ]]; then
        echo -e "${GREEN}❯ $prefix ${options[$i]}${RESET}"
      else
        echo -e "  $prefix ${options[$i]}"
      fi
    done
    
    echo -e "${CYAN}  (Space to toggle, Enter to confirm)${RESET}"
    
    IFS= read -rsn1 key < /dev/tty
    
    if [[ "$key" == $'\x1b' ]]; then
        read -rsn2 key < /dev/tty
        if [[ "$key" == "[A" ]]; then # Up
            ((selection--))
            if [[ $selection -lt 0 ]]; then selection=$((${#options[@]} - 1)); fi
        elif [[ "$key" == "[B" ]]; then # Down
             ((selection++))
             if [[ $selection -ge ${#options[@]} ]]; then selection=0; fi
        fi
        # Move up to redraw
        tput cuu $((${#options[@]} + 1))
    elif [[ "$key" == "" ]]; then # Enter
        break
    elif [[ "$key" == " " ]]; then # Space
        if [[ ${checked[$selection]} -eq 1 ]]; then
            checked[$selection]=0
        else
            checked[$selection]=1
        fi
        tput cuu $((${#options[@]} + 1))
    else
        # Any other key, just redraw
        tput cuu $((${#options[@]} + 1))
    fi
  done
  
  tput cnorm # Restore cursor
  
  if [[ ${checked[0]} -eq 1 ]]; then USE_ROUTER=true; else USE_ROUTER=false; fi
  if [[ ${checked[1]} -eq 1 ]]; then USE_PINIA=true; else USE_PINIA=false; fi
  if [[ ${checked[2]} -eq 1 ]]; then USE_TAILWIND=true; else USE_TAILWIND=false; fi
  if [[ ${checked[3]} -eq 1 ]]; then USE_ESLINT=true; else USE_ESLINT=false; fi
  if [[ ${checked[4]} -eq 1 ]]; then USE_PRETTIER=true; else USE_PRETTIER=false; fi
  if [[ ${checked[5]} -eq 1 ]]; then USE_DATE_LIB=true; else USE_DATE_LIB=false; fi
  if [[ ${checked[6]} -eq 1 ]]; then USE_NUMBER_LIB=true; else USE_NUMBER_LIB=false; fi
}

get_user_input() {
  if [[ -n "${1:-}" ]]; then PROJECT_NAME="$1"; fi

  while [[ -z "$PROJECT_NAME" ]]; do
    print_banner
    echo -e "${BOLD}${YELLOW}?${RESET} ${BOLD}Enter project name ${RESET}${CYAN}(lowercase, no spaces)${RESET}: "
    read -r input < /dev/tty
    
    if [[ -z "$input" ]]; then
       log_warn "Name cannot be empty."
    elif [[ "$(validate_project_name "$input")" == "invalid" ]]; then
       log_warn "Invalid name. Use [a-z0-9_-] only."
    else
       PROJECT_NAME="$input"
    fi
  done
  PROJECT_DIR="$(pwd)/$PROJECT_NAME"

  # Language Selection
  echo ""
  echo -e "${BOLD}${YELLOW}?${RESET} ${BOLD}Select Language:${RESET} ${CYAN}(Use arrow keys)${RESET}"
  select_language_opt
  local lang_choice=$?
  
  if [[ "$lang_choice" -eq 1 ]]; then
    IS_TS=true
  else
    IS_TS=false
  fi

  # Feature Selection
  echo ""
  echo -e "${BOLD}${YELLOW}?${RESET} ${BOLD}Select Features:${RESET}"
  select_features_opt
}

print_summary() {
  local end_time=$(date +%s)
  local duration=$((end_time - START_TIME))

  echo ""
  echo -e "${GREEN}====================================================${RESET}"
  echo -e "${BOLD}${GREEN}  ${ICON_ROCKET} Project Scaffolding Complete in ${duration}s! ${RESET}"
  echo -e "${GREEN}====================================================${RESET}"
  echo ""
  echo -e "${BOLD}${CYAN}Getting Started:${RESET}"
  echo -e "  1. ${YELLOW}cd ${PROJECT_NAME}${RESET}"
  echo -e "  2. ${YELLOW}npm run dev${RESET}"
  echo ""
  
  if [[ -z "${1:-}" ]]; then 
      echo -e "${MAGENTA}Press any key to close this window...${RESET}"
      read -n 1 -s -r
  fi
}

print_support() {
  echo -e "\n${BOLD}${MAGENTA}  ☕ Enjoying Vue Architect?${RESET}"
  echo -e "${CYAN}  Support the development: ${UNDERLINE}${BMC_LINK}${RESET}\n"
}
