#!/usr/bin/env fish
while true
  read X; or exit 1
  if echo "$X" | grep "boolean true" &>/dev/null
    echo "Screen   locked on "(date)
  else if echo "$X" | grep "boolean false" &>/dev/null
    echo "Screen unlocked on "(date)
  end
end >$HOME/lock_screen.log
