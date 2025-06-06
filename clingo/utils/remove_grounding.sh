#!/bin/bash

# This script expects output of "format-output" as stdin.
# Then it finds where the predicate grounding starts (line with "P" and nothing else),
# and cuts everything after this line

input=`cat`

startLines=$(echo "$input" | grep -n "^P$" | sed 's|:.*$||')
endLines=$(echo "$input" | grep -n "=========="  | sed 's|:.*$||')
lastLine=$(echo "$input" | wc -l)
lastLine=$((lastLine+2))    # bc 2 will be subtracted later

endLines=$(echo "$endLines
$lastLine" | tail -n +2)

sedCommand=""

for start in $startLines; do
    start=$((start+1))
    end=$(echo "$endLines" | head -n 1)
    end=$((end-2))
    endLines=$(echo "$endLines" | tail -n +2)

    sedCommand="$sedCommand${start},${end}d;"
done

input=$(echo "$input" | sed "$sedCommand")
input=$(echo "$input" | sed "s|^P$|P ... predicate grounding skipped ...|g")

echo "$input" 