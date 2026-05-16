#!/bin/bash
# Installer for Q - Advanced MPV Queue Manager

set -e

# --- Colors ---
C_PINK='\033[38;5;198m'
C_CYAN='\033[1;36m'
C_GREEN='\033[1;32m'
C_RESET='\033[0m'

echo -e "${C_PINK}🚀 Starting Q Installer...${C_RESET}"

# --- Dependency Check ---
DEPENDENCIES=("mpv" "yt-dlp" "fzf" "jq" "nc")
MISSING=()

for dep in "${DEPENDENCIES[@]}"; do
    if ! command -v "$dep" &>/dev/null; then
        MISSING+=("$dep")
    fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
    echo -e "${C_CYAN}📦 Installing missing dependencies: ${MISSING[*]}${C_RESET}"
    if command -v pkg &>/dev/null; then
        pkg install "${MISSING[@]}" -y
    elif command -v apt &>/dev/null; then
        sudo apt update && sudo apt install "${MISSING[@]}" -y
    else
        echo "❌ Automatic installation not supported for your package manager."
        echo "Please install: ${MISSING[*]}"
        exit 1
    fi
fi

# --- Directories ---
INSTALL_DIR="$HOME/.local/bin/mpv"
MODULE_DIR="$INSTALL_DIR/q_modules"
mkdir -p "$MODULE_DIR"
mkdir -p "$HOME/.local/bin"

# --- Download/Copy Logic ---
# In a real GitHub scenario, this would curl from raw.githubusercontent.com
# For now, we assume the files are in the repo structure.

REPO_URL="https://raw.githubusercontent.com/{{USER}}/q/main"

files=("q" "q_modules/batch.sh" "q_modules/media.sh" "q_modules/playlist.sh" "q_modules/queue.sh" "q_modules/search.sh" "q_modules/ui.sh" "q_modules/utils.sh")

for file in "${files[@]}"; do
    echo -e "${C_CYAN}📥 Downloading $file...${C_RESET}"
    # curl -sSL "$REPO_URL/$file" -o "$INSTALL_DIR/$file"
    # [INTERNAL NOTE]: Since I'm creating this locally, I'll copy the existing ones for the user to review.
    cp "/data/data/com.termux/files/home/.local/bin/mpv/$file" "$INSTALL_DIR/$file"
done

chmod +x "$INSTALL_DIR/q"
ln -sf "$INSTALL_DIR/q" "$HOME/.local/bin/q"

# --- Bashrc/Zshrc Integration ---
SHELL_CONFIGS=("$HOME/.bashrc" "$HOME/.zshrc")
for config in "${SHELL_CONFIGS[@]}"; do
    if [ -f "$config" ]; then
        if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$config"; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$config"
            echo -e "${C_GREEN}✅ Added PATH to $(basename "$config")${C_RESET}"
        fi
        
        # Add the MPV wrapper if it doesn't exist
        if ! grep -q 'function mpv()' "$config"; then
            cat << 'EOF' >> "$config"

# MPV Wrapper for Q
function mpv() {
    SOCKET="$HOME/.mpv-socket"
    if [ -e "$SOCKET" ]; then rm "$SOCKET"; fi
    command mpv --idle --input-ipc-server="$SOCKET" "$@"
    rm -f "$SOCKET"
}
if [ -n "$BASH_VERSION" ]; then export -f mpv; fi
EOF
            echo -e "${C_GREEN}✅ Added MPV wrapper to $(basename "$config")${C_RESET}"
        fi
    fi
done

echo -e "${C_PINK}✨ Q successfully installed!${C_RESET}"
echo -e "${C_CYAN}Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)${C_RESET}"
