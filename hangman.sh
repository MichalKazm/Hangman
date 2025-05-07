#!/bin/bash

# File containig list of words from which one will be chosen
DICTIONARY="/usr/share/dict/words"

# Randomizing a word and  getting it's length
WORD=$(grep -Ev "[[:punct:]]" "$DICTIONARY" | shuf -n 1)
LENGTH="${#WORD}"

# Convert word to uppercase
WORD=${WORD^^}

# Word split into letters
declare -a LETTERS

for (( i=0; i<LENGTH; i++ )); do
	LETTERS+=("${WORD:$i:1}")
done

# Array containing information about which letter was guessed
declare -a GUESSED

for (( i=0; i<26; i++ )); do
	GUESSED+=(0)
done

# Printing function
print() {
	clear
	for LETTER in "${LETTERS[@]}"; do
		# Change character to a value where A is 0, B is 1 and so on
		CHAR_VAL=$(printf "%d" "'$LETTER")
		CHAR_VAL=$((CHAR_VAL - 65))

		# Print the letter if it was guessed or '_' if it wasn't
		if [ "${GUESSED[CHAR_VAL]}" -eq 1 ]; then
			echo -n "$LETTER"
		else
			echo -n "_"
		fi
	done

	echo
	echo -n "Insert letter to be guessed: "
}

# Main game loop
while :
do
	print

	read GUESS

	# Check if only one letter was inserted
	if [ "${#GUESS}" -eq 1 ]; then
		# Change to upper letter
		GUESS=${GUESS^^}

		# Change letter to value where A-0, B-1, ...
		GUESS_VAL=$(printf "%d" "'$GUESS")
		GUESS_VAL=$((GUESS_VAL - 65))

		# Check if player inserted a letter
		if [[ "$GUESS_VAL" -ge 0 && "$GUESS_VAL" -le 26 ]]; then
			# Check if letter wasn't guessed previously
			if [ "${GUESSED[GUESS_VAL]}" -eq 0 ]; then
				GUESSED[$GUESS_VAL]=1
			else
				zenity --warning --text "Letter was guessed before!"
			fi
		else
			zenity --error --text "Insert only letters!"
		fi
	else
		zenity --error --text "Insert only one letter!"
	fi
done
