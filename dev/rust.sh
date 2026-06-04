#!/usr/bin/env bash
set -euo pipefail

log()     { echo -e "\033[0;36m[rust]\033[0m $*"; }
ok()      { echo -e "\033[0;32m[ ok]\033[0m $*"; }
skipped() { echo -e "\033[0;90m[--]\033[0m $1 já instalado — pulando."; }

# ── rustup ──────────────────────────────────────────────────────────
if command -v rustup &>/dev/null; then
  skipped "rustup"
  rustup update
else
  log "Instalando Rust via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

# shellcheck source=/dev/null
source "$HOME/.cargo/env"

# ── Componentes ─────────────────────────────────────────────────────
rustup_component() {
  local comp="$1"
  if rustup component list --installed 2>/dev/null | grep -q "^$comp"; then
    skipped "rustup component: $comp"
  else
    log "Instalando componente: $comp"
    rustup component add "$comp"
  fi
}

rustup_component "rustfmt"
rustup_component "clippy"
rustup_component "rust-analyzer"

ok "Rust $(rustc --version) pronto!"
