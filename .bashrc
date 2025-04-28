#
# ~/.bashrc
#

fastfetch

eval "$(starship init bash)"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -a --color=auto'
alias grep='grep --color=auto'
alias v='nvim'

PS1='[\u@\h \W]\$ '

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

