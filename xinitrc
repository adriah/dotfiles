#!/bin/sh

#Rice
setxkbmap no			          &
compton --config ~/.compton.conf -b       &
xset +fp /home/desiderius/dwm		  &
xset +fp /usr/local/share/fonts/terminus  &
xrdb -merge ~/.Xresources                 &
nitrogen --restore                        &
xbindkeys				  &

#Things.
wmname LG3D                               &
xrandr --dpi 96			          &

#DWM with statusbar
exec $HOME/Scripts/dwm-start

