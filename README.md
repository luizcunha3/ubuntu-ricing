<h1 align="center">🌊 Ubuntu Ricing — Kanagawa Edition</h1>

<p align="center">
  <em>One command to turn a fresh Ubuntu GNOME install into a Kanagawa-themed developer workstation.</em>
</p>

<p align="center">
  <img src="wallpapers/great-wave.jpg" alt="Kanagawa — The Great Wave" width="820" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Ubuntu-22.04+-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" alt="Ubuntu" />
  <img src="https://img.shields.io/badge/GNOME-Desktop-4A86CF?style=for-the-badge&logo=gnome&logoColor=white" alt="GNOME" />
  <img src="https://img.shields.io/badge/Bash-Installer-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white" alt="Bash" />
  <img src="https://img.shields.io/badge/Theme-Kanagawa%20Wave-1F1F28?style=for-the-badge&labelColor=7E9CD8" alt="Kanagawa" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Prompt-Starship-DD0B78?style=flat-square&logo=starship&logoColor=white" alt="Starship" />
  <img src="https://img.shields.io/badge/Terminal-Kitty-71BEF2?style=flat-square&logo=kitty&logoColor=white" alt="Kitty" />
  <img src="https://img.shields.io/badge/Shell-zsh-F15A24?style=flat-square&logo=zsh&logoColor=white" alt="zsh" />
  <img src="https://img.shields.io/badge/made%20with-%E2%99%A5-E46876?style=flat-square" alt="Made with love" />
</p>

---

## 💡 The Idea

Setting up a new machine is tedious and easy to get wrong. This repo is a single, repeatable script
that installs the tools, applies the **Kanagawa Wave** aesthetic, and configures GNOME — so a blank
Ubuntu becomes a ready-to-code, good-looking workstation in one run.

It's built around three principles:

- **🔁 Idempotent** — every step checks before it acts. Already have Node, Rust, or Kitty? It's
  skipped. You can re-run `./install.sh` anytime without breaking things.
- **🛡️ Fault-tolerant** — if one module fails, the installer logs a warning and **keeps going** to
  the next one. App installs fall back from `apt` to Flatpak when needed.
- **🧩 Modular** — ten independent modules, each runnable on its own with `--only`. Want just the
  fonts or just the dev toolchains? Run only those.

---

## 🎨 Showcase

### Wallpapers

The Kanagawa wallpaper set ships with the repo and is applied automatically.

<table>
  <tr>
    <td align="center"><img src="wallpapers/great-wave.jpg" width="260" /><br/><sub>The Great Wave</sub></td>
    <td align="center"><img src="wallpapers/abstract-00252.png" width="260" /><br/><sub>Abstract (default)</sub></td>
    <td align="center"><img src="wallpapers/mountains-retreat.jpg" width="260" /><br/><sub>Mountains Retreat</sub></td>
  </tr>
</table>

### Kanagawa Wave palette

The whole rice — terminal, prompt, fzf, GTK accents — is tuned to this palette.

