#!/bin/bash

# Number of possible wrong guesses
LIVES=6

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

	# Print ascii hangman
	cat "files/ascii/$LIVES"
	echo ""

	# Print current state of the word
	for LETTER in "${LETTERS[@]}"; do
		# Change character to a value where A is 0, B is 1 and so on
		CHAR_VAL=$(printf "%d" "'$LETTER")
		CHAR_VAL=$((CHAR_VAL - 65))

		# Print the letter if it was guessed or '_' if it wasn't
		if [ "${GUESSED[$CHAR_VAL]}" -eq 1 ]; then
			echo -n "$LETTER"
		else
			echo -n "_"
		fi
	done

	echo ""
	echo ""
	echo -n "Insert letter to be guessed: "
}

# End game check
isGuessed() {
	for LETTER in "${LETTERS[@]}"; do
                # Change character to a value where A is 0, B is 1 and so on
                CHAR_VAL=$(printf "%d" "'$LETTER")
                CHAR_VAL=$((CHAR_VAL - 65))

                # Check if there is an unguessed letter
                if [ "${GUESSED[$CHAR_VAL]}" -eq 0 ]; then
                        return 1
                fi
        done

	return 0
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

				# Check if guess was correct
				if [[ "$WORD" != *"$GUESS"* ]]; then
					((LIVES--))
				fi
			else
				zenity --warning --text "Letter was guessed before!"
				((LIVES--))
			fi
		else
			zenity --error --text "Insert only letters!"
			((LIVES--))
		fi
	else
		zenity --error --text "Insert only one letter!"
		((LIVES--))
	fi

	if [ "$LIVES" -le 0 ]; then
		# Every letter that was guessed during the game which will be displayed in end message
                GUESSED_LETTERS=""
                N_GUESSED=0
                for (( i=0; i<26; i++ )); do
                        if [ "${GUESSED[$i]}" -eq 1 ]; then
                                GUESSED_LETTERS+=$(printf \\$(printf "%03o" $(( i + 65))))
                                GUESSED_LETTERS+=", "
                                ((N_GUESSED++))
                        fi
		done

               	# If there was a guessed letter remove the ', ' after last letter
               	if [ "$GUESSED_LETTERS" != "" ]; then
                       	GUESSED_LETTERS=${GUESSED_LETTERS::-2}
               	fi

		# Final version of the word before the end of the game
		FINAL_WORD=""
		for LETTER in "${LETTERS[@]}"; do
               		# Change character to a value where A is 0, B is 1 and so on
               		CHAR_VAL=$(printf "%d" "'$LETTER")
               		CHAR_VAL=$((CHAR_VAL - 65))

               		# Print the letter if it was guessed or '_' if it wasn't
               		if [ "${GUESSED[$CHAR_VAL]}" -eq 1 ]; then
               	        	FINAL_WORD+="$LETTER"
               		else
               	        	FINAL_WORD+="_"
               		fi
       		done

		# Refresh screen
		print

		# End message
		zenity --error \
               	--title "YOU LOST" \
               	--width=300 \
               	--height=200 \
              	--text "Unfortuanately you run out of guesses and lost the game.\n\nCorrect word: $WORD\nFinal state of the word:$FINAL_WORD\nYour guesses: $GUESSED_LETTERS"

		# Saving game to history
		printf "%s" "$(date)" >> files/gameHistory
		echo ";Lost;$WORD;$FINAL_WORD;$GUESSED_LETTERS" >> files/gameHistory

		break
	fi

	if isGuessed; then
		# Every letter that was guessed during the game which will be displayed in end message
		GUESSED_LETTERS=""
		N_GUESSED=0
		for (( i=0; i<26; i++ )); do
			if [ "${GUESSED[$i]}" -eq 1 ]; then
				GUESSED_LETTERS+=$(printf \\$(printf "%03o" $(( i + 65))))
				GUESSED_LETTERS+=", "
				((N_GUESSED++))
			fi
		done

		# If there was a guessed letter remove the ', ' after last letter
		if [ "$GUESSED_LETTERS" != "" ]; then
			GUESSED_LETTERS=${GUESSED_LETTERS::-2}
		fi

		# Number of incorrect guesses
		LOST_LIVES=$(( 6 - LIVES ))

		# Calculating score (100 points for each letter of the word, 200 points for each unique letter of the word, -50 points for each incorrect guess)
		SCORE=$(( LENGTH * 100 + $(printf "%s\n" "${LETTERS[@]}" | sort -u | wc -l) * 200 - LOST_LIVES * 50 ))

		# Refresh screen
		print

		# End message
		zenity --info \
		--title "YOU WIN" \
		--width=300 \
		--height=200 \
		--text "Congratulations, you won the game!\n\nCorrect word: $WORD\nYour guesses: $GUESSED_LETTERS\nIncorrect guesses: $LOST_LIVES\nScore: $SCORE"

		# Saving game to history
		printf "%s" "$(date)" >> files/gameHistory
                echo ";Won;$WORD;$GUESSED_LETTERS;$LOST_LIVES;$SCORE" >> files/gameHistory

		break
	fi
done

clear
