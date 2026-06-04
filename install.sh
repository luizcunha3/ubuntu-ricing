#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

log()  { echo -e "${CYAN}[rice]${NC} $*"; }
ok()   { echo -e "${GREEN}[ ok]${NC} $*"; }
warn() { echo -e "${YELLOW}[warn]${NC} $*"; }
err()  { echo -e "${RED}[ err]${NC} $*"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${PURPLE}"
cat << 'EOF'
  ██╗  ██╗ █████╗ ███╗   ██╗ █████╗  ██████╗  █████╗ ██╗    ██╗ █████╗
  ██║ ██╔╝██╔══██╗████╗  ██║██╔══██╗██╔════╝ ██╔══██╗██║    ██║██╔══██╗
  █████╔╝ ███████║██╔██╗ ██║███████║██║  ███╗███████║██║ █╗ ██║███████║
  ██╔═██╗ ██╔══██║██║╚██╗██║██╔══██║██║   ██║██╔══██║██║███╗██║██╔══██║
  ██║  ██╗██║  ██║██║ ╚████║██║  ██║╚██████╔╝██║  ██║╚███╔███╔╝██║  ██║
  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═╝
  Ubuntu Ricing — Kanagawa Edition
EOF
echo -e "${NC}"

# --only <module> e --yes para pular confirmações
ONLY=""
YES=false
while [[ $# -gt 0 ]]; do
  case $1 in
    --only) ONLY="$2"; shift 2 ;;
    --yes|-y) YES=true; shift ;;
    *) err "Flag desconhecida: $1" ;;
  esac
done

confirm() {
  local msg="$1"
  if [[ "$YES" == true ]]; then return 0; fi
  echo -e "${YELLOW}?${NC} $msg [s/N] \c"
  read -r answer </dev/tty
  [[ "$answer" =~ ^[sSyY]$ ]]
}

run_module() {
  local name="$1"
  local script="$SCRIPT_DIR/$2"
  if [[ -z "$ONLY" || "$ONLY" == "$name" ]]; then
    echo ""
    log "━━ $name ━━"
    bash "$script"
    ok "$name concluído"
  fi
}

# Confirmação geral quando roda tudo (sem --only)
if [[ -z "$ONLY" ]]; then
  echo -e "${CYAN}O seguinte será instalado:${NC}"
  echo "  • Fontes: JetBrains Mono Nerd Font, Inter"
  echo "  • Dev: Node/nvm, Python/pyenv, Rust/rustup"
  echo "  • Terminal: Kitty, Zsh, Oh My Zsh, Starship"
  echo "  • CLI: eza, bat, fd, fzf, zoxide, btop, ripgrep"
  echo "  • GNOME: Kanagawa GTK, Papirus icons, extensões"
  echo "  • Apps: Discord, Steam, Zen Browser, qBittorrent, Claude Code"
  echo "  • Wallpapers: Great Wave, Mountains Retreat, Abstract 00252"
  echo ""
  confirm "Continuar com a instalação completa?" || { log "Instalação cancelada."; exit 0; }
fi

run_module "fonts"             "fonts/fonts.sh"
run_module "dev/node"          "dev/node.sh"
run_module "dev/python"        "dev/python.sh"
run_module "dev/rust"          "dev/rust.sh"
run_module "gnome/themes"      "gnome/themes.sh"
run_module "gnome/extensions"  "gnome/extensions.sh"
run_module "dotfiles"          "dotfiles/install.sh"
run_module "gnome/settings"    "gnome/settings.sh"
run_module "wallpapers"        "wallpapers/wallpapers.sh"
run_module "apps"              "apps/apps.sh"

echo ""
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Ricing completo! Faça logout e login para aplicar.${NC}"
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  Módulos disponíveis para rodar individualmente:"
echo "    ./install.sh --only fonts"
echo "    ./install.sh --only dev/node"
echo "    ./install.sh --only gnome/settings"
echo "    ./install.sh --only apps"
echo ""
