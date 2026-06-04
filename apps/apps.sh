#!/usr/bin/env bash
set -euo pipefail

log()     { echo -e "\033[0;36m[apps]\033[0m $*"; }
ok()      { echo -e "\033[0;32m[ ok]\033[0m $*"; }
warn()    { echo -e "\033[1;33m[warn]\033[0m $*"; }
skipped() { echo -e "\033[0;90m[--]\033[0m $1 já instalado — pulando."; }

# ── Flatpak ───────────────────────────────────────────────────────────
if command -v flatpak &>/dev/null; then
  skipped "Flatpak"
else
  log "Instalando Flatpak..."
  sudo apt-get install -y flatpak
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# ── Discord ───────────────────────────────────────────────────────────
if flatpak list 2>/dev/null | grep -q "com.discordapp.Discord" || \
   dpkg -l discord &>/dev/null 2>&1 || command -v discord &>/dev/null; then
  skipped "Discord"
else
  log "Instalando Discord via Flatpak..."
  flatpak install -y flathub com.discordapp.Discord && ok "Discord instalado!" || warn "Falhou ao instalar Discord"
fi

# ── Steam ─────────────────────────────────────────────────────────────
if command -v steam &>/dev/null || flatpak list 2>/dev/null | grep -q "com.valvesoftware.Steam"; then
  skipped "Steam"
else
  log "Instalando Steam..."
  sudo add-apt-repository -y multiverse
  sudo dpkg --add-architecture i386
  sudo apt-get update -qq
  echo steam steam/question select "I AGREE" | sudo debconf-set-selections
  echo steam steam/license note ''           | sudo debconf-set-selections
  sudo apt-get install -y steam-installer && ok "Steam instalado!" || {
    warn "apt falhou — tentando via Flatpak..."
    flatpak install -y flathub com.valvesoftware.Steam && ok "Steam instalado (Flatpak)!" || warn "Falhou ao instalar Steam"
  }
fi

# ── Google Chrome ─────────────────────────────────────────────────────
if command -v google-chrome &>/dev/null || command -v google-chrome-stable &>/dev/null; then
  skipped "Google Chrome"
else
  log "Instalando Google Chrome..."
  curl -fsSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb \
    && sudo apt-get install -y /tmp/chrome.deb \
    && rm -f /tmp/chrome.deb \
    && ok "Google Chrome instalado!" \
    || warn "Falhou ao instalar Google Chrome"
fi

# ── qBittorrent ───────────────────────────────────────────────────────
if command -v qbittorrent &>/dev/null || flatpak list 2>/dev/null | grep -q "org.qbittorrent.qBittorrent"; then
  skipped "qBittorrent"
else
  log "Instalando qBittorrent..."
  sudo apt-get install -y qbittorrent && ok "qBittorrent instalado!" || {
    warn "apt falhou — tentando via Flatpak..."
    flatpak install -y flathub org.qbittorrent.qBittorrent && ok "qBittorrent instalado (Flatpak)!" || warn "Falhou ao instalar qBittorrent"
  }
fi

# ── Kitty ─────────────────────────────────────────────────────────────
if command -v kitty &>/dev/null; then
  skipped "Kitty"
else
  log "Instalando Kitty..."
  curl -fsSL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n \
    && ok "Kitty instalado!" || warn "Falhou ao instalar Kitty"
fi

# ── Claude Code ───────────────────────────────────────────────────────
if command -v claude &>/dev/null; then
  skipped "Claude Code ($(claude --version 2>/dev/null | head -1))"
else
  log "Instalando Claude Code..."
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npm install -g @anthropic-ai/claude-code && ok "Claude Code instalado!" || warn "Falhou ao instalar Claude Code"
fi

echo ""
log "Resumo de apps:"
command -v discord     &>/dev/null && echo "  ✓ Discord"     || flatpak list 2>/dev/null | grep -q "Discord"      && echo "  ✓ Discord (Flatpak)"     || echo "  - Discord"
command -v steam         &>/dev/null && echo "  ✓ Steam"          || flatpak list 2>/dev/null | grep -q "Steam" && echo "  ✓ Steam (Flatpak)" || echo "  - Steam"
{ command -v google-chrome &>/dev/null || command -v google-chrome-stable &>/dev/null; } && echo "  ✓ Google Chrome" || echo "  - Google Chrome"
command -v qbittorrent &>/dev/null && echo "  ✓ qBittorrent" || flatpak list 2>/dev/null | grep -q "qbittorrent"  && echo "  ✓ qBittorrent (Flatpak)" || echo "  - qBittorrent"
command -v kitty       &>/dev/null && echo "  ✓ Kitty"       || echo "  - Kitty"
command -v claude      &>/dev/null && echo "  ✓ Claude Code ($(claude --version 2>/dev/null | head -1))" || echo "  - Claude Code"
