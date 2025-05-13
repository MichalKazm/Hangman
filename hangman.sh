#!/bin/bash

# Clearing screen before displaying anything
clear

# Flag handling
while getopts :hvq OPT
do
	case "$OPT" in
		h)
			echo "Flags:"
			echo "'h' - Show help"
			echo "'v' - Show version and author"
			echo "'q' - Quit program"
			echo ""
			echo "Rules:"
			echo "Classic hangman game"
			echo "You get a random word that you need to guess"
			echo "You guess one letter at a time"
			echo "Every correct guess reveals every instance of that letter in the word"
			echo "Every mistake removes one life"
			echo "You have 6 lives"
			echo "Game ends after losing the last life or guessing the last letter"
			echo ""
			echo "Ranking:"
			echo "Game features score and ranking system"
			echo "Score is counted only for won games"
			echo "Points are:"
			echo "+100 points for each letter of the word"
			echo "+200 points for each unique letter of the word"
			echo "-50 points for each incorrect guess"
		;;
		v)
			echo "Hangman version 1.0 by Michal Kazmierowski"
		;;
		q)
			exit 0
		;;
		*)
			echo "Undefined option"
		;;
	esac
done

# Main menu loop
while :
do
        # Start menu
        CHOICE=$(zenity --list --height=375 --width=200 --title "Menu" --text "Choose an option" --column "Options:" "New game" "Ranking" "History" "Settings" "Exit")
        case "$CHOICE" in
                "New game")
                        scripts/game.sh
                ;;
                "Ranking")
                        scripts/ranking.sh
                ;;
                "History")
                        scripts/historyScript.sh
                ;;
                "Settings")
                        scripts/settings.sh
                ;;
                "Exit")
                        break
                ;;
        esac
done

# Clear screen after finishing
clear
