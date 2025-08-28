#\bin\bash

# takes replaces terms/atoms in the Answer by their corresponding interpreted values from the Assignment
# TODO currently works only when there is a single answer

output=$(cat)

answer=$(echo "$output" | grep -A1 "Answer:" | grep -v "Answer:")
answer_AsLines=$(echo "$answer" | sed 's|) |)\n|g')
assignment_AsLines=$(echo "$output" | grep -A1 "Assignment:" | grep -v "Assignment:" | sed 's|\([0-9]\) |\1\n|g')

newAnswer_AsLines=$(echo "$answer_AsLines")
for assignment in $(echo "$assignment_AsLines"); do
    name=$(echo "$assignment" | cut -d = -f 1)
    value=$(echo "$assignment" | cut -d = -f 2)
    newAnswer_AsLines=$(echo "$newAnswer_AsLines" | sed "s|$name|$value|")
done

newAnswer=$(echo $newAnswer_AsLines)

echo "$output" | sed "s|$answer|$newAnswer|" | grep -v "Assignment:\|^timeAtStep"
