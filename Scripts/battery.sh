#!/bin/bash
#
#low battery in %
LOW_BATTERY="10"
#critical battery in % (execute action)
CRITICAL_BATTERY="3"
#sleep time 4 script
SLEEP="60"
#acpi battery name
BAT="BAT0"
#action
ACTION="/sbin/poweroff"

while [ true ]; do
		PRESENT=$(cat /sys/class/power_supply/$BAT/present | awk '{print $1}')
		if [ "$PRESENT" = "1" ]; then
			STATE=$(cat /sys/class/power_supply/$BAT/status | awk '{print $1}')
			CAPACITY=$(cat /sys/class/power_supply/$BAT/capacity)
			if [ "$CAPACITY" -lt "$LOW_BATTERY" ] && [ "$STATE" = "Discharging" ]; then
				DISPLAY=:0.0 notify-send -u critical -t 5000 "Low battery. Gib power." "remaining $CAPACITY %, shutdown @ $CRITICAL_BATTERY %"
			fi

			if [ "$CAPACITY" -lt "$CRITICAL_BATTERY" ] && [ "$STATE" = "Discharging" ]; then
				$($ACTION)
			fi
		fi
	sleep $SLEEP
done
