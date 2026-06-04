#!/usr/bin/env bash
set -euo pipefail

log()  { echo -e "\033[0;36m[extensions]\033[0m $*"; }
ok()   { echo -e "\033[0;32m[ ok]\033[0m $*"; }

sudo apt-get install -y gnome-shell-extensions gnome-tweaks curl 2>/dev/null

# gnome-extensions-cli — permite instalar extensões via linha de comando
if ! command -v gext &>/dev/null; then
  log "Instalando gnome-extensions-cli..."
  pip3 install --user gnome-extensions-cli 2>/dev/null || \
    pipx install gnome-extensions-cli 2>/dev/null || \
    log "Instale manualmente: pip3 install --user gnome-extensions-cli"
fi

# Instala extensões pelo UUID se gext estiver disponível
install_ext() {
  local uuid="$1"
  local name="$2"
  if command -v gext &>/dev/null; then
    log "Instalando: $name"
    gext install "$uuid" 2>/dev/null && ok "$name instalado" || log "Falhou: $name (instale manualmente)"
  else
    log "  → $name: $uuid"
  fi
}

echo ""
log "Instalando extensões GNOME..."

install_ext "blur-my-shell@aunetx"              "Blur my Shell"
install_ext "just-perfection-desktop@just-perfection" "Just Perfection"
install_ext "dash-to-dock@micxgx.gmail.com"     "Dash to Dock"
install_ext "user-theme@gnome-shell-extensions.gcampax.github.com" "User Themes"

echo ""
log "Se alguma falhar, instale via browser em:"
echo "  https://extensions.gnome.org"
echo ""
echo "  • Blur my Shell      → /extension/3193/"
echo "  • Just Perfection    → /extension/3843/"
echo "  • Dash to Dock       → /extension/307/"
echo "  • User Themes        → /extension/19/"

ok "Extensões configuradas"
