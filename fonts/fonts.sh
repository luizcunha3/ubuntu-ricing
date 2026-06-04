#!/usr/bin/env bash
set -euo pipefail

log()     { echo -e "\033[0;36m[fonts]\033[0m $*"; }
ok()      { echo -e "\033[0;32m[ ok]\033[0m $*"; }
skipped() { echo -e "\033[0;90m[--]\033[0m $1 já instalada — pulando."; }

FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

# ── JetBrains Mono Nerd Font ────────────────────────────────────────
if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
  skipped "JetBrains Mono Nerd Font"
else
  FONT_VERSION="3.2.1"
  log "Baixando JetBrains Mono Nerd Font v$FONT_VERSION..."
  TMP=$(mktemp -d)
  curl -fsSL \
    "https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VERSION}/JetBrainsMono.zip" \
    -o "$TMP/font.zip"
  unzip -q "$TMP/font.zip" -d "$TMP/fonts"
  find "$TMP/fonts" -name "*.ttf" -exec cp {} "$FONTS_DIR/" \;
  rm -rf "$TMP"
  fc-cache -fv "$FONTS_DIR" > /dev/null
  ok "JetBrains Mono Nerd Font instalada!"
fi

# ── Inter (UI do GNOME) ─────────────────────────────────────────────
if fc-list | grep -qi "^.*Inter"; then
  skipped "Inter"
else
  log "Instalando fonte Inter..."
  sudo apt-get install -y fonts-inter 2>/dev/null && ok "Inter instalada!" || \
    log "Inter não encontrada no apt — instale manualmente em rsms.me/inter"
fi
