# ===============================
# Zinit Installer
# ===============================
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing Zinit...%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ===============================
# Theme & Core Plugins
# ===============================

# Load OMZ Library (needed for some OMZ plugins to work)
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh

# Standard OMZ Plugins
zinit snippet OMZ::plugins/sudo
zinit snippet OMZ::plugins/thefuck
zinit snippet OMZ::plugins/extract
zinit snippet OMZ::plugins/colored-man-pages
zinit snippet OMZ::plugins/archlinux

# Fast community plugins (Syntax highlighting & Suggestions)
zinit ice lucid
zinit light jeffreytse/zsh-vi-mode

# zinit ice lucid
# zinit light marlonrichert/zsh-autocomplete

zinit ice wait"0" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait"0" lucid
zinit light zdharma-continuum/fast-syntax-highlighting

autoload -Uz compinit
compinit

zinit light Aloxaf/fzf-tab
zinit snippet OMZ::plugins/fzf/fzf.plugin.zsh
# Disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# Set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# Preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# Switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# Edit command buffer
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line # Bind to ctrl+x e

# Magic space
bindkey ' ' magic-space

# Undo
bindkey '^[u' undo

# Autoload
autoload -U add-zsh-hook
autoload zmv

# ===============================
# Environment & Editor
# ===============================
export EDITOR=nvim
export VISUAL=nvim

export HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPENDHISTORY
setopt EXTENDED_GLOB
setopt NULL_GLOB

# ===============================
# Improve tab menu
# ===============================
zstyle ':completion:*' menu select
zmodload zsh/complist
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# ===============================
# Tools Initialization
# ===============================

# Zoxide
eval "$(zoxide init --cmd cd zsh)"

# Starship 
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
(( ! ${+functions[starship_precmd]} )) && eval "$(starship init zsh)"

# ===============================
# Aliases
# ===============================

# Navigation
alias z='cd' 
alias e='exit'
alias h='history'
alias c='clear'
alias rezsh='exec zsh'
alias sl='ls'

# File Management
alias ls='eza -a --icons=always --git --group-directories-first --time-style=long-iso --color=always'
alias ll='eza -alh --icons=always --git --group-directories-first --time-style=long-iso'
alias lt='eza --tree --level=2 --icons=always --group-directories-first'
alias lsf='eza --group-directories-first --color=auto'
alias lsb='/usr/bin/ls --color=auto'

alias dl='cd ~/Downloads/'
alias dev='cd ~/Projects/'
alias cdc='cd ~ && clear'

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv --preserve-root'
alias mkdir='mkdir -p'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# File Searching
alias rg='rg --hidden'

# Editors
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias vv='nvim .'

alias lv='NVIM_APPNAME=lazyvim nvim'
alias gv='NVIM_APPNAME=gokgoknvim nvim'

alias czsh='nvim ~/dotfiles/zsh/.zshrc'
alias chis='nvim ~/.zsh_history'
alias jf='nvim justfile'

# Git
alias g='git'
alias lg='lazygit'

# Package Management (Arch)
alias i='paru -S'
alias s='paru -Ss'
alias r='paru -Rns'

alias update='sudo pacman -Syu'
alias updateaur='paru -Syu'

# Python
alias py='python3'
alias pip='python -m pip'

alias venvact='source .venv/bin/activate'
alias serve='python -m http.server 8000'

# Docker
alias d='docker'
alias dc='docker compose'

alias dps='docker ps'
alias di='docker images'

alias dcu='docker compose up'
alias dcd='docker compose down'

# Tmux
alias t='tmux'
alias ta='tmux attach'
alias tls='tmux ls'
alias tk='tmux kill-server'
alias ts='tmux new -As default'

# Monitoring & System
alias ff='fastfetch'
alias ffca='ff --config arch'
alias cf='clear && fastfetch --config arch'
alias cff='clear && fastfetch'

alias bt='btop'
alias ht='htop'

alias ports='ss -tulpen'
alias myip='curl ifconfig.me'

alias ping5='ping -c 5'
alias pingg='ping -c 5 google.com'

# Hyprland

alias hypr='hyprctl'
alias hreload='hyprctl reload'
alias hmon='hyprmon'

