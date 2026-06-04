#!/usr/bin/env bash
set -euo pipefail

log()  { echo -e "\033[0;36m[apps]\033[0m $*"; }
ok()   { echo -e "\033[0;32m[ ok]\033[0m $*"; }
warn() { echo -e "\033[1;33m[ warn]\033[0m $*"; }

# Garante que flatpak esteja disponível
if ! command -v flatpak &>/dev/null; then
  log "Instalando Flatpak..."
  sudo apt-get install -y flatpak
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# ── Discord ──────────────────────────────────────────────────────────
if ! flatpak list 2>/dev/null | grep -q "com.discordapp.Discord" && \
   ! dpkg -l discord &>/dev/null 2>&1; then
  log "Instalando Discord via Flatpak..."
  flatpak install -y flathub com.discordapp.Discord && ok "Discord instalado" || warn "Falhou ao instalar Discord"
else
  ok "Discord já instalado"
fi

# ── Steam ────────────────────────────────────────────────────────────
if ! command -v steam &>/dev/null && ! flatpak list 2>/dev/null | grep -q "com.valvesoftware.Steam"; then
  log "Instalando Steam..."
  # Habilita multiverse e i386 para Steam
  sudo add-apt-repository -y multiverse
  sudo dpkg --add-architecture i386
  sudo apt-get update -qq
  # Pré-aceita licença
  echo steam steam/question select "I AGREE" | sudo debconf-set-selections
  echo steam steam/license note ''           | sudo debconf-set-selections
  sudo apt-get install -y steam-installer && ok "Steam instalado" || {
    warn "apt falhou — tentando via Flatpak..."
    flatpak install -y flathub com.valvesoftware.Steam && ok "Steam instalado (Flatpak)" || warn "Falhou ao instalar Steam"
  }
else
  ok "Steam já instalado"
fi

# ── Zen Browser ──────────────────────────────────────────────────────
ZEN_FLATPAK="io.github.zen_browser.zen"

if ! flatpak list 2>/dev/null | grep -q "$ZEN_FLATPAK"; then
  log "Instalando Zen Browser via Flatpak..."
  # Zen Browser está no Flathub Beta — adiciona o remote se necessário
  flatpak remote-add --if-not-exists --user flathub-beta \
    https://flathub.org/beta-repo/flathub-beta.flatpakrepo 2>/dev/null || true

  if flatpak install -y --user flathub "$ZEN_FLATPAK" 2>/dev/null; then
    ok "Zen Browser instalado"
  elif flatpak install -y --user flathub-beta "$ZEN_FLATPAK" 2>/dev/null; then
    ok "Zen Browser instalado (beta)"
  else
    # Fallback: AppImage oficial
    log "Flatpak falhou — baixando AppImage do Zen Browser..."
    ZEN_DIR="$HOME/.local/opt/zen-browser"
    mkdir -p "$ZEN_DIR" "$HOME/.local/bin" "$HOME/.local/share/applications"

    ZEN_URL=$(curl -fsSL "https://api.github.com/repos/zen-browser/desktop/releases/latest" \
      | grep -o '"browser_download_url": "[^"]*linux[^"]*\.AppImage"' \
      | head -1 | cut -d'"' -f4)

    if [[ -n "$ZEN_URL" ]]; then
      curl -fsSL "$ZEN_URL" -o "$ZEN_DIR/zen.AppImage"
      chmod +x "$ZEN_DIR/zen.AppImage"
      ln -sf "$ZEN_DIR/zen.AppImage" "$HOME/.local/bin/zen-browser"

      # Ícone e .desktop
      cat > "$HOME/.local/share/applications/zen-browser.desktop" << 'DESKTOP'
[Desktop Entry]
Name=Zen Browser
Comment=Experience tranquillity while browsing the web
Exec=%u zen-browser %U
Terminal=false
Type=Application
Icon=zen-browser
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
DESKTOP

      ok "Zen Browser instalado como AppImage em $ZEN_DIR"
    else
      warn "Não foi possível determinar a URL do Zen Browser — acesse: https://zen-browser.app/download"
    fi
  fi
else
  ok "Zen Browser já instalado"
fi

echo ""
log "Apps instalados:"
echo "  • Discord    — lançar: discord  (ou via menu)"
echo "  • Steam      — lançar: steam"
echo "  • Zen Browser — lançar: zen-browser  (ou via menu)"
