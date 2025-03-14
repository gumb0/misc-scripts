#!/usr/bin/env fish

# Cleanup Downloads folder
find /home/andrei/Downloads/ -type f -mtime +30 -exec trash {} +
# Iterate over all subdirectories in Downloads
for dir in (find /home/andrei/Downloads/ -mindepth 1 -maxdepth 1 -type d)
    # Check if the directory contains any files
    if not find "$dir" -type f | grep -q .
        # If no files are found, trash the directory
        trash "$dir"
    end
end