# Search
alias todo='rg TODO'
alias fixme='rg FIXME'

# Development Tools
alias oc='opencode'
alias f='fabric'

alias os='openspec'

alias p='pi'
alias pir='pi -r'
alias pis='pi --session'

# Terminal Toys
alias cmx='cmatrix'
alias pp='pipes.sh'
alias aqrm='asciiquarium'
alias wttr='curl wttr.in'

# Personal Utilities
alias dotf='dotfiles'

alias gdrive='rclone mount gdrive: ~/gdrive \
  --vfs-cache-mode minimal \
  --buffer-size 32M'

# ===============================
# Global Aliases
# ===============================

# Pipes
alias -g G='| rg'
alias -g GI='| rg -i'
alias -g G1='| rg -n'
alias -g GI1='| rg -in'
alias -g GV='| rg -v'
alias -g L='| less'
alias -g M='| more'
alias -g H='| head'
alias -g T='| tail'
alias -g S='| sort'
alias -g U='| uniq'
alias -g WC='| wc -l'

# Text tools
alias -g AWK='| awk'
alias -g SED='| sed'
alias -g JQ='| jq'
alias -g JQP='| jq .'
alias -g JQ0='| jq -c'
alias -g JQ1='| jq .[]'

# View helpers
alias -g NL='| nl'
alias -g C='| bat'
alias -g P='| column -t'

# Debug
alias -g V0='| cat -v'
alias -g V1='| xxd'
alias -g LOG='| tee /dev/stderr'

# Sort helpers
alias -g SC='| sort | uniq -c'
alias -g S0='| sort | uniq'
alias -g SN='| sort -n'

# Quick view
alias -g TL='| tail -n 50 | less'
alias -g TH='| head -n 50'

# Redirects
alias -g DN='> /dev/null'
alias -g NE='2> /dev/null'
alias -g NUL='> /dev/null 2>&1'

# ===============================
# Suffix Aliases
# ===============================

# Executable / interpreted languages
alias -s py='python3'
alias -s js='node'
alias -s mjs='node'
alias -s cjs='node'
alias -s ts='bun'
alias -s mts='bun'
alias -s sh='bash'
alias -s zsh='zsh'
alias -s fish='fish'
alias -s rb='ruby'
alias -s lua='lua'
alias -s pl='perl'
alias -s php='php'
alias -s awk='awk -f'
alias -s tcl='tclsh'

# Open in editor
alias -s c='$EDITOR'
alias -s h='$EDITOR'
alias -s cpp='$EDITOR'
alias -s cc='$EDITOR'
alias -s cxx='$EDITOR'
alias -s hpp='$EDITOR'
alias -s hxx='$EDITOR'
alias -s rs='$EDITOR'
alias -s go='$EDITOR'
alias -s java='$EDITOR'
alias -s kt='$EDITOR'
alias -s zig='$EDITOR'
alias -s nim='$EDITOR'
alias -s hs='$EDITOR'
alias -s ml='$EDITOR'
alias -s fs='$EDITOR'
alias -s cs='$EDITOR'
alias -s swift='$EDITOR'

# Web / markup / config files
alias -s html='$EDITOR'
alias -s css='$EDITOR'
alias -s scss='$EDITOR'
alias -s sass='$EDITOR'
alias -s xml='$EDITOR'
alias -s md='$EDITOR'
alias -s txt='$EDITOR'
alias -s tex='$EDITOR'
alias -s rst='$EDITOR'
alias -s org='$EDITOR'

# Configuration files
alias -s json='jless'
alias -s jsonc='jless'
alias -s yaml='$EDITOR'
alias -s yml='$EDITOR'
alias -s toml='$EDITOR'
alias -s ini='$EDITOR'
alias -s conf='$EDITOR'
alias -s cfg='$EDITOR'
alias -s env='$EDITOR'
alias -s lock='bat'

# Scripts and miscellaneous
alias -s vim='$EDITOR'
alias -s nvim='$EDITOR'
alias -s log='$EDITOR'

# Images
alias -s png='xdg-open'
alias -s jpg='xdg-open'
alias -s jpeg='xdg-open'
alias -s webp='xdg-open'
alias -s gif='xdg-open'
alias -s svg='xdg-open'

