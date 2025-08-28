#\bin\bash

# adds new lines to the output of clingo-lpx to improve readability

cat | sed 's|) |)\n|g' | sed 's|\([0-9]\) |\1\n|g' | sed 's|\([-+*]\)e |\1e\n|g' | sed 's|=e |=e\n|g'