#!/usr/bin/env bash
set -euo pipefail

log()  { echo -e "\033[0;36m[rust]\033[0m $*"; }
ok()   { echo -e "\033[0;32m[ ok]\033[0m $*"; }

if command -v rustup &>/dev/null; then
  log "rustup já instalado — atualizando..."
  rustup update
else
  log "Instalando Rust via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

# shellcheck source=/dev/null
source "$HOME/.cargo/env"

log "Instalando componentes..."
rustup component add rustfmt clippy rust-analyzer

ok "Rust $(rustc --version) pronto!"