# Documents
alias -s pdf='xdg-open'

# Audio
alias -s mp3='xdg-open'
alias -s flac='xdg-open'
alias -s wav='xdg-open'
alias -s ogg='xdg-open'
alias -s m4a='xdg-open'

# Video
alias -s mp4='xdg-open'
alias -s mkv='xdg-open'
alias -s webm='xdg-open'
alias -s mov='xdg-open'
alias -s avi='xdg-open'

# ===============================
# Named Directories
# ===============================

hash -d dotf=~/dotfiles
hash -d rep=~/repos
hash -d dev=~/Projects
hash -d dl=~/Downloads
hash -d conf=~/.config
hash -d rde=~/ruanDezbatu

# ===============================
# Hotkey Shortcuts
# ===============================

# Git
bindkey -s '^Xga' 'git add .'
bindkey -s '^Xgc' 'git commit -m ""\C-b'
bindkey -s '^XgA' 'git commit --amend'
bindkey -s '^Xgp' 'git push'
bindkey -s '^XgP' 'git pull'
bindkey -s '^Xgs' 'git status'
bindkey -s '^Xgd' 'git diff'
bindkey -s '^Xgl' 'git log --oneline --graph --decorate --all'
bindkey -s '^Xgb' 'git switch '
bindkey -s '^XgB' 'git switch -c '
bindkey -s '^Xgr' 'git restore '
bindkey -s '^XgR' 'git reset --hard HEAD'

# Files 
bindkey -s '^Xfm' 'mkdir -p '
bindkey -s '^Xfr' 'rm -ri '
bindkey -s '^Xfc' 'cp -ir '
bindkey -s '^Xfv' 'mv -i '
bindkey -s '^Xff' 'find . -name ""\C-b'
bindkey -s '^Xfd' 'fd '

# Search 
bindkey -s '^Xrr' 'rg ""\C-b'
bindkey -s '^Xrp' 'ps aux | rg ""\C-b'

# Packages
bindkey -s '^Xpu' 'sudo pacman -Syu'
bindkey -s '^Xps' 'pacman -Ss '
bindkey -s '^Xpq' 'pacman -Qs '
bindkey -s '^Xpi' 'sudo pacman -S '
bindkey -s '^Xpr' 'yay -Rns '

# Journal/System 
bindkey -s '^Xjf' 'journalctl -f'
bindkey -s '^Xju' 'journalctl -u  -f\C-b\C-b\C-b'

# Network 
bindkey -s '^Xni' 'curl ifconfig.me'
bindkey -s '^Xnc' 'curl -I '
bindkey -s '^Xnp' 'ping google.com'

# Docker 
bindkey -s '^Xdu' 'docker compose up -d'
bindkey -s '^Xdd' 'docker compose down'
bindkey -s '^Xdl' 'docker compose logs -f'

# Python
bindkey -s '^Xyy' 'python3 '
bindkey -s '^Xyv' 'python3 -m venv .venv'
bindkey -s '^Xya' 'source .venv/bin/activate'

# SSH 
bindkey -s '^Xss' 'ssh '
bindkey -s '^Xsc' 'scp '

# Zsh
bindkey -s '^Xr' 'exec zsh'

# ===============================
# Widgets
# ===============================

clear-keep-buffer() {
    zle clear-screen
}
zle -N clear-keep-buffer
bindkey '^Xl' clear-keep-buffer

copy-command() {
    echo -n $BUFFER | wl-copy
    zle -M "Copied to clipboard"
}
zle -N copy-command
bindkey '^Xc' copy-command

# ===============================
# Functions
# ===============================

# Navigation

notmux() {
    kitty --detach zsh -c 'export ZSH_NO_TMUX=1; exec zsh'
}

