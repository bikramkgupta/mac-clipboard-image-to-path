#!/bin/bash
set -euo pipefail

# Clipboard to Path - Save clipboard image and output file path
# https://github.com/bikramkgupta/clipboard-to-path

# Configuration (override with environment variable)
IMAGE_DIR="${CLIPBOARD_IMAGE_DIR:-/tmp/clipboard-images}"

# Create directory if it doesn't exist
mkdir -p "$IMAGE_DIR"

# Check if clipboard contains an image
if ! osascript -e 'clipboard info' 2>/dev/null | grep -qE 'PNGf|TIFF|«class PNGf»|«class TIFF»'; then
    osascript -e 'display notification "No image in clipboard" with title "Clipboard to Path"'
    exit 1
fi

# Generate filename with timestamp
FILENAME="clipboard-$(date +%Y%m%d-%H%M%S).png"
FILEPATH="$IMAGE_DIR/$FILENAME"

# Save clipboard image using AppleScript (built-in, no dependencies)
osascript -e "
    set imgData to the clipboard as «class PNGf»
    set filePath to POSIX file \"$FILEPATH\"
    set fileRef to open for access filePath with write permission
    write imgData to fileRef
    close access fileRef
" 2>/dev/null

# Verify file was created
if [[ ! -f "$FILEPATH" ]]; then
    osascript -e 'display notification "Failed to save image" with title "Clipboard to Path"'
    exit 1
fi

# Show success notification
osascript -e "display notification \"$FILEPATH\" with title \"Image Saved\" sound name \"Pop\""

# Output the path (Automator will copy this to clipboard)
echo -n "$FILEPATH"
