#!/bin/bash

# Path to a config file
FILE="files/config"

# Main loop
while :
do
	# Get current settings
	CURRENT1=$(sed -n "1p" "$FILE")
	CURRENT2=$(sed -n "2p" "$FILE")

	# Display settings menu
	CHOICE=$(zenity --list --height=340 --width=200 --title "Settings" --text "Choose what to change" --column "Settings:" "Size of page in history (Current: ${CURRENT1})" "Size of ranking (Current: ${CURRENT2})" "Reset" "Exit")
	case "$CHOICE" in
		"Size of page in history (Current: ${CURRENT1})")
			NUMBER=$(zenity --entry --title "$CHOICE" --text "Number of games displayed on one page in history (Current: ${CURRENT1})" --entry-text "Please, enter a number 1 - 99")
			# Check if result is shorter than 3
			if [ "${#NUMBER}" -lt 3 ]; then
				# Check if result is a number
				if [[ "$NUMBER" =~ ^[0-9]+$ ]]; then
					# Check if number is greater than 0
					if [ "$NUMBER" -gt 0 ]; then
						# Insert changed settings
						echo "$NUMBER" > "$FILE"
						echo "$CURRENT2" >> "$FILE"
					else
						zenity --error --text "Insert number greater than 0"
					fi
				else
					zenity --error --text "Insert only numbers"
				fi
			else
				zenity --error --text "Please enter something shorter"
			fi
		;;
		"Size of ranking (Current: ${CURRENT2})")
			NUMBER=$(zenity --entry --title "$CHOICE" --text "Number of games displayed in ranking (Current: ${CURRENT2})" --entry-text "Please, enter a number 1 - 99")
			# Check if result is shorter than 3
                        if [ "${#NUMBER}" -lt 3 ]; then
				# Check if result is a number
                        	if [[ "$NUMBER" =~ ^[0-9]+$ ]]; then
                        	        # Check if number is greater than 0
                        	        if [ "$NUMBER" -gt 0 ]; then
                        	                # Insert changed settings
                        	                echo "$CURRENT1" > "$FILE"
						echo "$NUMBER" >> "$FILE"
                        	        else
                        	                zenity --error --text "Insert number greater than 0"
                        	        fi
                        	else
                        	        zenity --error --text "Insert only numbers"
                        	fi
			else
				zenity --error --text "Please enter something shorter"
			fi
		;;
		"Reset")
			printf "3\n3" > "$FILE"
		;;
		"Exit")
			break
		;;
	esac
done
