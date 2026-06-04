#!/usr/bin/env bash
set -euo pipefail

log()  { echo -e "\033[0;36m[dotfiles]\033[0m $*"; }
ok()   { echo -e "\033[0;32m[ ok]\033[0m $*"; }
warn() { echo -e "\033[1;33m[ warn]\033[0m $*"; }

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    warn "Backup: $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sf "$src" "$dst"
  ok "  $dst"
}

log "Criando links simbólicos..."
link "$DOTFILES/.zshrc"                          "$HOME/.zshrc"
link "$DOTFILES/config/kitty/kitty.conf"         "$HOME/.config/kitty/kitty.conf"
link "$DOTFILES/config/starship/starship.toml"   "$HOME/.config/starship/starship.toml"
link "$DOTFILES/config/zsh/aliases.zsh"          "$HOME/.config/zsh/aliases.zsh"

# Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Instalando Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended --keep-zshrc
fi

# Plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_plugin() {
  local name="$1" repo="$2"
  local dest="$ZSH_CUSTOM/plugins/$name"
  if [[ ! -d "$dest" ]]; then
    log "Instalando plugin: $name"
    git clone --depth=1 "$repo" "$dest"
  else
    ok "Plugin já existe: $name"
  fi
}

clone_plugin "zsh-autosuggestions"   "https://github.com/zsh-users/zsh-autosuggestions"
clone_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"

# Starship
if ! command -v starship &>/dev/null; then
  log "Instalando Starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
else
  ok "Starship já instalado"
fi

# Kitty
if ! command -v kitty &>/dev/null; then
  log "Instalando Kitty..."
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  mkdir -p "$HOME/.local/bin"
  ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
  ln -sf "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"
else
  ok "Kitty já instalado"
fi

# Ferramentas CLI modernas
log "Instalando ferramentas CLI modernas..."
sudo apt-get install -y bat fd-find ripgrep fzf zoxide btop 2>/dev/null || true

# Ubuntu renomeia bat → batcat e fd → fdfind
if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
fi
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

# eza
if ! command -v eza &>/dev/null; then
  log "Instalando eza..."
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
  sudo apt-get update -qq && sudo apt-get install -y eza
else
  ok "eza já instalado"
fi

# Mudar shell padrão para zsh
if [[ "$SHELL" != "$(command -v zsh)" ]]; then
  log "Mudando shell padrão para zsh..."
  sudo apt-get install -y zsh
  chsh -s "$(command -v zsh)"
fi

ok "Dotfiles instalados!"
