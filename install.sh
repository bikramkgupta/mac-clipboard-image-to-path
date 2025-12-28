#!/bin/bash
set -euo pipefail

# Clipboard to Path - Installer
# https://github.com/bikramkgupta/clipboard-to-path

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOW_NAME="Save Clipboard Image.workflow"
SERVICES_DIR="$HOME/Library/Services"
IMAGE_DIR="${CLIPBOARD_IMAGE_DIR:-/tmp/clipboard-images}"

echo "Installing Clipboard to Path..."
echo ""

# Create image directory
mkdir -p "$IMAGE_DIR"
echo "Created image directory: $IMAGE_DIR"

# Create Services directory if it doesn't exist
mkdir -p "$SERVICES_DIR"

# Copy workflow to Services
if [[ -d "$SCRIPT_DIR/$WORKFLOW_NAME" ]]; then
    cp -R "$SCRIPT_DIR/$WORKFLOW_NAME" "$SERVICES_DIR/"
    echo "Installed workflow to: $SERVICES_DIR/$WORKFLOW_NAME"
else
    echo "Error: Workflow not found at $SCRIPT_DIR/$WORKFLOW_NAME"
    exit 1
fi

# Make the standalone script executable (optional, workflow has embedded script)
if [[ -f "$SCRIPT_DIR/clipboard-to-path.sh" ]]; then
    chmod +x "$SCRIPT_DIR/clipboard-to-path.sh"
fi

echo ""
echo "============================================================"
echo ""
echo "  Clipboard to Path installed!"
echo ""
echo "============================================================"
echo ""
echo "  SETUP KEYBOARD SHORTCUT (one-time):"
echo ""
echo "  1. System Settings will open automatically"
echo "  2. Go to: Keyboard > Keyboard Shortcuts > Services"
echo "  3. Find \"Save Clipboard Image\" under General"
echo "  4. Click to assign: Cmd+Shift+C"
echo ""
echo "============================================================"
echo ""
echo "  FOR DOCKER CONTAINERS:"
echo ""
echo "  Add this to your docker-compose.yml:"
echo ""
echo "    volumes:"
echo "      - /tmp/clipboard-images:/tmp/clipboard-images:ro"
echo ""
echo "  Or with docker run:"
echo ""
echo "    docker run -v /tmp/clipboard-images:/tmp/clipboard-images:ro ..."
echo ""
echo "============================================================"
echo ""
echo "  USAGE:"
echo ""
echo "    1. Screenshot (Cmd+Shift+4) or copy any image"
echo "    2. Press Cmd+Shift+C - saves image, path copied"
echo "    3. Paste (Cmd+V) - pastes the path as text"
echo ""
echo "  Images saved to: $IMAGE_DIR"
echo ""
echo "============================================================"
echo ""

# Open System Settings to Keyboard Shortcuts
# Note: The exact URL scheme may vary by macOS version
if [[ "$(sw_vers -productVersion | cut -d. -f1)" -ge 13 ]]; then
    # macOS Ventura (13) and later
    open "x-apple.systempreferences:com.apple.Keyboard-Settings.extension"
else
    # macOS Monterey (12) and earlier
    open "x-apple.systempreferences:com.apple.preference.keyboard?Shortcuts"
fi

echo "System Settings opened. Please assign the keyboard shortcut."
