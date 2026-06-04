#!/usr/bin/env bash
set -euo pipefail

log()     { echo -e "\033[0;36m[node]\033[0m $*"; }
ok()      { echo -e "\033[0;32m[ ok]\033[0m $*"; }
skipped() { echo -e "\033[0;90m[--]\033[0m $1 já instalado — pulando."; }

# ── nvm ─────────────────────────────────────────────────────────────
if [[ -d "$HOME/.nvm" ]]; then
  skipped "nvm"
else
  log "Instalando nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# ── Node LTS ────────────────────────────────────────────────────────
if command -v node &>/dev/null; then
  skipped "Node ($(node --version))"
else
  log "Instalando Node LTS..."
  nvm install --lts
  nvm use --lts
  nvm alias default node 2>/dev/null || true
fi

# ── Pacotes globais ─────────────────────────────────────────────────
npm_global() {
  local pkg="$1" cmd="${2:-$1}"
  if command -v "$cmd" &>/dev/null; then
    skipped "npm global: $pkg"
  else
    log "Instalando $pkg globalmente..."
    npm install -g "$pkg"
  fi
}

npm_global "pnpm"
npm_global "typescript" "tsc"
npm_global "ts-node"

ok "Node $(node --version) pronto!"
