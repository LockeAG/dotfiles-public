
############################################
#  ███████╗███████╗██╗  ██╗██████╗  ██████╗
#  ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#    ███╔╝ ███████╗███████║██████╔╝██║     
#   ███╔╝  ╚════██║██╔══██║██╔══██╗██║     
#  ███████╗███████║██║  ██║██║  ██║╚██████╗
#  ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
#  https://www.zsh.org/
############################################

# Start of ZSH configuration

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  if [[ "$TMUX" == "" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" || echo "Failed to source p10k instant prompt"
  else
    # Skip p10k instant prompt when in tmux
    echo "Skipping p10k instant prompt in tmux session"
  fi
fi



# Zinit Installation and Setup
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing Zinit...%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Zinit Plugins and OMZ Libraries
zinit light-mode for \
    zdharma-continuum/zinit-annex-rust \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-bin-gem-node

zinit wait lucid for \
    OMZL::clipboard.zsh \
    OMZL::compfix.zsh \
    OMZL::completion.zsh \
    OMZL::correction.zsh \
    OMZL::directories.zsh \
    OMZL::git.zsh \
    OMZL::grep.zsh \
    OMZL::history.zsh \
    OMZL::key-bindings.zsh \
    OMZL::spectrum.zsh \
    OMZP::git \
    OMZP::docker-compose \
    as"completion" djui/alias-tips \
    zsh-users/zsh-history-substring-search \
    light-mode zsh-users/zsh-autosuggestions \
    light-mode zdharma-continuum/fast-syntax-highlighting \
    light-mode zsh-users/zsh-completions \
    zdharma-continuum/history-search-multi-word \
    trapd00r/LS_COLORS

# Theme
eval "$(starship init zsh)"

# History Configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=290000
SAVEHIST=$HISTSIZE

# Shell Options
setopt extended_history hist_expire_dups_first hist_ignore_all_dups hist_ignore_space
setopt hist_verify inc_append_history share_history always_to_end hash_list_all
setopt completealiases complete_in_word nocorrect list_ambiguous nolisttypes listpacked automenu

# Environment Variables
export EDITOR=nvim
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export LSCOLORS=GxFxCxDxbxegedabagaced
export PEM_PATH="$HOME/Development/huawei/"
export PATH=$HOME/.local/bin:$HOME/.cargo/bin:$PATH

# Aliases
alias vim=$EDITOR
alias :hg="history | grep"
alias cd='z'
alias cat=bat
alias python="/opt/homebrew/bin/python3"
alias reload="source ~/.zshrc"
alias reload!='exec "$SHELL" -l'
alias sd="cd ~ && cd \$(find * -type d | fzf)"

alias sshrc="vim $HOME/.ssh/config"
alias tumx="vim $HOME/.tmux.conf"
alias zshrc="vim $HOME/.zshrc"
alias kittyrc="vim $HOME/.config/kitty/kitty.conf"
alias alarc="vim $HOME/.config/alacritty/alacritty.toml"
alias wezrc="vim $HOME/.wezterm.lua"

alias vi="nvim"

alias docker-compose="docker compose"
alias dcupdfb="docker compose up -d --force-recreate --no-deps --build"
alias dcpurge="docker ps -q | xargs -r docker stop && docker ps -aq | xargs -r docker rm && docker images -q | xargs -r docker rmi"


alias tf="terraform"
alias dev="cd $HOME/Development/"
alias proy="cd $HOME/Development/projects/"
alias MyBook="cd /Volumes/MyBook"

# Conditional Aliases (eza)
if type eza >/dev/null 2>&1; then
    alias ls="eza --icons --git"
    alias l='eza -alg --color=always --group-directories-first --git'
    alias ll='eza -aliSgh --color=always --group-directories-first --icons --header --long --git'
    alias lt='eza -@alT --color=always --git'
    alias llt="eza --oneline --tree --icons --git-ignore"
    alias lr='eza -alg --sort=modified --color=always --group-directories-first --git'
else
    alias l='ls -alh --group-directories-first'
    alias ll='ls -al --group-directories-first'
    alias lr='ls -ltrh --group-directories-first'
fi

# Key Bindings
bindkey '^Y' yy-widget

# Functions
ip-internal() { echo "Wireless :: IP => $( ipconfig getifaddr en0 )" }
ip-external() { echo "External :: IP => $( curl --silent https://ifconfig.me )" }
myip() { ip-internal && ip-external }

# Function to create a ZLE widget for yy
yy-widget() {
    zle push-line # Store current line
    BUFFER="yy"   # Set buffer to yy command
    zle accept-line # Execute the command
}
zle -N yy-widget  # Create the widget

# Function to reload zshrc (to be called from tmux)
reload_zshrc() {
    source ~/.zshrc
    echo "zshrc reloaded!"
}


tmuxcd() {
    session_name=$(pwd | sed 's/.*\///g')
    if tmux has-session -t "$session_name" 2>/dev/null; then
        echo "Session '$session_name' already exists. Attaching to it..."
        tmux attach -t "$session_name"
    else
        echo "Creating new session '$session_name'."
        tmux new -s "$session_name"
    fi
}

yy() {
    local tmp="$(mktemp -t "yazi-cwd.xxxxxx")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# FZF Configuration
eval "$(fzf --zsh)"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --preview 'bat --color=always {}' \
  --preview-window=right:50% \
  --bind alt-j:down,alt-k:up \
  --color=bg+:#2e3c64,bg:#1f2335,border:#29a4bd,fg:#c0caf5,gutter:#1f2335,header:#ff9e64,hl+:#2ac3de,hl:#2ac3de,info:#545c7e,marker:#ff007c,pointer:#ff007c,prompt:#2ac3de,query:#c0caf5:regular,scrollbar:#29a4bd,separator:#ff9e64,spinner:#ff007c"

export FZF_CTRL_R_COMMAND="fd --preview --reverse --color=always {}"
export FZF_CTRL_T_COMMAND="fd --hidden --exclude '.git' --exclude 'node_modules'"
export FZF_ALT_C_COMMAND="fd --hidden --exclude '.git' --exclude 'node_modules' --type d"
export FZF_TMUX_OPTS='-p 55%,60%'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Additional Tools
eval "$(thefuck --alias)"
eval $(thefuck --alias fk)
eval "$(zoxide init zsh)"

# Local Configuration
[ -f $HOME/.localrc ] && source $HOME/.localrc
