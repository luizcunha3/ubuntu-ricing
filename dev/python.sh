#!/usr/bin/env bash
set -euo pipefail

log()     { echo -e "\033[0;36m[python]\033[0m $*"; }
ok()      { echo -e "\033[0;32m[ ok]\033[0m $*"; }
skipped() { echo -e "\033[0;90m[--]\033[0m $1 já instalado — pulando."; }

PYTHON_VERSION="3.12.4"

# ── Dependências de build ────────────────────────────────────────────
log "Verificando dependências de build..."
sudo apt-get install -y \
  make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
  libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev \
  libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev 2>/dev/null

# ── pyenv ───────────────────────────────────────────────────────────
if [[ -d "$HOME/.pyenv" ]]; then
  skipped "pyenv"
else
  log "Instalando pyenv..."
  curl https://pyenv.run | bash
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$HOME/.local/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv init --path 2>/dev/null)" || true

# ── Python ──────────────────────────────────────────────────────────
if pyenv versions 2>/dev/null | grep -q "$PYTHON_VERSION"; then
  skipped "Python $PYTHON_VERSION"
else
  log "Instalando Python $PYTHON_VERSION..."
  pyenv install "$PYTHON_VERSION"
fi

pyenv global "$PYTHON_VERSION"

# Garante que o python do pyenv está no PATH antes do Poetry
PYENV_PYTHON="$PYENV_ROOT/versions/$PYTHON_VERSION/bin/python3"

# ── Poetry ──────────────────────────────────────────────────────────
if command -v poetry &>/dev/null || [[ -f "$HOME/.local/bin/poetry" ]]; then
  skipped "Poetry ($( (poetry --version 2>/dev/null || "$HOME/.local/bin/poetry" --version 2>/dev/null) | head -1))"
else
  log "Instalando Poetry..."
  curl -sSL https://install.python-poetry.org | "$PYENV_PYTHON" -
fi

ok "Python $(python3 --version) pronto!"
