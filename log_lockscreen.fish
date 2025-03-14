#!/usr/bin/env fish
while true
  read X; or exit 1
  set WIFI_NAME (iwgetid -r)
  if echo "$X" | grep "boolean true" &>/dev/null
    echo "Screen   locked on "(date)" Wi-Fi:" $WIFI_NAME
  else if echo "$X" | grep "boolean false" &>/dev/null
    echo "Screen unlocked on "(date)" Wi-Fi:" $WIFI_NAME
  end
end >>$HOME/lock_screen.log
