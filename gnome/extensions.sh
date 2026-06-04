#!/usr/bin/env bash
set -euo pipefail

log()     { echo -e "\033[0;36m[extensions]\033[0m $*"; }
ok()      { echo -e "\033[0;32m[ ok]\033[0m $*"; }
skipped() { echo -e "\033[0;90m[--]\033[0m $1 já instalado — pulando."; }

# ── gnome-tweaks e gnome-shell-extensions ───────────────────────────
if command -v gnome-tweaks &>/dev/null; then
  skipped "gnome-tweaks"
else
  log "Instalando gnome-tweaks..."
  sudo apt-get install -y gnome-shell-extensions gnome-tweaks
fi

# ── gnome-extensions-cli (gext) ─────────────────────────────────────
if command -v gext &>/dev/null; then
  skipped "gnome-extensions-cli"
else
  log "Instalando gnome-extensions-cli..."
  pip3 install --user gnome-extensions-cli 2>/dev/null || \
  pipx install gnome-extensions-cli 2>/dev/null || \
  log "Instale manualmente: pip3 install --user gnome-extensions-cli"
fi

# ── Extensões ────────────────────────────────────────────────────────
install_ext() {
  local uuid="$1" name="$2"
  if command -v gext &>/dev/null; then
    if gext list 2>/dev/null | grep -q "$uuid"; then
      skipped "extensão: $name"
    else
      log "Instalando extensão: $name"
      gext install "$uuid" && ok "$name instalada!" || \
        log "Falhou: $name — instale via https://extensions.gnome.org"
    fi
  else
    log "gext indisponível — instale manualmente: $name"
    echo "    → https://extensions.gnome.org/extension/$(echo "$uuid" | grep -o '[0-9]*' | head -1)/"
  fi
}

install_ext "blur-my-shell@aunetx"                                       "Blur my Shell"
install_ext "just-perfection-desktop@just-perfection"                    "Just Perfection"
install_ext "dash-to-dock@micxgx.gmail.com"                              "Dash to Dock"
install_ext "user-theme@gnome-shell-extensions.gcampax.github.com"       "User Themes"

echo ""
log "Links para instalação manual (caso necessário):"
echo "  • Blur my Shell   → https://extensions.gnome.org/extension/3193/"
echo "  • Just Perfection → https://extensions.gnome.org/extension/3843/"
echo "  • Dash to Dock    → https://extensions.gnome.org/extension/307/"
echo "  • User Themes     → https://extensions.gnome.org/extension/19/"
