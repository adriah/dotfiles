#!/bin/sh

#Rice
setxkbmap no			          &
compton --config ~/.compton.conf -b       &
xset +fp /home/desiderius/dwm		  &
xset +fp /usr/share/fonts/misc		  &
xrdb -merge ~/.Xresources                 &
nitrogen --restore                        &
volnoti					  &
xbindkeys				  &
xautolock -time 5 -locker '/bin/sh Scripts/lock' &

#Things.
wmname LG3D                               &
xrandr --dpi 160		          &

#DWM with statusbar
exec $HOME/Scripts/dwm-start

