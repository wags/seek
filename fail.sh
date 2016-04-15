#!/bin/bash

# Demonstrate some problems that can be caught with ShellCheck
# Samples are from the [Gallery of bad code](https://github.com/koalaman/shellcheck/blob/master/README.md#gallery-of-bad-code)

var = 42                          # Spaces around = in assignments
$foo=42                           # $ in assignments
var$n="Hello"                     # Wrong indirect assignment
echo ${var$n}                     # Wrong indirect reference
var=(1, 2, 3)                     # Comma separated arrays
echo "Argument 10 is $10"         # Positional parameter misreference
if $(myfunction); then ..; fi     # Wrapping commands in $()
[[ -z $(find /tmp | grep mpg) ]]  # Use grep -q instead
a >> log; b >> log; c >> log      # Use a redirection block instead
echo "The time is `date`"         # Use $() instead
echo $[1+2]                       # Use standard $((..)) instead of old $[]
echo $(($RANDOM % 6))             # Don't use $ on variables in $((..))
echo "$(date)"                    # Useless use of echo
cat file | grep foo               # Useless use of cat
