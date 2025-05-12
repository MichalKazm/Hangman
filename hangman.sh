# Clearing screen before displaying anything
clear

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
