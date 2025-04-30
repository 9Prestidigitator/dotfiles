#
# ~/.bash_profile
#

export PATH="$HOME/.local/bin:$PATH"

# X11 variables
export GDK_SCALE=2 # Use this to increase most GUI app scale
export GDK_DPI_SCALE=1
export QT_SCALE_FACTOR=2
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export XCURSOR_SIZE=36
export XCURSOR_THEME=capitaine-cursors
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

[[ -f ~/.bashrc ]] && . ~/.bashrc
