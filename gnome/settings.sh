#!/usr/bin/env bash
set -euo pipefail

log()  { echo -e "\033[0;36m[gnome]\033[0m $*"; }
ok()   { echo -e "\033[0;32m[ ok]\033[0m $*"; }

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

log "Configurando touchpad..."
g org.gnome.desktop.peripherals.touchpad tap-to-click  true
g org.gnome.desktop.peripherals.touchpad natural-scroll true
g org.gnome.desktop.peripherals.touchpad speed          0.3

log "Ativando Night Light..."
g org.gnome.settings-daemon.plugins.color night-light-enabled     true
g org.gnome.settings-daemon.plugins.color night-light-temperature 4000
g org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true

log "Configurando Dash to Dock..."
g org.gnome.shell.extensions.dash-to-dock dock-position    'BOTTOM'
g org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40
g org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
g org.gnome.shell.extensions.dash-to-dock background-opacity 0.7

log "Configurando Blur my Shell..."
g org.gnome.shell.extensions.blur-my-shell.panel blur   true
g org.gnome.shell.extensions.blur-my-shell.overview blur true
g org.gnome.shell.extensions.blur-my-shell sigma        15

ok "Configurações GNOME aplicadas!"
