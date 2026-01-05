#!/bin/bash
# test-cases.sh

# Exit on error
set -e

# Base directory for tests
TEST_BASE_DIR="$(pwd)/test-scaffolds"
rm -rf "$TEST_BASE_DIR"
mkdir -p "$TEST_BASE_DIR"

ARCHITECT_PATH="$(pwd)/vue-architect.command"

run_test() {
  local name=$1
  local is_ts=$2
  local router=$3
  local pinia=$4
  local tailwind=$5
  local eslint=$6
  local prettier=$7
  
  echo "----------------------------------------------------"
  echo "TESTING: $name"
  echo "----------------------------------------------------"
  
  export NON_INTERACTIVE=true
  export PROJECT_NAME="$name"
  export PROJECT_DIR="$TEST_BASE_DIR/$name"
  export IS_TS=$is_ts
  export USE_ROUTER=$router
  export USE_PINIA=$pinia
  export USE_TAILWIND=$tailwind
  export USE_ESLINT=$eslint
  export USE_PRETTIER=$prettier
  export USE_DATE_LIB=true
  export USE_NUMBER_LIB=true

  # Run the architect
  bash "$ARCHITECT_PATH"
  
  echo "VERIFYING: $name"
  if [[ -d "$PROJECT_DIR/src" ]]; then
    echo "✅ src directory exists"
  else
    echo "❌ src directory missing"
    exit 1
  fi

  if [[ "$is_ts" == "true" ]]; then
    if [[ -f "$PROJECT_DIR/tsconfig.json" ]]; then
       echo "✅ tsconfig.json exists"
    else
       echo "❌ tsconfig.json missing"
       exit 1
    fi
  fi

  if [[ "$tailwind" == "true" ]]; then
    if [[ -f "$PROJECT_DIR/tailwind.config.js" ]]; then
       echo "✅ tailwind.config.js exists"
    else
       echo "❌ tailwind.config.js missing"
       exit 1
    fi
  fi

  echo "SUCCESS: $name"
  echo ""
}

# Test Case 1: Full TypeScript Project
run_test "full-ts-app" "true" "true" "true" "true" "true" "true"

# Test Case 2: Minimal JavaScript Project
run_test "mini-js-app" "false" "false" "false" "false" "false" "false"

# Test Case 3: Mixed (JS + Tailwind + Router)
run_test "mixed-js-app" "false" "true" "false" "true" "true" "true"

echo "All test cases passed!"
