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
esac

