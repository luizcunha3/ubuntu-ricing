#!/usr/bin/env bash
set -euo pipefail

log()     { echo -e "\033[0;36m[themes]\033[0m $*"; }
ok()      { echo -e "\033[0;32m[ ok]\033[0m $*"; }
warn()    { echo -e "\033[1;33m[warn]\033[0m $*"; }
skipped() { echo -e "\033[0;90m[--]\033[0m $1 já instalado — pulando."; }

THEMES_DIR="$HOME/.themes"
ICONS_DIR="$HOME/.icons"
mkdir -p "$THEMES_DIR" "$ICONS_DIR"

# ── Papirus icons ────────────────────────────────────────────────────
if dpkg -l papirus-icon-theme &>/dev/null 2>&1; then
  skipped "Papirus icon theme"
else
  log "Instalando Papirus icon theme..."
  sudo add-apt-repository -y ppa:papirus/papirus 2>/dev/null
  sudo apt-get update -qq
  sudo apt-get install -y papirus-icon-theme
  ok "Papirus instalado!"
fi

# ── Kanagawa GTK theme ───────────────────────────────────────────────
# Usa ArcaEge/GTK-Kanagawa-Improved — pré-compilado, sem necessidade de sassc
if [[ -f "$THEMES_DIR/Kanagawa/index.theme" ]]; then
  skipped "Kanagawa GTK theme"
else
  log "Instalando Kanagawa GTK theme (pré-compilado)..."
  TMP=$(mktemp -d)
  if git clone --depth=1 "https://github.com/ArcaEge/GTK-Kanagawa-Improved.git" "$TMP/kanagawa" 2>/dev/null; then
    mkdir -p "$THEMES_DIR/Kanagawa"
    cp -r "$TMP/kanagawa/"* "$THEMES_DIR/Kanagawa/"
    ok "Kanagawa GTK instalado em $THEMES_DIR/Kanagawa"
  else
    warn "Não foi possível clonar o tema Kanagawa"
  fi
  rm -rf "$TMP"
fi

# ── Cursor: Bibata Modern Ice ────────────────────────────────────────
if ls "$ICONS_DIR"/Bibata* &>/dev/null 2>&1; then
  skipped "Cursor Bibata Modern Ice"
else
  log "Instalando cursor Bibata Modern Ice..."
  TMP=$(mktemp -d)
  if curl -fsSL \
    "https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Ice.tar.xz" \
    -o "$TMP/cursor.tar.xz" 2>/dev/null; then
    tar -xf "$TMP/cursor.tar.xz" -C "$ICONS_DIR"
    ok "Cursor Bibata Modern Ice instalado!"
  else
    warn "Não foi possível baixar o cursor"
  fi
  rm -rf "$TMP"
fi
