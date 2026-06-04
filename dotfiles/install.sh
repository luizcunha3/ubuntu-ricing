#!/usr/bin/env bash
set -euo pipefail

log()     { echo -e "\033[0;36m[dotfiles]\033[0m $*"; }
ok()      { echo -e "\033[0;32m[ ok]\033[0m $*"; }
warn()    { echo -e "\033[1;33m[warn]\033[0m $*"; }
skipped() { echo -e "\033[0;90m[--]\033[0m $1 já instalado — pulando."; }

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    warn "Backup: $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sf "$src" "$dst"
  ok "  link: $dst"
}

# ── Zsh ─────────────────────────────────────────────────────────────
if command -v zsh &>/dev/null; then
  skipped "zsh ($(zsh --version | cut -d' ' -f1-2))"
else
  log "Instalando zsh..."
  sudo apt-get install -y zsh
fi

# ── Links simbólicos ────────────────────────────────────────────────
log "Criando links simbólicos..."
link "$DOTFILES/.zshrc"                          "$HOME/.zshrc"
link "$DOTFILES/config/kitty/kitty.conf"         "$HOME/.config/kitty/kitty.conf"
link "$DOTFILES/config/starship/starship.toml"   "$HOME/.config/starship/starship.toml"
link "$DOTFILES/config/zsh/aliases.zsh"          "$HOME/.config/zsh/aliases.zsh"

# ── Oh My Zsh ───────────────────────────────────────────────────────
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  skipped "Oh My Zsh"
else
  log "Instalando Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended --keep-zshrc
fi

# ── Plugins Oh My Zsh ───────────────────────────────────────────────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_plugin() {
  local name="$1" repo="$2"
  local dest="$ZSH_CUSTOM/plugins/$name"
  if [[ -d "$dest" ]]; then
    skipped "plugin: $name"
  else
    log "Instalando plugin: $name"
    git clone --depth=1 "$repo" "$dest"
  fi
}

clone_plugin "zsh-autosuggestions"     "https://github.com/zsh-users/zsh-autosuggestions"
clone_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"

# ── Starship ────────────────────────────────────────────────────────
if command -v starship &>/dev/null; then
  skipped "Starship ($(starship --version | head -1))"
else
  log "Instalando Starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

# ── Kitty ───────────────────────────────────────────────────────────
if command -v kitty &>/dev/null || [[ -f "$HOME/.local/kitty.app/bin/kitty" ]]; then
  skipped "Kitty ($(kitty --version 2>/dev/null || echo 'instalado'))"
else
  log "Instalando Kitty..."
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  mkdir -p "$HOME/.local/bin"
  ln -sf "$HOME/.local/kitty.app/bin/kitty"  "$HOME/.local/bin/kitty"
  ln -sf "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"
fi

# ── Ferramentas CLI via apt ─────────────────────────────────────────
apt_tool() {
  local pkg="$1" cmd="${2:-$1}"
  if command -v "$cmd" &>/dev/null; then
    skipped "$pkg"
  else
    log "Instalando $pkg..."
    sudo apt-get install -y "$pkg"
  fi
}

apt_tool "bat"     "batcat"
apt_tool "fd-find" "fdfind"
apt_tool "ripgrep" "rg"
apt_tool "fzf"
apt_tool "zoxide"
apt_tool "btop"

# Ubuntu renomeia bat → batcat e fd → fdfind; cria atalhos em ~/.local/bin
mkdir -p "$HOME/.local/bin"
if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
  ok "  link: bat → batcat"
fi
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  ok "  link: fd → fdfind"
fi

# ── eza ─────────────────────────────────────────────────────────────
if command -v eza &>/dev/null; then
  skipped "eza ($(eza --version | head -1))"
else
  log "Instalando eza..."
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
  sudo apt-get update -qq && sudo apt-get install -y eza
fi

# ── Shell padrão → zsh ──────────────────────────────────────────────
# Usa getent para checar o shell real do usuário, não a var $SHELL do processo
REAL_SHELL=$(getent passwd "$USER" | cut -d: -f7)
ZSH_PATH=$(command -v zsh)
if [[ "$REAL_SHELL" == "$ZSH_PATH" ]]; then
  skipped "shell padrão (já é zsh: $ZSH_PATH)"
else
  log "Mudando shell padrão para zsh..."
  chsh -s "$ZSH_PATH"
fi

ok "Dotfiles concluído!"
