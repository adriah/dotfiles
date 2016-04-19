#!/bin/bash

case "$1" in
    raise)
	# increase volume
	pamixer --increase 5
	volnoti-show `pamixer --get-volume`
	;;
    lower)
	# lower volume
	pamixer --decrease 5
	volnoti-show `pamixer --get-volume`
	;; 
    mute)
	#Mute volume
	if [ $pamixer --get-mute ] ; then
	   pamixer --unmute
	   volnoti-show `pamixer --get-volume`
	elif [ !$pamixer --get-mute ] ; then
	   pamixer --mute
	   volnoti-show `pamixer --get-volume`
	fi
esac

