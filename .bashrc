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

alias ls='ls -a --color=auto'
alias grep='grep --color=auto'
alias v='nvim'
alias rk='sudo systemctl restart keyd'
PS1='[\u@\h \W]\$ '

gaa() {
  git add .
  git commit -m $1
  git push
}
