#!/bin/bash
set -euo pipefail

# Clipboard to Path - Uninstaller
# https://github.com/bikramkgupta/clipboard-to-path

WORKFLOW_NAME="Save Clipboard Image.workflow"
SERVICES_DIR="$HOME/Library/Services"
IMAGE_DIR="${CLIPBOARD_IMAGE_DIR:-/tmp/clipboard-images}"

echo "Uninstalling Clipboard to Path..."
echo ""

# Remove workflow
if [[ -d "$SERVICES_DIR/$WORKFLOW_NAME" ]]; then
    rm -rf "$SERVICES_DIR/$WORKFLOW_NAME"
    echo "Removed workflow from: $SERVICES_DIR/$WORKFLOW_NAME"
else
    echo "Workflow not found (already removed or never installed)"
fi

# Ask about image directory
if [[ -d "$IMAGE_DIR" ]]; then
    echo ""
    read -p "Remove saved images at $IMAGE_DIR? (y/N) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$IMAGE_DIR"
        echo "Removed image directory: $IMAGE_DIR"
    else
        echo "Kept image directory: $IMAGE_DIR"
    fi
fi

echo ""
echo "Clipboard to Path uninstalled."
echo ""
echo "Note: The keyboard shortcut in System Settings will be removed"
echo "automatically since the workflow no longer exists."
