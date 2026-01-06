#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# ==============================================================================
#  Vue Architect Build Script
#  ------------------------------------------------------------------------------
#  Bundles the entire application into a single self-extracting executable.
# ==============================================================================

# Directories
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$SOURCE_DIR/dist"
STAGING_DIR="$DIST_DIR/staging"
OUTPUT_FILE="$DIST_DIR/vue-architect"

echo "Building Vue Architect..."

# 1. Prepare Disribution Directory
rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"
mkdir -p "$STAGING_DIR"

# 2. Copy Source Files
echo "Copying source files..."
cp "$SOURCE_DIR/architect.sh" "$STAGING_DIR/"
cp -r "$SOURCE_DIR/core" "$STAGING_DIR/"
cp -r "$SOURCE_DIR/engines" "$STAGING_DIR/"
cp -r "$SOURCE_DIR/resources" "$STAGING_DIR/"
cp "$SOURCE_DIR/LICENSE" "$STAGING_DIR/" 2>/dev/null || true

# 3. Create Payload Script
echo "Creating payload script..."
cat > "$OUTPUT_FILE" << 'EOF'
#!/bin/bash
export ARCHITECT_ROOT=$(mktemp -d /tmp/vue-architect.XXXXXX)

cleanup() {
    rm -rf "$ARCHITECT_ROOT"
}
trap cleanup EXIT

# Find the start of the archive
ARCHIVE=$(awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0; }' "$0")

# Extract the archive
tail -n +$ARCHIVE "$0" | tar xz -C "$ARCHITECT_ROOT"

# Execute the main script
# Pass all arguments to the internal script
bash "$ARCHITECT_ROOT/architect.sh" "$@"

exit 0

__ARCHIVE_BELOW__
EOF

# 4. Append Archive
echo "Compressing and appending archive..."
tar cz -C "$STAGING_DIR" . >> "$OUTPUT_FILE"

# 5. Finalize
chmod +x "$OUTPUT_FILE"
rm -rf "$STAGING_DIR"

echo "Build complete! Executable created at: $OUTPUT_FILE"
