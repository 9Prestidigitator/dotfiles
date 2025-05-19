#
# ~/.bash_profile
#

export PATH="$HOME/.local/bin:$PATH"

startx11() {
  # X11 env variables
  export GDK_SCALE=1 # Use this to increase most GUI app scale
  export GDK_DPI_SCALE=1
  export QT_SCALE_FACTOR=1
  export QT_AUTO_SCREEN_SCALE_FACTOR=0
  GTK_THEME=Adwaita:dark
  export XCURSOR_THEME=capitaine-cursors
  # export XCURSOR_SIZE=36 # The auto-setter for this is p good
  exec startx
}

startway() {
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  exec Hyprland
}

# Only run on TTY1 through TTY9, and only if not in a graphical session
if [[ -z $DISPLAY ]] && [[ $(tty) =~ /dev/tty[1-9]$ ]]; then
  declare -A sessions

  # Dynamically build available options
  sessions["0"]="Stay in TTY"
  [[ -x $(command -v startx) ]] && sessions["1"]="X11 (dwm)"
  [[ -x $(command -v Hyprland) ]] && sessions["2"]="Wayland (Hyprland)"

  echo -e "\n\e[4m\e[1mSelect a session to start:\033[0m"
  for i in "${!sessions[@]}"; do
    echo "  [$i] ${sessions[$i]}"
  done

  # Countdown with prompt
  echo
  echo -n "Enter choice (0-${#sessions[@]}) within "

  choice=""
  for ((i = 5; i > 0; i--)); do
    echo -ne "\rEnter choice (0-${#sessions[@]}) within $i seconds: "
    read -t 1 -n 1 choice
    if [[ -n $choice ]]; then
      echo # Move to new line after key press
      break
    fi
  done

  # Handle choice or fallback
  case "$choice" in
  0)
    echo "Staying in terminal."
    clear
    ;;
  1)
    echo "Starting X11 (dwm)..."
    # X11 variables
    startx11
    ;;
  2)
    echo "Starting Hyprland..."
    startway
    ;;
  *)
    echo "No input or invalid selection. Starting default..."
    startx11
    ;;
  esac
fi

# [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

[[ -f ~/.bashrc ]] && . ~/.bashrc
