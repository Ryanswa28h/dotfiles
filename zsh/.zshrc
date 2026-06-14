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

zinit ice wait"0" lucid atinit"zpcompinit; zpcdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

zinit light Aloxaf/fzf-tab
zinit snippet OMZ::plugins/fzf/fzf.plugin.zsh
# Disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# Set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# Set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# Switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# zinit light olets/zsh-abbr

# ===============================
# Environment & Editor
# ===============================
export EDITOR=nvim
export VISUAL=nvim
export HISTFILE=~/.zsh_history

HISTSIZE=20000
SAVEHIST=20000
setopt appendhistory

# ===============================
# Improve tab menu
# ===============================
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# ===============================
# Tools Initialization
# ===============================
eval "$(zoxide init --cmd cd zsh)"

# ===============================
# Aliases
# ===============================
alias ls='eza -a --icons=always --git --group-directories-first --time-style=long-iso --color=always'
alias lt='eza --tree --level=2 --icons=always --group-directories-first'
alias ll='eza -alh --icons=always --git --group-directories-first --time-style=long-iso'
alias lsf='eza --group-directories-first --color=auto'
alias lsb='/usr/bin/ls --color=auto'

alias e='exit'
alias i='paru -S'
alias s='paru -Ss'
alias r='paru -Rns'
alias py='python3'
alias cf='clear && fastfetch --config arch'
alias cff='clear && fastfetch'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias ping='ping -c 5'
alias update='sudo pacman -Syu'
alias c='clear'
alias z='cd'
alias rm='rm -I --preserve-root'

alias venvact='source .venv/bin/activate'
alias ff='fastfetch'
alias ffca='ff --config arch'
alias bt='btop'
alias ht='htop'
alias cmx='cmatrix'
alias vim='nvim'
alias vi='nvim'
alias nv='nvim'
alias cv='nvim'
alias v='nvim'
alias f='fabric'
alias g='git'
alias lg='lazygit'
alias lv='NVIM_APPNAME=lazyvim nvim'
alias gv='NVIM_APPNAME=gokgoknvim nvim'
alias pp='pipes.sh'
alias aqrm='asciiquarium'
alias czsh='nvim ~/dotfiles/zsh/.zshrc'
alias rezsh='exec zsh'
alias chis='nvim ~/.zsh_history'
alias jf='nvim justfile'
alias oc='opencode'
alias p='pi'
alias gdrive='rclone mount gdrive: ~/gdrive \
  --vfs-cache-mode minimal \
  --buffer-size 32M'

# ===============================
# Functions
# ===============================
function tlt { toilet -f smblock "$*" -F border | lolcat }
function iuab { toilet -f smblock "i use arch btw" -F border | lolcat }
function math { toilet -f smblock "mAtH sUcKs!!!!" -F border | lolcat }
function sixseven { toilet -f smblock "67 67 67 67 67 67 67 67" -F border | lolcat }
function mreben { toilet -f smblock "MR EBEN GANTENG" -F border | lolcat }
function plsspeed { toilet -f smblock "pls speed i need this" -F border | lolcat }
function botak { toilet -f smblock "Suharto botak sam ganteng" -F border | lolcat }
function quote { fortune | cowsay -f tux | lolcat }
function gread { gpg --no-symkey-cache -d "$1" }

# Repeat commands generator
for fn in tlt math sixseven mreben plsspeed botak quote iuab; do
    eval "function ${fn}rpt { for i in {1..50}; do $fn \"\$@\"; done }"
done

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
alias dotf='dotfiles'

function emptytrash() {
  read "?Empty trash? (y/N) " ans
  [[ $ans == y ]] && gio trash --empty
}

rgvim() {
    local query="$*"
    # Use quotes around the subshell and ensure fzf doesn't get tripped up by zsh globbing
    local choice
    choice=$(rg -il "$query" | fzf -0 -1 --ansi --preview "rg --context 3 --color always '$query' {}")

    # If choice is empty, choice=$(...) returns a non-zero exit code or empty string
    if [[ -n "$choice" ]]; then
        nvim "+/${query:l}" "$choice"
    fi
}

# Navigate using yazi
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
    rm -f "$tmp"

    [[ -d $cwd ]] && cd "$cwd"
}

autocomplete () {
    zinit ice lucid
    zinit light marlonrichert/zsh-autocomplete
}

