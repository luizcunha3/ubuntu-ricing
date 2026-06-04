# ── Navegação ───────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# ── Substituições modernas ──────────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --icons --level=2'
alias la='eza -a --icons'
alias cat='bat --theme=base16'
alias find='fd'
alias grep='rg'
alias cd='z'
alias top='btop'

# ── Git ─────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# ── Dev ─────────────────────────────────────────────────────────────
alias py='python3'
alias pip='pip3'
alias nr='npm run'
alias nrd='npm run dev'
alias nrb='npm run build'
alias pn='pnpm'
alias pnd='pnpm dev'
alias pnb='pnpm build'
alias cr='cargo run'
alias cb='cargo build'
alias ct='cargo test'

# ── Sistema ─────────────────────────────────────────────────────────
alias df='df -h'
alias du='du -sh *'
alias ports='ss -tlnp'
alias myip='curl -s ifconfig.me && echo'
alias update='sudo apt update && sudo apt upgrade -y'
alias cls='clear'

# ── Config rápido ───────────────────────────────────────────────────
alias zshrc='${EDITOR:-nano} ~/.zshrc && source ~/.zshrc'
alias kittyrc='${EDITOR:-nano} ~/.config/kitty/kitty.conf'
alias starshiprc='${EDITOR:-nano} ~/.config/starship/starship.toml'
