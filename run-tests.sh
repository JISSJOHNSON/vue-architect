#!/bin/bash

# ==============================================================================
#  Vue Architect Test Suite
#  ------------------------------------------------------------------------------
#  Automated testing for different build tools and configurations.
# ==============================================================================

set -o errexit
set -o nounset
set -o pipefail

# Path to the main architect script
ARCHITECT_CMD="./architect.sh"
TEST_ROOT="$(pwd)/test_output"

# Cleanup previous tests
rm -rf "$TEST_ROOT"
mkdir -p "$TEST_ROOT"

log_header() { echo -e "\n\033[1;35m==>\033[0m \033[1;37m$1\033[0m"; }
log_success() { echo -e "  \033[0;32m✓\033[0m  $1"; }

run_test() {
    local name="$1"
    local build_tool="$2"
    local is_ts="$3"
    
    log_header "Testing: $name (Tool: $build_tool, TS: $is_ts)"
    
    export SILENT_MODE="true"
    export PROJECT_NAME="$name"
    export PROJECT_DIR="$TEST_ROOT/$name"
    export BUILD_TOOL="$build_tool"
    export IS_TS="$is_ts"
    
    # Run scaffolding
    bash "$ARCHITECT_CMD" > /dev/null
    
    # Check if project was created
    if [[ -d "$PROJECT_DIR" ]]; then
        log_success "Scaffolded successfully"
    else
        echo "Error: Project directory not created"
        exit 1
    fi
    
    # Check for build tool specific config
    case $build_tool in
        "vite") [[ -f "$PROJECT_DIR/vite.config.js" || -f "$PROJECT_DIR/vite.config.ts" ]] && log_success "Vite config found" ;;
        "webpack") [[ -f "$PROJECT_DIR/webpack.config.cjs" ]] && log_success "Webpack config found" ;;
        "rollup") [[ -f "$PROJECT_DIR/rollup.config.js" || -f "$PROJECT_DIR/rollup.config.mjs" ]] && log_success "Rollup config found" ;;
    esac
    
    # Run npm install & build
    log_header "Building: $name"
    cd "$PROJECT_DIR"
    npm install --legacy-peer-deps > /dev/null 2>&1
    npm run build > /dev/null 2>&1
    log_success "Build completed successfully"

    # Smoke test: Start dev server and check for immediate crashes
    log_header "Dev Server Smoke Test: $name"
    # Run dev script in background, wait 5 seconds, then kill it
    # We check if the process is still running or at least didn't exit with 1 immediately
    npm run dev > dev_server.log 2>&1 &
    DEV_PID=$!
    sleep 7
    if kill -0 $DEV_PID 2>/dev/null; then
        kill $DEV_PID
        log_success "Dev server started successfully (smoke test passed)"
    else
        wait $DEV_PID || local exit_code=$?
        if [[ ${exit_code:-0} -eq 0 ]]; then
             # Some tools might exit 0 if they finish tasks (like rollup -c -w if nothing to watch?)
             log_success "Dev server finished/started (smoke test passed)"
        else
             log_warn "Dev server failed to start. Log output:"
             cat dev_server.log
             exit 1
        fi
    fi
    cd "../../"
}

# --- Test Cases ---

# 1. Vite + JS (Standard)
run_test "vite-js-app" "vite" "false"

# 2. Vite + TS
run_test "vite-ts-app" "vite" "true"

# 3. Webpack + JS
run_test "webpack-js-app" "webpack" "false"

# 4. Rollup + JS
run_test "rollup-js-app" "rollup" "false"

log_header "All Tests Passed!"
echo -e "\nTest artifacts are available in: $TEST_ROOT"
