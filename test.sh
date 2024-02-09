#!/usr/bin/env sh


a=+
b="${a%"${a#?}"}"

echo "a=${a} b=${b}"

if [ "$b" -ge "0" ]; then
  echo "b is greater than or equal to 0"
else
  echo "b is less than 0"
fi