| Swatch | Name | Hex |
| :----: | :--- | :-- |
| ![](https://placehold.co/40x20/1F1F28/1F1F28.png) | Sumi Ink (background) | `#1F1F28` |
| ![](https://placehold.co/40x20/16161D/16161D.png) | Sumi Ink 0 (darker)   | `#16161D` |
| ![](https://placehold.co/40x20/2D4F67/2D4F67.png) | Wave Blue (selection)  | `#2D4F67` |
| ![](https://placehold.co/40x20/DCD7BA/DCD7BA.png) | Fuji White (foreground)| `#DCD7BA` |
| ![](https://placehold.co/40x20/C8C093/C8C093.png) | Old White              | `#C8C093` |
| ![](https://placehold.co/40x20/7E9CD8/7E9CD8.png) | Crystal Blue           | `#7E9CD8` |
| ![](https://placehold.co/40x20/7FB4CA/7FB4CA.png) | Spring Blue            | `#7FB4CA` |
| ![](https://placehold.co/40x20/98BB6C/98BB6C.png) | Spring Green           | `#98BB6C` |
| ![](https://placehold.co/40x20/E6C384/E6C384.png) | Carp Yellow            | `#E6C384` |
| ![](https://placehold.co/40x20/E46876/E46876.png) | Wave Red               | `#E46876` |
| ![](https://placehold.co/40x20/957FB8/957FB8.png) | Oni Violet             | `#957FB8` |
| ![](https://placehold.co/40x20/7AA89F/7AA89F.png) | Wave Aqua              | `#7AA89F` |

---

## 📦 What's Inside

Run order top-to-bottom. Each row is a module you can also run on its own (see [Quick Start](#-quick-start)).

| Module | What it sets up |
| :--- | :--- |
| `fonts` | JetBrains Mono Nerd Font · Inter (GNOME UI font) |
| `dev/node` | nvm · Node LTS · pnpm · TypeScript · ts-node |
| `dev/python` | pyenv · Python 3.12.4 · Poetry |
| `dev/rust` | rustup · rustfmt · clippy · rust-analyzer |
| `gnome/themes` | Papirus icons · Nordic GTK theme · Bibata Modern Ice cursor |
| `gnome/extensions` | Blur my Shell · Just Perfection · Dash to Dock · User Themes (via `gnome-tweaks` + `gext`) |
| `dotfiles` | zsh · Oh My Zsh · Starship · Kitty · bat · fd · ripgrep · fzf · zoxide · btop · eza |
| `gnome/settings` | Dark mode · fonts · touchpad · Night Light · dock & blur tuning · default browser/terminal |
| `wallpapers` | Downloads & applies the Kanagawa wallpaper set |
| `apps` | Flatpak · Discord · Steam · Google Chrome · qBittorrent · Kitty · Claude Code |

---

## 🚀 Quick Start

```bash
git clone https://github.com/luizcunha3/ubuntu-ricing.git
cd ubuntu-ricing
./install.sh
```

> **Prerequisites** (`curl`, `git`, `unzip`, `software-properties-common`) are detected and
> installed automatically by a pre-flight check — you don't need to set anything up first.

When it finishes, **log out and log back in** so the GNOME theme, extensions, and your new default
shell take full effect.

### Run a single module

Use `--only <module>` to run just one piece:

```bash
./install.sh --only fonts
./install.sh --only dev/node
./install.sh --only dev/python
./install.sh --only dev/rust
./install.sh --only gnome/themes
./install.sh --only gnome/extensions
./install.sh --only dotfiles
./install.sh --only gnome/settings
./install.sh --only wallpapers
./install.sh --only apps
```

---

## ⚙️ Customization

Everything you'll want to tweak lives under [`dotfiles/`](dotfiles), symlinked into `$HOME` so edits
in the repo stay version-controlled:

| File | Purpose |
| :--- | :--- |
| [`dotfiles/.zshrc`](dotfiles/.zshrc) | Shell setup — plugins, PATH, tool init (nvm, pyenv, starship, zoxide) |
| [`dotfiles/config/kitty/kitty.conf`](dotfiles/config/kitty/kitty.conf) | Kitty terminal — Kanagawa colors, font, tabs, keybinds |
| [`dotfiles/config/starship/starship.toml`](dotfiles/config/starship/starship.toml) | Two-line Kanagawa prompt with git/node/python/rust segments |
| [`dotfiles/config/zsh/aliases.zsh`](dotfiles/config/zsh/aliases.zsh) | All shell aliases |

### Handy aliases (a taste)

| Alias | Runs | |
| :-- | :-- | :-- |
| `ls` / `ll` / `lt` | `eza` with icons, git status, tree | modern `ls` |
| `cat` | `bat` | syntax-highlighted |
| `cd` | `zoxide` | smart jump |
| `find` → `fd`, `grep` → `rg` | faster search | |
| `top` | `btop` | prettier monitor |
| `zshrc` / `kittyrc` / `starshiprc` | open + reload that config | quick edit |

---

## 🗂️ Repository Structure

```
ubuntu-ricing/
├── install.sh              # Orchestrator — runs all modules (or --only one)
├── fonts/
│   └── fonts.sh            # Nerd Font + Inter
├── dev/
│   ├── node.sh             # nvm + Node + global packages
│   ├── python.sh           # pyenv + Python + Poetry
│   └── rust.sh             # rustup + components
├── gnome/
│   ├── themes.sh           # Papirus / Nordic / Bibata
│   ├── extensions.sh       # GNOME Shell extensions
│   └── settings.sh         # gsettings tweaks
├── dotfiles/
│   ├── install.sh          # Symlinks + Oh My Zsh + CLI tools
│   ├── .zshrc
│   └── config/
│       ├── kitty/kitty.conf
│       ├── starship/starship.toml
│       └── zsh/aliases.zsh
└── wallpapers/
    ├── wallpapers.sh       # Downloads + applies wallpaper
    └── *.jpg / *.png       # Kanagawa wallpaper set
```

---

## 🙏 Credits

This rice stands on the shoulders of these projects:

- **Kanagawa** color scheme — [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)
- **Nordic** GTK theme — [EliverLara/Nordic](https://github.com/EliverLara/Nordic)
- **Papirus** icon theme — [PapirusDevelopmentTeam](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
- **Bibata** cursor — [ful1e5/Bibata_Cursor](https://github.com/ful1e5/Bibata_Cursor)
- **Nerd Fonts** — [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts)
- **Starship** prompt — [starship.rs](https://starship.rs)
- **Kitty** terminal — [sw.kovidgoyal.net/kitty](https://sw.kovidgoyal.net/kitty/)
- **Wallpapers** — [Gurjaka/Kanagawa-Wallpapers](https://github.com/Gurjaka/Kanagawa-Wallpapers) · [philikarus/Kanagawa-wallpapers](https://github.com/philikarus/Kanagawa-wallpapers)

---

## 📄 License

A personal/educational ricing setup — use it freely, fork it, make it yours. 🌿

<p align="center"><sub>Built with Bash and a love for the Kanagawa wave.</sub></p>
