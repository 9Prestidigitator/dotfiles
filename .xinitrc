# [[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
# xinput set-prop "Microsoft Surface Type Cover Touchpad" "libinput Accel Speed" 0.5
# xinput set-prop "Microsoft Surface Type Cover Touchpad" "libinput Natural Scrolling Enabled" 1
xrandr -s 1920x1080
~/.fehbg &
picom &
slstatus &
exec dwm

