# Very basic replacement for the "format-output"
# Separates output to lines, greps holdsAt and happens, then sorts them based on time.
# Only works well up to time 9.

sed 's| |\n|g' | grep "holdsAt\|happens" | rev | sort | rev | sed 's|holdsAt|  holdsAt|'