dotfiles() {
    local base="$HOME/dotfiles"

    [[ -z "$1" ]] && { cd "$base"; return; }

    local matches=($base/${~1}*(N))

    if (( ${#matches[@]} == 0 )); then
        echo "No match: $1"
        return 1
    elif (( ${#matches[@]} > 1 )); then
        printf '%s\n' "${matches[@]}"
        return 1
    fi

    local target="$matches[1]"

    if [[ -d "$target/.config" ]]; then
        local configs=("$target/.config"/*(/))
        (( ${#configs[@]} == 1 )) && target="$configs[1]"
    fi

    cd "$target"
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

cdf() {
    local dir
    dir=$(find . -type d | fzf) || return
    cd "$dir"
}

y() {
    local tmp cwd
    tmp="$(mktemp -t yazi-cwd.XXXXXX)" || return

    (
        exec </dev/tty >/dev/tty 2>/dev/tty
        command yazi --cwd-file="$tmp"
    ) || {
        rm -f "$tmp"
        return
    }

    cwd="$(<"$tmp")"
    command rm -f "$tmp"

    [[ -d $cwd ]] && cd "$cwd"
}

# Git

gr() {
    local root
    root=$(git rev-parse --show-toplevel 2>/dev/null) || return
    cd "$root"
}

# Python

venv() {
    python -m venv .venv
    source .venv/bin/activate
}

mkvenv-ipynb() {
    local venv_name=${1:-venv}
    local kernel_name=${2:-$(basename "$PWD")}

    if [[ -d "$venv_name" ]]; then
        echo "Error: venv '$venv_name' already exists"
        return 1
    fi

    echo "Creating venv: $venv_name"
    python -m venv "$venv_name" || return 1

    echo "Activating venv"
    source "$venv_name/bin/activate" || return 1

    echo "Upgrading pip tooling"
    pip install -U pip setuptools wheel

    echo "Installing ipykernel"
    pip install ipykernel

    echo "Registering Jupyter kernel: Python ($kernel_name)"
    python -m ipykernel install --user \
        --name "$kernel_name" \
        --display-name "Python ($kernel_name)"
}

# Search

rgvim() {
    local query="$*"
    local choice

    choice=$(rg -il "$query" | \
        fzf -0 -1 --ansi \
        --preview "rg --context 3 --color always '$query' {}")

    [[ -n "$choice" ]] && nvim "+/${query:l}" "$choice"
}

# System Utilities

emptytrash() {
    read "?Empty trash? (y/N) " ans
    [[ $ans == y ]] && gio trash --empty
}

cacheclean() {
    echo "Safely cleaning package caches..."

    sudo find /var/cache/pacman/pkg -type f -name "*.part" -delete
    sudo find /var/cache/pacman/pkg -maxdepth 1 -type d \
        -name "download-*" -exec rm -rf {} +

    sudo paccache -rk0
    sudo pacman -Scc --noconfirm

    command -v yay >/dev/null && {
        yay -Sc --noconfirm --norebuild --cleanafter
        rm -rf ~/.cache/yay/*
    }

    command -v paru >/dev/null && {
        paru -Sc --noconfirm --norebuild --cleanafter
        rm -rf ~/.cache/paru/*
    }

    rm -rf ~/.var/app/*/cache/*

    flatpak uninstall --unused -y
    sudo journalctl --vacuum-size=100M

    echo "Cache cleaning complete!"
}

cachesize() {
    echo "Cache usage:\n"

    local total=0

    _show_size() {
        local name="$1"
        local cache_dir="$2"  
        local use_sudo="${3:-false}"
        local bytes=""
        local human="0B"

        if [[ "$use_sudo" == "true" || -e "$cache_dir" ]]; then
            if [[ "$use_sudo" == "true" ]]; then
                bytes=$(sudo du -sb "$cache_dir" 2>/dev/null)
            else
                bytes=$(command du -sb "$cache_dir" 2>/dev/null)
            fi
            
            bytes=${bytes%%[[:space:]]*}

            if [[ -n "$bytes" ]]; then
                (( total += bytes ))
                human=$(numfmt --to=iec-i --suffix=B "$bytes")
            elif [[ "$use_sudo" == "true" ]]; then
                human="unknown"
            fi
        fi

        printf "%-20s %8s\n" "$name:" "$human"
    }

    _show_size "Pacman cache"  "/var/cache/pacman/pkg"
    _show_size "Yay cache"     "$HOME/.cache/yay"
    _show_size "Paru cache"    "$HOME/.cache/paru"
    _show_size "Flatpak cache" "$HOME/.var/app"
    _show_size "Journal logs"  "/var/log/journal" "true"

    echo "------------------------------"
    printf "%-20s %8s\n" "Total:" "$(numfmt --to=iec-i --suffix=B "$total")"
}

auto_venv() {
    local dir="$PWD"
    local venv=""

    # Search current directory and parents for .venv
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.venv/bin/activate" ]]; then
            venv="$dir/.venv"
            break
        fi
        dir=$(dirname "$dir")
    done

    if [[ -n "$venv" ]]; then
        if [[ "$VIRTUAL_ENV" == "$venv" ]]; then
            return
        fi

        if [[ -n "$VIRTUAL_ENV" ]]; then
            deactivate
        fi

        echo "Activating $venv"
        source "$venv/bin/activate"

    else
        if [[ -n "$VIRTUAL_ENV" ]]; then
            echo "Deactivating $VIRTUAL_ENV"
            deactivate
        fi
    fi
}

add-zsh-hook chpwd auto_venv
auto_venv

sudo() {
    for i in "$@"; do
        [[ "$i" == "nvim" ]] && {
            echo "Use sudoedit instead"
            command sudoedit "${@[(r)nvim]+1}"
            return
        }
    done

    command sudo "$@"
}

# Encryption

gread() {
    gpg --no-symkey-cache -d "$1"
}

# Fun Commands

tlt() { toilet -f smblock "$*" -F border | lolcat; }
tltrpt() { for i in {1..50}; do tlt "$@"; done }
quote() { fortune | cowsay -f tux | lolcat }

function bp() {
    local CONFIG_DIR="$HOME/.config/bp"
    local CONFIG_FILE="$CONFIG_DIR/config"

    command mkdir -p "$CONFIG_DIR"

    # -------------------------
    # Load config or fallback
    # -------------------------
    if [[ -f "$CONFIG_FILE" ]]; then
        command source "$CONFIG_FILE"
    fi

    if [[ -z "$MASTER_DIR" ]]; then
        MASTER_DIR="$HOME/backups"
    fi

    # -------------------------
    # Helpers
    # -------------------------
    _save_config() {
        command mkdir -p "$CONFIG_DIR"
        command cat > "$CONFIG_FILE" <<EOF
MASTER_DIR="$MASTER_DIR"
EOF
    }

    _hash_target() {
        local target="$1"
        if [[ -f "$target" ]]; then
            command sha256sum "$target" | command awk '{print $1}'
        elif [[ -d "$target" ]]; then
            command find "$target" -type f -exec sha256sum {} + 2>/dev/null \
                | command sort | command sha256sum | command awk '{print $1}'
        fi
    }

    # -------------------------
    # Command parsing
    # -------------------------
    local cmd="$1"
    shift || true

    case "$cmd" in
        init)
            echo "📦 bp init"
            read -r "MASTER_DIR?Enter master backup directory: "
            command mkdir -p "$MASTER_DIR" || return 1
            _save_config
            echo "✔ Backup directory set to:"
            echo "  $MASTER_DIR"
            ;;

        add)
            local group="$1"
            shift

            [[ -z "$group" || "$#" -eq 0 ]] && {
                echo "Usage: bp add <group> <path> [path...]"
                return 1
            }

            for target in "$@"; do
                [[ ! -e "$target" ]] && {
                    echo "❌ Skipping (not found): $target"
                    continue
                }

                local name="$(command basename "$target")"
                local dest="$MASTER_DIR/$group/$name"

                command mkdir -p "$dest"
                echo "$target" > "$dest/.source"

                echo "✔ Added '$target' → group '$group'"
            done
            ;;

        remove)
            local group="$1"
            shift

            [[ -z "$group" || "$#" -eq 0 ]] && {
                echo "Usage: bp remove <group> <target> [target...]"
                return 1
            }

            for name in "$@"; do
                command rm -rf "$MASTER_DIR/$group/$name"
                echo "✖ Removed '$name' from '$group'"
            done
            ;;

        backup)
            local group=""
            local all=false
            local targets=()

            while [[ "$#" -gt 0 ]]; do
                case "$1" in
                    --all) all=true ;;
                    *)
                        [[ -z "$group" ]] && group="$1" || targets+=("$1")
                        ;;
                esac
                shift
            done

            if $all && [[ -z "$group" ]]; then
                for g in "$MASTER_DIR"/*; do
                    [[ -d "$g" ]] || continue
                    local gname="$(command basename "$g")"
                    echo "🔁 Backing up group: $gname"
                    bp backup "$gname" --all
                done
                return 0
            fi

            [[ -z "$group" ]] && {
                echo "Usage:"
                echo "  bp backup <group> <target> [target...]"
                echo "  bp backup <group> --all"
                echo "  bp backup --all"
                return 1
            }

            local group_dir="$MASTER_DIR/$group"
            [[ ! -d "$group_dir" ]] && {
                echo "❌ No such group: $group"
                return 1
            }

            if $all; then
                targets=()
                while IFS= read -r d; do
                    [[ -f "$d/.source" ]] || continue
                    targets+=("$(command basename "$d")")
                done < <(command find "$group_dir" -mindepth 1 -maxdepth 1 -type d)
            fi

            for name in "${targets[@]}"; do
                local base="$group_dir/$name"
                local source_file="$base/.source"

                [[ ! -f "$source_file" ]] && {
                    echo "❌ No source registered for '$name'"
                    continue
                }

                local source="$(command cat "$source_file")"
                [[ ! -e "$source" ]] && {
                    echo "❌ Source missing: $source"
                    continue
                }

                local current_hash="$(_hash_target "$source")"
                local last_hash_file="$base/.last_hash"

                if [[ -f "$last_hash_file" ]] \
                   && [[ "$(command cat "$last_hash_file")" == "$current_hash" ]]; then
                    echo "⏭  No changes → skipping '$name'"
                    continue
                fi

                local ts="$(command date +"%Y-%m-%d_%H-%M-%S")"
                local dest="$base/${name}_$ts"

                command mkdir -p "$dest"

                if [[ -d "$source" ]]; then
                    command cp -a "$source/." "$dest/"
                else
                    command cp -a "$source" "$dest/"
                fi

                echo "$current_hash" > "$last_hash_file"

                echo "📦 Backup created:"
                echo "  $dest"
            done
            ;;

        list)
            command tree -a -L 3 "$MASTER_DIR"
            ;;

        *)
            command cat <<EOF
bp — personal backup utility

SETUP:
  bp init
    → set or change backup master directory

ADDING TARGETS:
  bp add terminal ~/.zshrc
  bp add terminal ~/.config/starship ~/.config/hypr
  bp add configs ~/.config/nvim ~/.config/kitty

REMOVING TARGETS:
  bp remove terminal zshrc
  bp remove configs nvim kitty

BACKUPS:
  bp backup terminal zshrc
  bp backup terminal starship hypr
  bp backup terminal --all
  bp backup configs --all

LISTING:
  bp list

NOTES:
- Files & directories handled automatically
- Backups are skipped if unchanged
- Layout:
  MASTER/group/target/target_TIMESTAMP

Config file:
  ~/.config/bp/config
EOF
            ;;
    esac
}

# ===============================
# PATH
# ===============================
path=(
    $HOME/.local/bin
    $HOME/.config/emacs/bin
    $HOME/.opencode/bin
    $HOME/.npm-global/bin
    $path
)

[[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] &&
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

typeset -U path
path=($^path(N-/))

export PATH

# ===============================
# Startup info
# ===============================
# Run fastfetch only when starting a tmux pane/session
# if [ -n "$TMUX" ]; then
#     fastfetch
# fi

# Block --no-preserve-root
preexec() {
  if [[ "$1" == *"--no-preserve-root"* ]]; then
    print -P "%F{red}BLOCKED dangerous flag: --no-preserve-root%f"
    kill -INT $$
  fi
}

# Auto-start herdr
if [[ $- == *i* ]] \
   && [[ -z "$HERDR_ENV" ]] \
   && [[ -z "$TMUX" ]] \
   && [[ -z "$ZSH_NO_TMUX" ]] \
   && [[ -z "$ZSH_NO_HERDR" ]] \
   && command -v herdr >/dev/null 2>&1; then
    exec herdr
fi

# bun completions
[ -s "/home/ryan/.bun/_bun" ] && source "/home/ryan/.bun/_bun"
