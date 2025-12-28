Clipboard Image to Path (macOS)

 A simple macOS utility that saves clipboard images to a file and copies the path to clipboard. Zero dependencies, uses native Automator.

 ---
 Problem

 Many CLI tools (Codex, Gemini CLI, terminals inside containers) don't support pasting images. You can only paste text.

 Solution

 A keyboard shortcut (Cmd+Shift+I) that:
 1. Takes the image from clipboard
 2. Saves it to a configured folder
 3. Replaces clipboard with the file path

 Now you can paste the path anywhere that accepts text.

 ---
 User Workflow

 Cmd+Shift+4              → Screenshot to clipboard (normal macOS)
 Cmd+Shift+I              → Save image, get path in clipboard
 Cmd+V                    → Paste path into any tool

 Normal Cmd+C/Cmd+V workflow is unchanged - only Cmd+Shift+I triggers this.

 ---
 Use Cases

 | Tool                        | How it works                       |
 |-----------------------------|------------------------------------|
 | Claude Code in DevContainer | Mount the image folder, paste path |
 | Codex CLI                   | Paste path directly                |
 | Gemini CLI                  | Paste path directly                |
 | Any terminal                | Paste path (text works everywhere) |
 | Remote containers           | Mount the folder as volume         |

 ---
 Technical Design

 Components

 1. Shell script (clipboard-to-path.sh)
   - Uses osascript (built-in AppleScript) to read clipboard image
   - Saves as PNG with timestamp
   - Outputs the file path
 2. Automator Quick Action (Save Clipboard Image.workflow)
   - Wraps the shell script
   - Copies output path to clipboard
   - Can be assigned keyboard shortcut
 3. Installation script (install.sh)
   - Copies workflow to ~/Library/Services/
   - Creates image output folder
   - Prints instructions for keyboard shortcut setup

 Configuration

 | Setting         | Default                       | Description          |
 |-----------------|-------------------------------|----------------------|
 | IMAGE_PATH      | ~/.clipboard-images           | Where to save images |
 | FILENAME_FORMAT | clipboard-YYYYMMDD-HHMMSS.png | Naming pattern       |

 ---
 Repository Structure

 clipboard-to-path/
 ├── README.md                 # Documentation with GIFs
 ├── install.sh               # One-line installer
 ├── uninstall.sh             # Clean removal
 ├── clipboard-to-path.sh     # Core shell script
 └── Save Clipboard Image.workflow/  # Automator workflow
     └── Contents/
         ├── Info.plist
         └── document.wflow

 ---
 Core Script (clipboard-to-path.sh)

 #!/bin/bash
 set -euo pipefail

 # Configuration
 IMAGE_DIR="${CLIPBOARD_IMAGE_DIR:-$HOME/.clipboard-images}"
 mkdir -p "$IMAGE_DIR"

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
 "

 # Output the path (Automator will copy this to clipboard)
 echo -n "$FILEPATH"

 ---
 Installation

 One-liner

 curl -fsSL https://raw.githubusercontent.com/USER/clipboard-to-path/main/install.sh | bash

 Manual setup for keyboard shortcut

 1. Open System Settings > Keyboard > Keyboard Shortcuts > Services
 2. Find "Save Clipboard Image" under General
 3. Assign Cmd+Shift+I (or your preferred shortcut)

 ---
 DevContainer Integration

 Mount the image folder in your docker-compose.yml:

 services:
   app:
     volumes:
       - ~/.clipboard-images:/home/vscode/clipboard:cached

 Now paths like ~/.clipboard-images/clipboard-20251228-143052.png are accessible inside the container at
 /home/vscode/clipboard/clipboard-20251228-143052.png.

 Tip: The host path works directly in most cases. For container tools, adjust the path prefix.

 ---
 Features

 - Zero dependencies - Uses macOS built-in AppleScript
 - Non-invasive - Normal Cmd+C/V workflow unchanged
 - Universal - Works with any tool that accepts text
 - Container-ready - Just mount the folder
 - Simple - One shortcut, one action

 ---
 Implementation Notes for Claude Code

 When building this repo:

 1. Start with the shell script - Test osascript clipboard extraction works
 2. Create Automator workflow - Quick Action that runs script, copies output
 3. Write install.sh - Copy workflow, create folder, print instructions
 4. Add README - Include demo GIF, installation steps, use cases
 5. Test end-to-end - Screenshot → Cmd+Shift+I → paste path in terminal
╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌
