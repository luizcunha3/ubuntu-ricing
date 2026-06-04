#!/usr/bin/env bash
set -euo pipefail

log()  { echo -e "\033[0;36m[python]\033[0m $*"; }
ok()   { echo -e "\033[0;32m[ ok]\033[0m $*"; }

PYTHON_VERSION="3.12.4"

log "Instalando dependências de build..."
sudo apt-get install -y \
  make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
  libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev \
  libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

if [[ -d "$HOME/.pyenv" ]]; then
  log "pyenv já instalado — atualizando..."
  cd "$HOME/.pyenv" && git pull --quiet
else
  log "Instalando pyenv..."
  curl https://pyenv.run | bash
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

log "Instalando Python $PYTHON_VERSION..."
pyenv install -s "$PYTHON_VERSION"
pyenv global "$PYTHON_VERSION"

log "Instalando Poetry..."
curl -sSL https://install.python-poetry.org | python3 -

ok "Python $(python3 --version) pronto!"
