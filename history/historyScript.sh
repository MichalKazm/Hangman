#!/bin/bash

# Check if there is history
if [ ! -f "history/gameHistory" ]; then
	echo "Play some games before checking history"
	exit 1
fi

# Number of games on one page
N=$(sed -n "1p" "meta/config")

# Which page to print
OFFSET=0

# Number of games in history
L=$(cat "history/gameHistory" | wc -l)

# Main loop
while :
do
	clear

	for (( i=N-1; i>=0; i-- )); do
		# Calculating index of the game
		INDEX=$(( L - i - OFFSET * N ))
		if (( INDEX > 0)); then
			# Get correct game from history
			LINE=$(sed -n "${INDEX}p" "history/gameHistory")

			# Get status of the game
			STATUS=$(echo "$LINE" | cut -d ";" -f 2)
			if [ "$STATUS" == "Lost" ]; then
				# Reformat the game info
				echo "$LINE" | sed -E "s/([^;]*);([^;]*);([^;]*);([^;]*);(.*)/\1\nStatus: \2\nCorrect word: \3\nFinal state of the word: \4\nGuesses: \5\n/"
			else
				# Reformat the game info
				echo "$LINE" | sed -E "s/([^;]*);([^;]*);([^;]*);([^;]*);([^;]*);(.*)/\1\nStatus: \2\nCorrect word: \3\nGuesses: \4\nIncorrect guesses: \5\nScore: \6\n/"
			fi
		fi
	done

	# Print controls
	echo "'W' - Next page"
	echo "'S' - Previous page"
	echo "'Q' - quit"

	#Input handling
	read INPUT

	# Change to uppercase
	INPUT=${INPUT^^}

	case "$INPUT" in
		"W")
			if (( L - (OFFSET + 1) * N > 0 )); then
				((OFFSET++))
			fi
		;;
		"S")
			if [ "$OFFSET" -gt 0 ]; then
				((OFFSET--))
			fi
		;;
		"Q")
			break
		;;
	esac

done

clear
