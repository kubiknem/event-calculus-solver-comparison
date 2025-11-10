#!/bin/bash

# adds new lines to the output of clingo-lpx to improve readability

sed -E 's|) |)\n|g; s|([0-9]) |\1\n|g; s|([-+*])e |\1e\n|g; s|=e |=e\n|g'