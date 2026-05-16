# Project: Q - Advanced MPV Queue Manager

A feature-rich, interactive CLI music and video queue manager for `mpv`. Designed for Termux but portable to any Linux environment.

## 🚀 One-Command Install

Run this in your terminal:

```bash
curl -sSL https://raw.githubusercontent.com/{{USER}}/q/main/install.sh | bash
```

## ✨ Features

- **Interactive UI:** Powered by `fzf` for smooth track selection and management.
- **Synced Playback:** Seamlessly control `mpv` via IPC.
- **Smart Search:** Instant results from YouTube and Soundcloud.
- **Auto-Discovery:** 24/7 related track suggestions.
- **Playlist Management:** Save, load, and explore custom playlists.
- **Audio FX:** Built-in support for audio filters and effects.
- **Portable:** Single installation script that handles all dependencies.

## 📦 Dependencies

The installer automatically checks for and installs:
- `mpv`
- `yt-dlp`
- `fzf`
- `jq`
- `netcat` (nc)
- `lsd` (optional, for icons)

## 🛠️ Usage

```bash
q <query>        # Search and add
q -p             # Play/Pause
q -next          # Skip track
q -list          # Interactive explorer
```

See `q -h` for full documentation.
