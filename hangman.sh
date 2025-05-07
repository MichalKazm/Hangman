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
