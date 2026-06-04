#!/usr/bin/env bash
set -euo pipefail

log()  { echo -e "\033[0;36m[wallpapers]\033[0m $*"; }
ok()   { echo -e "\033[0;32m[ ok]\033[0m $*"; }
warn() { echo -e "\033[1;33m[ warn]\033[0m $*"; }

WP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

set_wallpaper() {
  local file="$1"
  if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.background picture-uri      "file://$file"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$file"
    gsettings set org.gnome.desktop.background picture-options  'zoom'
    ok "Wallpaper aplicado: $(basename "$file")"
  fi
}

download() {
  local name="$1" url="$2"
  local dest="$WP_DIR/$name"
  if [[ -f "$dest" ]]; then
    ok "Já existe: $name"
  else
    log "Baixando $name..."
    if curl -fsSL "$url" -o "$dest" 2>/dev/null; then
      ok "Baixado: $name"
    else
      warn "Falhou: $name (url pode ter mudado)"
      rm -f "$dest"
    fi
  fi
  echo "$dest"
}

BASE_G="https://raw.githubusercontent.com/Gurjaka/Kanagawa-Wallpapers/main/wallpapers"
BASE_P="https://raw.githubusercontent.com/philikarus/Kanagawa-wallpapers/main/wallpapers/landscape"

WP1=$(download "great-wave.jpg"        "$BASE_G/great_wave_of_kanagawa.jpg")
WP2=$(download "mountains-retreat.jpg" "$BASE_G/mountains-retreat.jpg")
     download  "abstract-00252.png"    "$BASE_P/00252.png" > /dev/null

# Aplica o Great Wave como wallpaper padrão
if [[ -f "$WP1" ]]; then
  set_wallpaper "$WP1"
elif [[ -f "$WP2" ]]; then
  set_wallpaper "$WP2"
else
  warn "Nenhum wallpaper baixado — verifique conexão"
fi

log "Wallpapers salvos em: $WP_DIR"
