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

# Pré-requisitos mínimos — podem não vir em VMs/Ubuntu limpas
_need_pkgs=()
command -v curl  &>/dev/null || _need_pkgs+=(curl)
command -v git   &>/dev/null || _need_pkgs+=(git)
command -v unzip &>/dev/null || _need_pkgs+=(unzip)
dpkg -s software-properties-common &>/dev/null 2>&1 || _need_pkgs+=(software-properties-common)
if [[ ${#_need_pkgs[@]} -gt 0 ]]; then
  echo -e "${YELLOW}[warn]${NC} Instalando pré-requisitos: ${_need_pkgs[*]}"
  sudo apt-get update -qq
  sudo apt-get install -y "${_need_pkgs[@]}"
fi
unset _need_pkgs

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

# --only <module> para rodar só um módulo
ONLY=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --only) ONLY="$2"; shift 2 ;;
    *) err "Flag desconhecida: $1" ;;
  esac
done

run_module() {
  local name="$1"
  local script="$SCRIPT_DIR/$2"
  if [[ -z "$ONLY" || "$ONLY" == "$name" ]]; then
    echo ""
    log "━━ $name ━━"
    if bash "$script"; then
      ok "$name concluído"
    else
      warn "$name falhou — continuando com próximo módulo"
    fi
  fi
}

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
