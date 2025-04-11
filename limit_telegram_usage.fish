#!/usr/bin/fish

set TARGET_APP "telegram-desktop"
set TIME_LIMIT_BEFORE_BLOCK_SEC 600
set BLOCK_TIME_SEC 3600
# set TIME_LIMIT_BEFORE_BLOCK_SEC 60
# set BLOCK_TIME_SEC 120

set CONTINUOS_INACTIVE_TIME_SEC 0
set ACTIVE_TIME_SEC 0
set LAST_CHECK_TIME_SEC (date +%s)

while true
    set CURRENT_TIME_SEC (date +%s)
    set TIME_DIFF (math $CURRENT_TIME_SEC - $LAST_CHECK_TIME_SEC)
    set LAST_CHECK_TIME_SEC $CURRENT_TIME_SEC

    # Get the ID of the currently active window
    set ACTIVE_WINDOW (xdotool getactivewindow)

    # Check if xdotool succeeded
    if test $status -ne 0
        # If xdotool fails (e.g., due to lock or suspension), increment inactive time by TIME_DIFF
        set CONTINUOS_INACTIVE_TIME_SEC (math $CONTINUOS_INACTIVE_TIME_SEC + $TIME_DIFF)
        sleep 1
        continue
    end

    # Get the name or class of the active window
    set WINDOW_NAME (xprop -id $ACTIVE_WINDOW | grep "WM_CLASS(STRING)")

    # Check if the active window is your target application
    if string match -q "*$TARGET_APP*" $WINDOW_NAME
        if test $ACTIVE_TIME_SEC -ge $TIME_LIMIT_BEFORE_BLOCK_SEC
            # Telegram should be blocked, do not reset CONTINUOS_INACTIVE_TIME_SEC
            killall $TARGET_APP
            set REMAINING_BLOCK_TIME (math $BLOCK_TIME_SEC - $CONTINUOS_INACTIVE_TIME_SEC)
            set REMAINING_BLOCK_TIME_MIN (math "floor($REMAINING_BLOCK_TIME / 60)")
            zenity --info --text="Telegram is blocked. Time left until unblock: $REMAINING_BLOCK_TIME_MIN minutes" &
            sleep 1
            continue
        end

        set ACTIVE_TIME_SEC (math $ACTIVE_TIME_SEC + $TIME_DIFF)
        set CONTINUOS_INACTIVE_TIME_SEC 0
        # echo "Active: " $ACTIVE_TIME_SEC

        if test $ACTIVE_TIME_SEC -ge $TIME_LIMIT_BEFORE_BLOCK_SEC
            killall $TARGET_APP
            zenity --info --text="Telegram blocked for 1 hour" &
        end
    else
        # When another window is active, increment inactive time by TIME_DIFF
        set CONTINUOS_INACTIVE_TIME_SEC (math $CONTINUOS_INACTIVE_TIME_SEC + $TIME_DIFF)
        # echo "Inactive: " $CONTINUOS_INACTIVE_TIME_SEC

        if test $CONTINUOS_INACTIVE_TIME_SEC -ge $BLOCK_TIME_SEC
            set ACTIVE_TIME_SEC 0
        end
    end

    # Wait for a second before checking again
    sleep 1
end
