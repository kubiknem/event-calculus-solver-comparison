#!/bin/bash

# takes replaces terms/atoms in the Answer by their corresponding interpreted values from the Assignment

MODE="Skip"
ANSW_HEAD=""

while IFS= read LINE
    do
        case "$LINE" in
            Answer:*)
                echo "$LINE"
                MODE="Answer"
                ;;
            Assignment:*)
                MODE="Assignment"
                ;;
            *)
                if [ $MODE = "Answer" ]; then
                    answer_AsLines=$(echo "$LINE" | sed 's|) |)\n|g')
                    MODE="Skip"
                elif [ $MODE = "Assignment" ]; then
                    assignment_AsLines=$(echo "$LINE" | sed 's|\([0-9]\) |\1\n|g')
                    newAnswer_AsLines=$(echo "$answer_AsLines")
                    for assignment in $(echo "$assignment_AsLines"); do
                        name=$(echo "$assignment" | cut -d = -f 1)
                        value=$(echo "$assignment" | cut -d = -f 2)
                        newAnswer_AsLines=$(echo "$newAnswer_AsLines" | sed "s|$name|$value|")
                    done
                    newAnswer=$(echo $newAnswer_AsLines)
                    echo "$newAnswer"
                    MODE="Skip"
                else
                    echo "$LINE"
                fi
                ;;
        esac

	done