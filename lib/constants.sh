#!/bin/bash

# --- Configuration & Constants ---
readonly MIN_NODE_VERSION=18
readonly VUE_VERSION="latest"
readonly VITE_VERSION="^6.0.0"
readonly TAILWIND_VERSION="^3.4.1"
readonly PINIA_VERSION="latest"
readonly ROUTER_VERSION="latest"
readonly ESLINT_VERSION="latest"
readonly PRETTIER_VERSION="latest"
readonly BMC_LINK="https://www.buymeacoffee.com/jissjohnson"

# Global State
PROJECT_NAME=""
PROJECT_DIR=""
IS_TS=false
USE_ROUTER=true
USE_PINIA=true
USE_TAILWIND=true
USE_ESLINT=true
USE_PRETTIER=true
USE_DATE_LIB=true
USE_NUMBER_LIB=true
START_TIME=$(date +%s)
SPINNER_PID=""
LAST_SELECTION=0

# Icons
ICON_CHECK="✅"
ICON_CROSS="❌"
ICON_ROCKET="🚀"
ICON_PACKAGE="📦"
ICON_GEAR="⚙️"
ICON_FOLDER="📂"
ICON_INFO="ℹ️"
