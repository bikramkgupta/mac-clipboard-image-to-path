# Clipboard to Path

Save clipboard images to a file and get the path. Zero dependencies, uses native macOS Automator.

> **Your regular Cmd+C / Cmd+V workflow is unchanged.** This tool complements it - only Cmd+Shift+C triggers the save-to-path action.

## The Problem

Image paste does not work inside devcontainers on Mac. Also, some CLI tools and terminals don't support pasting images directly - only text.

## The Solution

Press **Cmd+Shift+C** to save clipboard image to `/tmp/clipboard-images/` and copy the path. Paste anywhere.

For Docker: mount `-v /tmp/clipboard-images:/tmp/clipboard-images:ro` and the same path works inside containers.

## Demo

[![Watch the demo](https://img.shields.io/badge/▶_Watch_Demo-1.2_min-blue?style=for-the-badge)](https://share.descript.com/view/YWLWYSbQNPo)

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/bikramkgupta/mac-clipboard-image-to-path/main/install.sh | bash
```

After install, assign the keyboard shortcut:
1. System Settings > Keyboard > Keyboard Shortcuts > Services
2. Find "Save Clipboard Image" under General
3. Assign: **Cmd+Shift+C**

## Usage

```
Cmd+Shift+4              Screenshot to clipboard (normal macOS)
Cmd+Shift+C              Save image, get path in clipboard
Cmd+V                    Paste path into any tool
```

### Smart Paste Behavior

Some CLI tools are smart enough to detect image paths and display the image automatically:

| Tool | What happens when you paste |
|------|----------------------------|
| **Claude Code** | Displays the image |
| **Codex CLI** | Displays the image |
| **Gemini CLI** | Pastes the path (reads file) |
| **Any terminal** | Pastes the path as text |

## Docker / DevContainers

The images are saved to `/tmp/clipboard-images/` - the same path on both host and container.

Add this to your `docker-compose.yml`:

```yaml
volumes:
  - /tmp/clipboard-images:/tmp/clipboard-images:ro
```

Or with `docker run`:

```bash
docker run -v /tmp/clipboard-images:/tmp/clipboard-images:ro your-image
```

Now paths like `/tmp/clipboard-images/clipboard-20251228-143052.png` work both on your Mac and inside containers.

## Configuration

Override the default image directory with an environment variable:

```bash
export CLIPBOARD_IMAGE_DIR=~/.clipboard-images
```

Then reinstall to apply the change to the workflow.

## How It Works

| Component | What it does |
|-----------|--------------|
| Automator Quick Action | Triggers on Cmd+Shift+I from any app |
| Embedded shell script | Saves clipboard image, shows notification |
| AppleScript (built-in) | Reads image data from clipboard |

No external dependencies. Uses only built-in macOS tools.

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/bikramkgupta/mac-clipboard-image-to-path/main/uninstall.sh | bash
```

Or manually:
```bash
rm -rf ~/Library/Services/Save\ Clipboard\ Image.workflow
```

## Troubleshooting

**"No image in clipboard" notification**
- Make sure you have an image copied (Cmd+Shift+4 for screenshot, or Cmd+C on an image)

**Shortcut doesn't work**
- Check System Settings > Keyboard > Keyboard Shortcuts > Services
- Make sure "Save Clipboard Image" is enabled and has Cmd+Shift+C assigned

**Path doesn't work in container**
- Ensure you mounted the volume: `-v /tmp/clipboard-images:/tmp/clipboard-images:ro`
- The path must be identical on host and container

## License

MIT
