#!/usr/bin/env bash
set -euo pipefail

log()  { echo -e "\033[0;36m[apps]\033[0m $*"; }
ok()   { echo -e "\033[0;32m[ ok]\033[0m $*"; }
warn() { echo -e "\033[1;33m[ warn]\033[0m $*"; }

confirm() {
  local msg="$1"
  echo -e "\033[1;33m?\033[0m $msg [s/N] \c"
  read -r answer </dev/tty
  [[ "$answer" =~ ^[sSyY]$ ]]
}

already() { echo -e "\033[0;32m[ ok]\033[0m $1 já instalado — pulando."; }
skipped() { echo -e "\033[0;90m[--]\033[0m $1 pulado."; }

# Garante que flatpak esteja disponível
if ! command -v flatpak &>/dev/null; then
  log "Instalando Flatpak..."
  sudo apt-get install -y flatpak
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

echo ""
log "Verificando apps a instalar..."
echo ""

# ── Discord ──────────────────────────────────────────────────────────
if flatpak list 2>/dev/null | grep -q "com.discordapp.Discord" || \
   dpkg -l discord &>/dev/null 2>&1 || command -v discord &>/dev/null; then
  already "Discord"
elif confirm "Instalar Discord?"; then
  log "Instalando Discord via Flatpak..."
  flatpak install -y flathub com.discordapp.Discord && ok "Discord instalado" || warn "Falhou ao instalar Discord"
else
  skipped "Discord"
fi

# ── Steam ────────────────────────────────────────────────────────────
if command -v steam &>/dev/null || flatpak list 2>/dev/null | grep -q "com.valvesoftware.Steam"; then
  already "Steam"
elif confirm "Instalar Steam?"; then
  log "Instalando Steam..."
  sudo add-apt-repository -y multiverse
  sudo dpkg --add-architecture i386
  sudo apt-get update -qq
  echo steam steam/question select "I AGREE" | sudo debconf-set-selections
  echo steam steam/license note ''           | sudo debconf-set-selections
  sudo apt-get install -y steam-installer && ok "Steam instalado" || {
    warn "apt falhou — tentando via Flatpak..."
    flatpak install -y flathub com.valvesoftware.Steam && ok "Steam instalado (Flatpak)" || warn "Falhou ao instalar Steam"
  }
else
  skipped "Steam"
fi

# ── Zen Browser ──────────────────────────────────────────────────────
ZEN_FLATPAK="io.github.zen_browser.zen"

if flatpak list 2>/dev/null | grep -q "$ZEN_FLATPAK" || \
   command -v zen-browser &>/dev/null; then
  already "Zen Browser"
elif confirm "Instalar Zen Browser?"; then
  log "Instalando Zen Browser via Flatpak..."
  flatpak remote-add --if-not-exists --user flathub-beta \
    https://flathub.org/beta-repo/flathub-beta.flatpakrepo 2>/dev/null || true

  if flatpak install -y --user flathub "$ZEN_FLATPAK" 2>/dev/null; then
    ok "Zen Browser instalado"
  elif flatpak install -y --user flathub-beta "$ZEN_FLATPAK" 2>/dev/null; then
    ok "Zen Browser instalado (beta)"
  else
    log "Flatpak falhou — baixando AppImage..."
    ZEN_DIR="$HOME/.local/opt/zen-browser"
    mkdir -p "$ZEN_DIR" "$HOME/.local/bin" "$HOME/.local/share/applications"

    ZEN_URL=$(curl -fsSL "https://api.github.com/repos/zen-browser/desktop/releases/latest" \
      | grep -o '"browser_download_url": "[^"]*linux[^"]*\.AppImage"' \
      | head -1 | cut -d'"' -f4)

    if [[ -n "$ZEN_URL" ]]; then
      curl -fsSL "$ZEN_URL" -o "$ZEN_DIR/zen.AppImage"
      chmod +x "$ZEN_DIR/zen.AppImage"
      ln -sf "$ZEN_DIR/zen.AppImage" "$HOME/.local/bin/zen-browser"
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
DESKTOP
      ok "Zen Browser instalado como AppImage em $ZEN_DIR"
    else
      warn "Não foi possível determinar a URL — acesse: https://zen-browser.app/download"
    fi
  fi
else
  skipped "Zen Browser"
fi

# ── qBittorrent ──────────────────────────────────────────────────────
if command -v qbittorrent &>/dev/null || flatpak list 2>/dev/null | grep -q "org.qbittorrent.qBittorrent"; then
  skipped "qBittorrent"
elif confirm "Instalar qBittorrent?"; then
  log "Instalando qBittorrent..."
  if sudo apt-get install -y qbittorrent 2>/dev/null; then
    ok "qBittorrent instalado!"
  else
    log "apt falhou — tentando via Flatpak..."
    flatpak install -y flathub org.qbittorrent.qBittorrent && ok "qBittorrent instalado (Flatpak)" || warn "Falhou ao instalar qBittorrent"
  fi
else
  skipped "qBittorrent"
fi

# ── Claude Code ──────────────────────────────────────────────────────
if command -v claude &>/dev/null; then
  skipped "Claude Code ($(claude --version 2>/dev/null | head -1))"
elif confirm "Instalar Claude Code?"; then
  log "Instalando Claude Code..."
  # Garante que o npm do nvm está disponível
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npm install -g @anthropic-ai/claude-code && ok "Claude Code instalado!" || warn "Falhou ao instalar Claude Code"
else
  skipped "Claude Code"
fi

echo ""
log "Resumo de apps:"
command -v discord     &>/dev/null && echo "  ✓ Discord"     || flatpak list 2>/dev/null | grep -q "Discord"     && echo "  ✓ Discord (Flatpak)"     || echo "  - Discord"
command -v steam       &>/dev/null && echo "  ✓ Steam"       || flatpak list 2>/dev/null | grep -q "Steam"       && echo "  ✓ Steam (Flatpak)"       || echo "  - Steam"
command -v zen-browser &>/dev/null && echo "  ✓ Zen Browser" || flatpak list 2>/dev/null | grep -q "zen"         && echo "  ✓ Zen Browser (Flatpak)" || echo "  - Zen Browser"
command -v qbittorrent &>/dev/null && echo "  ✓ qBittorrent" || flatpak list 2>/dev/null | grep -q "qbittorrent" && echo "  ✓ qBittorrent (Flatpak)" || echo "  - qBittorrent"
command -v claude      &>/dev/null && echo "  ✓ Claude Code ($(claude --version 2>/dev/null | head -1))" || echo "  - Claude Code"
