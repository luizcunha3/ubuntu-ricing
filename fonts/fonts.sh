#!/usr/bin/env bash
set -euo pipefail

log()  { echo -e "\033[0;36m[fonts]\033[0m $*"; }
ok()   { echo -e "\033[0;32m[ ok]\033[0m $*"; }

FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

FONT_VERSION="3.2.1"

if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
  ok "JetBrains Mono Nerd Font já instalada"
  exit 0
fi

log "Baixando JetBrains Mono Nerd Font v$FONT_VERSION..."
TMP=$(mktemp -d)
curl -fsSL \
  "https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VERSION}/JetBrainsMono.zip" \
  -o "$TMP/font.zip"

unzip -q "$TMP/font.zip" -d "$TMP/fonts"
find "$TMP/fonts" -name "*.ttf" -exec cp {} "$FONTS_DIR/" \;
rm -rf "$TMP"

log "Atualizando cache de fontes..."
fc-cache -fv "$FONTS_DIR" > /dev/null

ok "JetBrains Mono Nerd Font instalada!"

# Inter para UI do GNOME
log "Instalando fonte Inter..."
sudo apt-get install -y fonts-inter 2>/dev/null || \
  log "Inter não encontrada no apt — use o instalador manual em rsms.me/inter"
