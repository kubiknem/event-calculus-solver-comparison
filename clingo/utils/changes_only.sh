#!/bin/bash

ROOTDIR="$(dirname "$(realpath "$0")")"

# expects the output of "format-output-reworked 1"
cat |  grep "^[+-].*$\|^[0-9]*$\|^happens.*$\|^Models.*$\|^Calls.*$\|^Time.*$\|^CPU Time.*$\|^==========$\|^Answer:.*$"