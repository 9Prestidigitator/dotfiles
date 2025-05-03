#
# ~/.bashrc
#

eval "$(starship init bash)"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Wait for terminal size to update properly
if [ -t 1 ] && [ -z "$TMUX" ] && [ -z "$FASTFETCH_RAN" ]; then
  sleep 0.1
  export FASTFETCH_RAN=1
  [ $(tput cols) -ge 84 ] && fastfetch
fi

# Aliases and functions
gaa() {
  git add .
  git commit -m "$1"
  git push
}

alias ls='ls -a --color=auto'
alias grep='grep --color=auto'
[[ -x $(command -v vim) ]] && alias v='vim'
[[ -x $(command -v nvim) ]] && alias v='nvim'
PS1='[\u@\h \W]\$ '

