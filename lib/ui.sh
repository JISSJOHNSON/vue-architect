#!/bin/bash

print_banner() {
    clear
    # Premium Gradient Banner
    echo -e "${GREEN}"
    cat << "EOF"
   __   __             ___               _      _  _              _   
   \ \ / /_  _ ___    / _ \ _ __ ___  __| |_ (_) |__ ___  ___| |_ 
    \ V /| || / -_)  / ___ \ '_ / __|/ _` | ' \| / _ / __| (__|  _|
     \_/  \_,_\___| /_/   \_\_| \___|\__,_|_||_|_\___|___|\___|\__|
EOF
    echo -e "${RESET}"
    echo -e "    ${BOLD}${WHITE}The Professional Vue.js Scaffold${RESET}"
    echo -e "    ${BLUE}Created by ${CYAN}${UNDERLINE}https://jissjohnson.info${RESET}"
    echo -e "    ${MAGENTA}☕ Support: ${UNDERLINE}${BMC_LINK}${RESET}"
    echo -e "    ${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
    sleep 0.2
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
        echo -e "  ${GREEN}▶ ${BOLD}${WHITE}${options[$i]}${RESET}"
      else
        echo -e "    ${WHITE}${options[$i]}${RESET}"
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
        echo -e "\n  ${BLUE}Selected: ${BOLD}${WHITE}${options[$selection]}${RESET}"
        break
    else
        tput cuu 2
    fi
  done
  
  tput cnorm # Restore cursor
  LAST_SELECTION=$selection
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
      local prefix="○"
      if [[ ${checked[$i]} -eq 1 ]]; then 
        prefix="${GREEN}●${RESET}"
      else
        prefix="${WHITE}○${RESET}"
      fi
      
      if [[ $i -eq $selection ]]; then
        echo -e "  ${BLUE}▶${RESET} $prefix ${BOLD}${WHITE}${options[$i]}${RESET}"
      else
        echo -e "    $prefix ${WHITE}${options[$i]}${RESET}"
      fi
    done
    
    echo -e "\n  ${CYAN}↕ Arrow Keys  ${WHITE}• ${CYAN}⎵ Space to toggle  ${WHITE}• ${CYAN}↵ Enter to confirm${RESET}"
    
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
        tput cuu $((${#options[@]} + 2))
    elif [[ "$key" == "" ]]; then # Enter
        break
    elif [[ "$key" == " " ]]; then # Space
        if [[ ${checked[$selection]} -eq 1 ]]; then
            checked[$selection]=0
        else
            checked[$selection]=1
        fi
        tput cuu $((${#options[@]} + 2))
    else
        tput cuu $((${#options[@]} + 2))
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

select_location_opt() {
  local options=("Current Directory (./)" "New Sub-directory" "Custom Path")
  local selection=0
  
  tput civis
  while true; do
    for ((i=0; i<${#options[@]}; i++)); do
      tput el
      if [[ $i -eq $selection ]]; then
        echo -e "  ${GREEN}▶ ${BOLD}${WHITE}${options[$i]}${RESET}"
      else
        echo -e "    ${WHITE}${options[$i]}${RESET}"
      fi
    done
    
    read -r -s -n 1 key < /dev/tty
    if [[ "$key" == $'\x1b' ]]; then
        read -r -s -n 2 key < /dev/tty
        if [[ "$key" == "[A" ]]; then
            ((selection--)); if [[ $selection -lt 0 ]]; then selection=2; fi
        elif [[ "$key" == "[B" ]]; then
             ((selection++)); if [[ $selection -gt 2 ]]; then selection=0; fi
        fi
        tput cuu 3
    elif [[ "$key" == "" ]]; then break
    else tput cuu 3
    fi
  done
  tput cnorm
  LAST_SELECTION=$selection
}

get_user_input() {
  if [[ "${NON_INTERACTIVE:-false}" == "true" ]]; then
    log_info "Running in non-interactive mode..."
    if [[ -z "$PROJECT_NAME" ]]; then PROJECT_NAME="vue-app-$(date +%s)"; fi
    if [[ -z "$PROJECT_DIR" ]]; then PROJECT_DIR="$(pwd)/$PROJECT_NAME"; fi
    return
  fi

  print_banner
  
  # Location Selection
  echo -e "  ${BOLD}${BLUE}?${RESET} ${BOLD}${WHITE}Where should we architect your project?${RESET}"
  select_location_opt
  local loc_choice=$LAST_SELECTION
  
  if [[ "$loc_choice" -eq 0 ]]; then
    PROJECT_DIR=$(pwd)
    PROJECT_NAME=$(basename "$PROJECT_DIR")
    if [[ "$PROJECT_NAME" == "." ]]; then PROJECT_NAME=$(basename "$(pwd -P)"); fi
  elif [[ "$loc_choice" -eq 2 ]]; then
    while true; do
      echo -en "\n  ${BOLD}${BLUE}?${RESET} ${BOLD}${WHITE}Target Path: ${RESET}${CYAN}"
      read -r input < /dev/tty
      echo -e "${RESET}"
      
      if [[ -z "$input" ]]; then
        log_warn "Path cannot be empty."
        continue
      fi
      local expanded_path="${input/#\~/$HOME}"
      if [[ "$expanded_path" != /* ]]; then expanded_path="$(pwd)/$expanded_path"; fi
      PROJECT_DIR="$expanded_path"
      PROJECT_NAME=$(basename "$PROJECT_DIR")
      break
    done
  else
    if [[ -n "${1:-}" ]]; then PROJECT_NAME="$1"; fi
    while [[ -z "$PROJECT_NAME" ]]; do
      echo -en "\n  ${BOLD}${BLUE}?${RESET} ${BOLD}${WHITE}Project Identifier: ${RESET}${CYAN}"
      read -r input < /dev/tty
      echo -e "${RESET}"
      
      if [[ -z "$input" ]]; then
         log_warn "Name cannot be empty."
      elif [[ "$(validate_project_name "$input")" == "invalid" ]]; then
         log_warn "Invalid name. Use lowercase, numbers, and dashes only."
      else
         PROJECT_NAME="$input"
      fi
    done
    PROJECT_DIR="$(pwd)/$PROJECT_NAME"
  fi

  # Language Selection
  echo ""
  echo -e "  ${BOLD}${BLUE}?${RESET} ${BOLD}${WHITE}Select Development Language:${RESET}"
  select_language_opt
  [[ $LAST_SELECTION -eq 1 ]] && IS_TS=true || IS_TS=false

  # Feature Selection
  echo ""
  echo -e "  ${BOLD}${BLUE}?${RESET} ${BOLD}${WHITE}Select Project Features:${RESET}"
  select_features_opt
}

print_summary() {
  local end_time=$(date +%s)
  local duration=$((end_time - START_TIME))

  echo -e "\n  ${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  typewriter "  ${BOLD}${GREEN}🚀 Scaffolding Completed Successfully in ${duration}s!${RESET}" 0.01
  echo -e "  ${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
  
  echo -e "  ${BOLD}${WHITE}Quick Start Steps:${RESET}"
  echo -e "    ${CYAN}1.${RESET} cd ${PROJECT_NAME}"
  echo -e "    ${CYAN}2.${RESET} npm run dev\n"
  
  if [[ -z "${1:-}" && "${NON_INTERACTIVE:-false}" != "true" ]]; then 
      echo -e "  ${MAGENTA}${BOLD}Press any key to exit architect...${RESET}"
      read -n 1 -s -r
  fi
}

print_support() {
  echo -e "  ${BOLD}${WHITE}Enjoying Vue Architect?${RESET}"
  echo -e "  ${BLUE}Support: ${UNDERLINE}${BMC_LINK}${RESET}\n"
}
