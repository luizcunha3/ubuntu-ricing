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

# ── Zen Browser (AppImage — Flatpak ainda instável no Flathub) ────────
ZEN_DIR="$HOME/.local/opt/zen-browser"
if [[ -f "$ZEN_DIR/zen.AppImage" ]] || command -v zen-browser &>/dev/null; then
  skipped "Zen Browser"
else
  log "Instalando Zen Browser via AppImage..."
  mkdir -p "$ZEN_DIR" "$HOME/.local/bin" "$HOME/.local/share/applications"

  ZEN_URL=$(curl -fsSL --max-time 10 \
    "https://api.github.com/repos/zen-browser/desktop/releases/latest" \
    | grep -o '"browser_download_url": "[^"]*x86_64\.AppImage"' \
    | head -1 | cut -d'"' -f4)

  if [[ -z "$ZEN_URL" ]]; then
    warn "Não foi possível obter URL do Zen Browser — acesse: https://zen-browser.app/download"
  else
    log "Baixando $(basename "$ZEN_URL")..."
    curl -fsSL --progress-bar "$ZEN_URL" -o "$ZEN_DIR/zen.AppImage"
    chmod +x "$ZEN_DIR/zen.AppImage"
    ln -sf "$ZEN_DIR/zen.AppImage" "$HOME/.local/bin/zen-browser"

    # Tenta extrair ícone do AppImage
    "$ZEN_DIR/zen.AppImage" --appimage-extract usr/share/icons &>/dev/null || true
    if [[ -d squashfs-root/usr/share/icons ]]; then
      cp -r squashfs-root/usr/share/icons ~/.local/share/ 2>/dev/null || true
      rm -rf squashfs-root
    fi

    cat > "$HOME/.local/share/applications/zen-browser.desktop" << 'DESKTOP'
[Desktop Entry]
Name=Zen Browser
Comment=Experience tranquillity while browsing the web
Exec=zen-browser %U
Terminal=false
Type=Application
Icon=zen-browser
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
StartupNotify=true
DESKTOP
    ok "Zen Browser instalado!"
  fi
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
command -v steam       &>/dev/null && echo "  ✓ Steam"       || flatpak list 2>/dev/null | grep -q "Steam"        && echo "  ✓ Steam (Flatpak)"       || echo "  - Steam"
command -v zen-browser &>/dev/null && echo "  ✓ Zen Browser" || flatpak list 2>/dev/null | grep -q "zen_browser"  && echo "  ✓ Zen Browser (Flatpak)" || echo "  - Zen Browser"
command -v qbittorrent &>/dev/null && echo "  ✓ qBittorrent" || flatpak list 2>/dev/null | grep -q "qbittorrent"  && echo "  ✓ qBittorrent (Flatpak)" || echo "  - qBittorrent"
command -v claude      &>/dev/null && echo "  ✓ Claude Code ($(claude --version 2>/dev/null | head -1))" || echo "  - Claude Code"
