#!/usr/bin/env bash
set -euo pipefail

log()  { echo -e "\033[0;36m[gnome]\033[0m $*"; }
ok()   { echo -e "\033[0;32m[ ok]\033[0m $*"; }
warn() { echo -e "\033[1;33m[warn]\033[0m $*"; }

g() { gsettings set "$@" 2>/dev/null || true; }

log "Ativando extensão User Themes..."
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com 2>/dev/null || true

log "Aplicando tema escuro..."
g org.gnome.desktop.interface color-scheme      'prefer-dark'
g org.gnome.desktop.interface gtk-theme         'Nordic'
g org.gnome.desktop.interface icon-theme        'Papirus-Dark'
g org.gnome.desktop.interface cursor-theme      'Bibata-Modern-Ice'
g org.gnome.desktop.wm.preferences theme        'Nordic'
g org.gnome.shell.extensions.user-theme name    'Nordic'

log "Aplicando fontes..."
g org.gnome.desktop.interface font-name              'Inter 11'
g org.gnome.desktop.interface monospace-font-name    'JetBrainsMono Nerd Font 12'
g org.gnome.desktop.interface document-font-name     'Inter 11'
g org.gnome.desktop.wm.preferences titlebar-font     'Inter Bold 11'
g org.gnome.desktop.interface text-scaling-factor    '1.0'

log "Configurando comportamento do GNOME..."
g org.gnome.desktop.wm.preferences button-layout     'close,minimize,maximize:'
g org.gnome.mutter center-new-windows                true
g org.gnome.desktop.interface enable-animations      true
g org.gnome.desktop.interface show-battery-percentage true
g org.gnome.desktop.interface clock-show-weekday     true
g org.gnome.desktop.interface clock-show-seconds     false
g org.gnome.settings-daemon.plugins.color night-light-enabled false

log "Configurando touchpad..."
g org.gnome.desktop.peripherals.touchpad tap-to-click  true
g org.gnome.desktop.peripherals.touchpad natural-scroll true
g org.gnome.desktop.peripherals.touchpad speed          0.3

log "Configurando Dash to Dock..."
g org.gnome.shell.extensions.dash-to-dock dock-position    'BOTTOM'
g org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40
g org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
g org.gnome.shell.extensions.dash-to-dock background-opacity 0.7

log "Configurando Blur my Shell..."
g org.gnome.shell.extensions.blur-my-shell.panel blur   true
g org.gnome.shell.extensions.blur-my-shell.overview blur true
g org.gnome.shell.extensions.blur-my-shell sigma        15

log "Configurando browser padrão..."
if command -v google-chrome &>/dev/null || command -v google-chrome-stable &>/dev/null; then
  xdg-settings set default-web-browser google-chrome.desktop 2>/dev/null \
    || xdg-settings set default-web-browser google-chrome-stable.desktop 2>/dev/null \
    || true
  ok "Google Chrome definido como browser padrão!"
else
  warn "Google Chrome não encontrado — browser padrão não alterado."
fi

log "Configurando terminal padrão..."
if command -v kitty &>/dev/null; then
  # Registra kitty no update-alternatives
  KITTY_BIN="$(command -v kitty)"
  sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$KITTY_BIN" 50 2>/dev/null || true
  sudo update-alternatives --set x-terminal-emulator "$KITTY_BIN" 2>/dev/null || true
  # GNOME usa essa chave para o atalho Super+T e "Abrir terminal"
  g org.gnome.desktop.default-applications.terminal exec       'kitty'
  g org.gnome.desktop.default-applications.terminal exec-arg   ''
  ok "Kitty definido como terminal padrão!"

  log "Criando atalho Super+T para abrir o kitty..."
  KB="org.gnome.settings-daemon.plugins.media-keys"
  KB_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/kitty/"
  # Adiciona o caminho à lista de custom-keybindings sem duplicar
  CURRENT="$(gsettings get "$KB" custom-keybindings 2>/dev/null || echo '@as []')"
  if [[ "$CURRENT" != *"$KB_PATH"* ]]; then
    if [[ "$CURRENT" == "@as []" || "$CURRENT" == "[]" ]]; then
      NEW="['$KB_PATH']"
    else
      NEW="${CURRENT%]}, '$KB_PATH']"
    fi
    g "$KB" custom-keybindings "$NEW"
  fi
  g "$KB.custom-keybinding:$KB_PATH" name    'Kitty'
  g "$KB.custom-keybinding:$KB_PATH" command "$KITTY_BIN"
  g "$KB.custom-keybinding:$KB_PATH" binding '<Super>t'
  ok "Atalho Super+T → kitty configurado!"
else
  warn "Kitty não encontrado — terminal padrão não alterado."
fi

ok "Configurações GNOME aplicadas!"
