#!/bin/bash

ROOTDIR="$(dirname "$(realpath "$0")")"

cat | $ROOTDIR/remove_grounding.sh | grep "^[+-].*$\|^[0-9]*$\|^happens.*$\|^==========$\|^Answer:.*$"