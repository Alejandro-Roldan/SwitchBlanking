#!/bin/bash

###################################################################################################################
#
#  A BASH SCRIPT TO SWITCH THE SCREEN BLANKING STATE
#
#    With help from Jiving's answer in
#    https://raspberrypi.stackexchange.com/questions/752/how-do-i-prevent-the-screen-from-going-blank
#
#    The script takes a single option that can be -1 to turn the blanking ON, -0 to turn the Blanking
#    OFF and -s to switch the current state; then exits.
#
###################################################################################################################

#############
# FUNCTIONS #
#############

On () {
	# Function to turn the Blanking ON
	xset s on	# don't activate screensaver
	xset +dpms	# disable DPMS
	xset s blank	# don't blank the video device
	echo "Screen Blanking ON"
}

Off () {
	# Function to turn Blanking OFF
	xset s off
	xset -dpms
	xset s noblank
	echo "Screen Blanking OFF"
}

Switch () {
	# Function to Switch the current Blanking State
	# Get the DPMS (Display Power Managment Signaling) current state
	# "Enabled" or "Disabled"
	state=$(xset -q | grep "DPMS is" | awk '{ print $3 }')

	# Switch whatever state it returns
	if [[ $state == Enabled ]]; then
		Off
	elif [[ $state == Disabled ]]; then
		On
	fi
}

########
# MAIN #
########

while getopts '01s' option; do
	case "${option}" in
		# By using exit 0 we can make the options mutually exclusive, since it will
		# exit after the first one is executed
		0)
			Off
			exit 0
		;;
		1)
			On
			exit 0
		;;
		s)
			Switch
			exit 0
		;;
		# Usage Message
		*)
			echo "Screen Blanking Swticher Script"
			echo "Options:"
			echo " -0 Turn OFF the screen Blanking"
			echo " -1 Turn ON the screen Blanking"
			echo " -s Switch State. From ON to OFF and from OFF to On"
			exit 0
		;;
	esac
done

