#!/bin/bash

# Path to a file with history
FILE="files/gameHistory"

# Check if there is history
if [ ! -f "$FILE" ]; then
        echo "Play some games before checking ranking"
        exit 1
fi

# Number of games in ranking
N=$(sed -n "2p" "files/config")

# Number of games in history
L=$(cat "$FILE" | wc -l)

# Create temp directory
mkdir temp

# Run through history
for (( i=1; i<=L; i++ )); do
	# Get correct game from history
        LINE=$(sed -n "${i}p" "$FILE")

	# Get status of the game
        STATUS=$(echo "$LINE" | cut -d ";" -f 2)

	# Write won games to a file
        if [ "$STATUS" == "Won" ]; then
		echo "$LINE" >> temp/games
	fi
done

# Check if there are any won games
if [ -f "temp/games" ]; then
	# Get number of won games
	N_GAMES=$(cat "temp/games" | wc -l)

	# Change number of games to be displayed if there are less won games than N
	if [ "$N_GAMES" -lt "$N" ]; then
		N="$N_GAMES"
	fi
else
	# Remove directory temp before quiting
	rm -fr temp
	echo "Win some games before checking ranking"
	exit 1
fi

# Sort won games by score
sort -t ";" -k 6 -nr "temp/games" > temp/sortedGames

clear

# Print top N games
for (( i=1; i<=N; i++ )); do
	# Get correct game
	LINE=$(sed -n "${i}p" "temp/sortedGames")

	# Reformat the game info
	echo "$LINE" | sed -E "s/([^;]*);([^;]*);([^;]*);([^;]*);([^;]*);(.*)/\1\nStatus: \2\nCorrect word: \3\nGuesses: \4\nIncorrect guesses: \5\nScore: \6\n/"
done

echo "Press 'Enter' to quit"
read

#Remove temp files
rm -fr temp

clear
