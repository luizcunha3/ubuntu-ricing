# ── Oh My Zsh ───────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # Starship cuida do prompt

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
  fzf
  colored-man-pages
  command-not-found
)

source "$ZSH/oh-my-zsh.sh"

# ── PATH local ──────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── nvm (Node) ──────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ]             && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ]    && \. "$NVM_DIR/bash_completion"

# ── pyenv (Python) ──────────────────────────────────────────────────
export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]]           && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv &>/dev/null         && eval "$(pyenv init -)"

# ── Rust ────────────────────────────────────────────────────────────
[ -f "$HOME/.cargo/env" ]            && source "$HOME/.cargo/env"

# ── Starship ────────────────────────────────────────────────────────
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
command -v starship &>/dev/null      && eval "$(starship init zsh)"

# ── zoxide (cd inteligente) ─────────────────────────────────────────
command -v zoxide &>/dev/null        && eval "$(zoxide init zsh)"

# ── FZF ─────────────────────────────────────────────────────────────
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="
  --color=fg:#DCD7BA,fg+:#C8C093,bg:#1F1F28,bg+:#2A2A37
  --color=hl:#7E9CD8,hl+:#7FB4CA,info:#727169,border:#16161D
  --color=prompt:#957FB8,pointer:#D27E99,marker:#98BB6C,spinner:#6A9589
  --layout=reverse --border=rounded --padding=1 --margin=1
"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ── Editor ──────────────────────────────────────────────────────────
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='bat --plain'

# ── Aliases ─────────────────────────────────────────────────────────
[[ -f "$HOME/.config/zsh/aliases.zsh" ]] && source "$HOME/.config/zsh/aliases.zsh"

# ── History ─────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# ── Autosuggestions ─────────────────────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#727169'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
