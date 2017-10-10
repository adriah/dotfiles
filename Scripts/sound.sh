#!/bin/bash

case "$1" in
    raise)
	# increase volume
	pamixer --increase 5
	notify-send 'Sound' "$(pamixer --get-volume)\%"
	#volnoti-show `pamixer --get-volume`
	;;
    lower)
	# lower volume
	pamixer --decrease 5
	notify-send 'Sound' "$(pamixer --get-volume)\%"
	#volnoti-show `pamixer --get-volume`
	;; 
    mute)
	#Mute volume
	if [  $(pamixer --get-mute) = "true" ] ; then
	   pamixer --unmute
	   notify-send 'Sound' 'Unmuted'
	elif [ $(pamixer --get-mute) = "false" ] ; then
	   pamixer --mute
	   notify-send 'Sound' 'Muted'
	fi
esac

