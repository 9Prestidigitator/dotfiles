
xinput set-prop "Microsoft Surface Type Cover Touchpad" "libinput Accel Speed" 0.5
xinput set-prop "Microsoft Surface Type Cover Touchpad" "libinput Natural Scrolling Enabled" 1

[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
~/.fehbg &
picom &
slstatus &
exec dwm