function cacheclean {
    echo "Safely cleaning package caches..."
    sudo find /var/cache/pacman/pkg -type f -name "*.part" -delete
    sudo find /var/cache/pacman/pkg -maxdepth 1 -type d -name "download-*" -exec rm -rf {} +
    sudo paccache -rk2
    sudo paccache -ruk0
    sudo pacman -Sc --noconfirm
    command -v yay >/dev/null && { yay -Sc --noconfirm --norebuild --cleanafter; rm -rf ~/.cache/yay/*; }
    command -v paru >/dev/null && { paru -Sc --noconfirm --norebuild --cleanafter; rm -rf ~/.cache/paru/*; }
    flatpak uninstall --unused -y
    sudo journalctl --vacuum-size=100M
    echo "Cache cleaning complete!"
}

function zshrcbackup {
    local backup_dir="$HOME/ruanDezbatu/backups/zshrc"
    local timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    mkdir -p "$backup_dir"
    cp ~/.zshrc "$backup_dir/zshrcbackup_$timestamp"
    echo ".zshrc backed up to $backup_dir/zshrcbackup_$timestamp"
}

function sudo() {
    for i in "$@"; do
        [[ "$i" == "nvim" ]] && { echo "⚠️ Use sudoedit instead"; command sudoedit "${@[(r)nvim]+1}"; return; }
    done
    command sudo "$@"
}

# ===============================
# PATH
# ===============================
export PATH="$HOME/.local/bin:$HOME/.config/emacs/bin:$PATH"
export PATH="/home/ryan/.opencode/bin:$PATH"
export PATH="/home/ryan/.npm-global/bin:$PATH"
[[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# ===============================
# Powerlevel10k
# ===============================
# [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
# zinit ice depth=1; zinit light romkatv/powerlevel10k

# Starship 
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
(( ! ${+functions[starship_precmd]} )) && eval "$(starship init zsh)"

# ===============================
# Startup info
# ===============================
# [[ -o interactive && -z "$SSH_CONNECTION" ]] && fastfetch
# Run fastfetch only when starting a tmux pane/session
if [ -n "$TMUX" ]; then
    fastfetch
fi

# Tmux Cheatsheet Function
tmuxcs() {
    cat << 'EOF'
 -------------------------------------------------------------------
 |  TMUX CHEATSHEET (Prefix: Ctrl + Space)                         |
 -------------------------------------------------------------------
 |  SESSIONS & CONFIG                                              |
 |  Prefix + I      : Install Plugins                              |
 |  Prefix + r      : Reload Config                                |
 |  Prefix + d      : Detach Session                               |
 -------------------------------------------------------------------
 |  PANES (Splits)                                                 |
 |  Prefix + \      : Split Vertically                             |
 |  Prefix + -      : Split Horizontally                           |
 |  Prefix + m      : Maximize/Restore Pane                        |
 |  Prefix + x      : Close pane/window                            |
 |  Ctrl + h/j/k/l  : Move between Panes (Vim style)               |
 |  Prefix + h/j/k/l: Resize Panes                                 |
 -------------------------------------------------------------------
 |  WINDOWS (Tabs)                                                 |
 |  Prefix + c      : New Window                                   |
 |  Prefix + x      : Close pane/window                            |
 |  Prefix + n/p    : Next/Previous Window                         |
 |  Prefix + 1-9    : Jump to Window #                             |
 |  COPY MODE (Vim Mode)                                           |
 |  Prefix + [      : Enter Copy Mode                              |
 |  v / y           : Start Select / Copy (Yank)                   |
 |  Prefix + P      : Paste Buffer                                 |
 -------------------------------------------------------------------
EOF
}

# automated ipynb python venv setup
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

  echo "Done."
  echo "Run: jupyter lab"
  echo "Select kernel: Python ($kernel_name)"
}

# Mirror the main screen to the given output
mirror_screen() {
    if [[ -z "$1" ]]; then
        echo "Usage: mirror_screen <output_name>"
        return 1
    fi
    local OUTPUT="$1"

    # Detect primary monitor
    local PRIMARY=$(wlr-randr | grep -w "enabled" | awk '{print $1}' | head -n1)

    if [[ -z "$PRIMARY" ]]; then
        echo "No primary monitor detected!"
        return 1
    fi

    echo "Mirroring $PRIMARY to $OUTPUT..."
    wlr-randr --output "$OUTPUT" --mode $(wlr-randr | grep "$OUTPUT" | grep -oP '\d+x\d+@\d+') --mirror "$PRIMARY"
}

# Extend the desktop to the given output (to the right of primary)
extend_screen() {
    if [[ -z "$1" ]]; then
        echo "Usage: extend_screen <output_name>"
        return 1
    fi
    local OUTPUT="$1"

    # Detect primary monitor
    local PRIMARY=$(wlr-randr | grep -w "enabled" | awk '{print $1}' | head -n1)

    if [[ -z "$PRIMARY" ]]; then
        echo "No primary monitor detected!"
        return 1
    fi

    # Get primary monitor width to position new monitor to the right
    local WIDTH=$(wlr-randr | grep "$PRIMARY" | grep -oP '\d+x\d+' | head -n1 | cut -dx -f1)

    echo "Extending desktop to $OUTPUT..."
    wlr-randr --output "$OUTPUT" --mode $(wlr-randr | grep "$OUTPUT" | grep -oP '\d+x\d+@\d+') --pos ${WIDTH}x0 --enable
}

function bp() {
    local CONFIG_DIR="$HOME/.config/bp"
    local CONFIG_FILE="$CONFIG_DIR/config"

    mkdir -p "$CONFIG_DIR"

    # -------------------------
    # Load config or fallback
    # -------------------------
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    fi

    if [[ -z "$MASTER_DIR" ]]; then
        MASTER_DIR="$HOME/backups"
    fi

    # -------------------------
    # Helpers
    # -------------------------
    _save_config() {
        mkdir -p "$CONFIG_DIR"
        cat > "$CONFIG_FILE" <<EOF
MASTER_DIR="$MASTER_DIR"
EOF
    }

    _hash_target() {
        local target="$1"
        if [[ -f "$target" ]]; then
            sha256sum "$target" | awk '{print $1}'
        elif [[ -d "$target" ]]; then
            find "$target" -type f -exec sha256sum {} + 2>/dev/null \
                | sort | sha256sum | awk '{print $1}'
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
            mkdir -p "$MASTER_DIR" || return 1
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

                local name="$(basename "$target")"
                local dest="$MASTER_DIR/$group/$name"

                mkdir -p "$dest"
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
                rm -rf "$MASTER_DIR/$group/$name"
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
                    local gname="$(basename "$g")"
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
                    targets+=("$(basename "$d")")
                done < <(find "$group_dir" -mindepth 1 -maxdepth 1 -type d)
            fi

            for name in "${targets[@]}"; do
                local base="$group_dir/$name"
                local source_file="$base/.source"

                [[ ! -f "$source_file" ]] && {
                    echo "❌ No source registered for '$name'"
                    continue
                }

                local source="$(cat "$source_file")"
                [[ ! -e "$source" ]] && {
                    echo "❌ Source missing: $source"
                    continue
                }

                local current_hash="$(_hash_target "$source")"
                local last_hash_file="$base/.last_hash"

                if [[ -f "$last_hash_file" ]] \
                   && [[ "$(cat "$last_hash_file")" == "$current_hash" ]]; then
                    echo "⏭  No changes → skipping '$name'"
                    continue
                fi

                local ts="$(date +"%Y-%m-%d_%H-%M-%S")"
                local dest="$base/${name}_$ts"

                mkdir -p "$dest"

                if [[ -d "$source" ]]; then
                    cp -a "$source/." "$dest/"
                else
                    cp -a "$source" "$dest/"
                fi

                echo "$current_hash" > "$last_hash_file"

                echo "📦 Backup created:"
                echo "  $dest"
            done
            ;;

        list)
            tree -a -L 3 "$MASTER_DIR"
            ;;

        *)
            cat <<EOF
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

# Block --no-preserve-root
preexec() {
  if [[ "$1" == *"--no-preserve-root"* ]]; then
    print -P "%F{red}BLOCKED dangerous flag: --no-preserve-root%f"
    kill -INT $$
  fi
}

# Auto-start tmux
if [[ -z "$TMUX" && -z "$ZSH_NO_TMUX" ]]; then
  if command -v tmux >/dev/null 2>&1; then
    tmux attach -t default 2>/dev/null || tmux new -s default
    exit
  fi
fi
#
# export GTK_IM_MODULE=fcitx
# export QT_IM_MODULE=fcitx
# export XMODIFIERS=@im=fcitx   
# [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
# [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
