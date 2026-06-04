#!/usr/bin/env bash
set -euo pipefail

log()  { echo -e "\033[0;36m[node]\033[0m $*"; }
ok()   { echo -e "\033[0;32m[ ok]\033[0m $*"; }

NVM_VERSION="v0.40.1"

if [[ -d "$HOME/.nvm" ]]; then
  log "nvm já instalado — atualizando..."
  (cd "$HOME/.nvm" && git fetch --tags && git checkout "$(git describe --abbrev=0 --tags)")
else
  log "Instalando nvm $NVM_VERSION..."
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash
fi

export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

log "Instalando Node LTS..."
nvm install --lts
nvm use --lts
nvm alias default node 2>/dev/null || true

log "Instalando pacotes globais..."
npm install -g pnpm typescript ts-node

ok "Node $(node --version) pronto!"
